//
//  LocationController.m
//  tumitfahrer
//
/*
 * Copyright 2015 TUM Technische Universität München
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
//

#import "LocationController.h"
#import "PanoramioUtilities.h"


@interface LocationController ()

@property (nonatomic) BOOL isLocationFetched;
@property (nonatomic, strong) NSMutableArray *observers;

@end

@implementation LocationController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {//Make it work on iOs8+
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.isLocationFetched = NO;
        self.observers = [[NSMutableArray alloc] init];
    }
    return self;
}

+(LocationController *)sharedInstance {
    static LocationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

# pragma mark - observer methods

+(BOOL)locationServicesEnabled {
    return [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
}

-(void)addObserver:(id<LocationControllerDelegate>)observer {
    [self.observers addObject:observer];
}

-(void)notifyAllAboutNewCurrentLocation {
    for (id<LocationControllerDelegate> observer in self.observers) {
        if ([observer respondsToSelector:@selector(didReceiveCurrentLocation:)]) {
            [observer didReceiveCurrentLocation:self.currentLocation];
        }
    }
}

-(void)notifyAllAboutNewLocation:(CLLocation*)location rideWithRideId:(NSNumber *)rideId {
    for (id<LocationControllerDelegate> observer in self.observers) {
        if ([observer respondsToSelector:@selector(didReceiveLocationForAddress:rideId:)]) {
            [observer didReceiveLocationForAddress:location rideId:rideId];
        }
    }
}

-(void)removeObserver:(id<LocationControllerDelegate>)observer {
    [self.observers removeObject:observer];
}

#pragma mark - location utilities

- (void)startUpdatingLocation {
    self.isLocationFetched = NO;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!self.isLocationFetched) {
        self.currentLocation = [locations lastObject];
        self.isLocationFetched = YES;
        [self notifyAllAboutNewCurrentLocation];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0)
            {
                CLPlacemark *placemark = [placemarks lastObject];
                self.currentAddress = [placemark.thoroughfare stringByAppendingString:[NSString stringWithFormat:@", %@", placemark.locality]];
            }
        }];
    }
    [self.locationManager stopUpdatingLocation];
}

# pragma mark - general functions


-(void)fetchLocationForAddress:(NSString *)address completionHandler:(locationCompletionHandler)block {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        if(error) {
            block(nil);
        } else {
            CLPlacemark *aPlacemark = [placemarks firstObject];
            
            // Process the placemark.
            CLLocation *location = [[CLLocation alloc] initWithLatitude:aPlacemark.location.coordinate.latitude longitude:aPlacemark.location.coordinate.longitude];
            block(location);
        }
    }];
}

- (void)fetchLocationForAddress:(NSString *)address rideId:(NSNumber *)rideId {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        
        CLPlacemark *aPlacemark = [placemarks firstObject];
        
        // Process the placemark.
        CLLocation *location = [[CLLocation alloc] initWithLatitude:aPlacemark.location.coordinate.latitude longitude:aPlacemark.location.coordinate.longitude];
        [self notifyAllAboutNewLocation:location rideWithRideId:rideId];
    }];
}


+(BOOL)isLocation:(CLLocation *)location nearbyAnotherLocation:(CLLocation *)anotherLocation thresholdInMeters:(NSInteger)thresholdInMeters{
    CLLocationDistance distance = [location distanceFromLocation:anotherLocation];
    if (distance < thresholdInMeters) {
        return true;
    }
    return false;
}

+ (CLLocation *)locationFromLongitude:(double)longitude latitude:(double)latitude {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    return location;
}

+ (void)resolveGecodePlaceToPlacemark:(PlacemarkBlock)block address:(NSString *)address{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            block(placemark, error);
        }
    }];
}



@end
