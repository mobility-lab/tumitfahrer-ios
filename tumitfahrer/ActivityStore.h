//
//  ActivityStore.h
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
#import "LocationController.h"

@class Ride, Request;

/**
 *  The protocol that informs the delegates when new activities are received from the webservice.
 */
@protocol ActivityStoreDelegate <NSObject>

@optional

/**
 *  Inform a delegate that activities were received from the webservice.
 */
- (void)didRecieveActivitiesFromWebService;

@end

/**
 *  ActivityStore is responsible for handling all activities that are displayed in the Timelines. Specifically, the class fetches activities from the webservice, can update and delete specific activities from the local store and can load the activities from the core data.
 */
@interface ActivityStore : NSObject <LocationControllerDelegate>

+ (instancetype)sharedStore;

@property (nonatomic, strong) id <ActivityStoreDelegate> delegate;

/**
 *  Fetches activities from the webservice.
 *
 *  @param block completion handler to notify a requestor once the fetch is completed
 */
- (void)fetchActivitiesFromWebservice:(boolCompletionHandler)block;

/**
 *  Returns all timeline activities filtered by the given type.
 *
 *  @param contentType The type of timeline acitvities, such as nearby or user's activities
 *
 *  @return all activities filter by the contentType
 */
- (NSArray *)recentActivitiesByType:(TimelineContentType)contentType;

/**
 *  Read all activities from the core data.
 */
- (void)initAllActivitiesFromCoreData;

/**
 *  Deletes a specific ride from the timeline activities.
 *
 *  @param ride The ride object.
 */
- (void)deleteRideFromActivites:(Ride *)ride;

/**
 *  Deletes a specific request from the timeline activities.
 *
 *  @param request The request object.
 */
- (void)deleteRequestFromActivites:(Request *)request;

/**
 *  Updates timeline activities by fetching them from webservice.
 */
- (void)updateActivities;

@end
