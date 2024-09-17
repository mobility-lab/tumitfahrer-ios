//
//  PanoramioUtilities.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationController.h"

@class Photo;

/**
 *  Protocol for notyfing about fetching a photo
 */
@protocol PanoramioUtilitiesDelegate <NSObject>

@optional
/**
 *  Notifies about fetching an image for current location
 *
 *  @param image Image for current location.
 */
-(void)didReceivePhotoForCurrentLocation:(UIImage *)image;
/**
 *  Notifies about fetching an image for the destination of the given ride.
 *
 *  @param image  Fetched image.
 *  @param rideId Id of the ride.
 */
-(void)didReceivePhotoForLocation:(UIImage *)image rideId:(NSNumber *)rideId;

@end

/**
 *  Handles fetching photos from the Panoramio API.
 */
@interface PanoramioUtilities : NSObject <LocationControllerDelegate>

@property (nonatomic, weak) id<PanoramioUtilitiesDelegate> delegate;

typedef void(^photoCompletionHandler)(Photo *);

+ (PanoramioUtilities*)sharedInstance; // Singleton method

/**
 *  Adds observer to the Panoramio Utilities.
 *
 *  @param observer The Observer object
 */
- (void)addObserver:(id<PanoramioUtilitiesDelegate>) observer;
/**
 *  Notifies observers about fetching an image for the location.
 *
 *  @param image Image of the location.
 */
- (void)notifyWithImage:(UIImage*)image;
/**
 *  Notifies observers about fetching an image for the destination of the given ride.
 *
 *  @param image  Image object.
 *  @param rideId Id of the ride.
 */
- (void)notifyAllAboutNewImage:(UIImage *)image rideId:(NSNumber *)rideId;
/**
 *  Removes obserers from the Panoramio Utilities
 *
 *  @param observer The Observer object.
 */
- (void)removeObserver:(id<PanoramioUtilitiesDelegate>)observer;

/**
 *  Asynchronously fetches a photo for the given location.
 *
 *  @param location Location for which the photo should be fetched.
 *  @param block    The completion handler with the photo 
 */
- (void)fetchPhotoForLocation:(CLLocation *)location completionHandler:(photoCompletionHandler)block;

@end
