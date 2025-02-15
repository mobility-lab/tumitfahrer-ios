//
//  LocationController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
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
