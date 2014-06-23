//
//  ActivityStore.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationController.h"

@class Ride, Request;

@protocol ActivityStoreDelegate <NSObject>

@optional

- (void)didRecieveActivitiesFromWebService;

@end

@interface ActivityStore : NSObject <LocationControllerDelegate>

+ (instancetype)sharedStore;

@property (nonatomic, strong) id <ActivityStoreDelegate> delegate;

- (void)fetchActivitiesFromWebservice:(boolCompletionHandler)block;
- (NSArray *)recentActivitiesByType:(TimelineContentType)contentType;
- (void)initAllActivitiesFromCoreData;
- (void)deleteRideFromActivites:(Ride *)ride;
- (void)deleteRequestFromActivites:(Request *)request;
- (void)updateActivities;

@end
