//
//  BadgeMapping.m
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

#import "BadgeMapping.h"

@implementation BadgeMapping

+(RKEntityMapping *)badgeMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Badge" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"badgeId"];
    [mapping addAttributeMappingsFromDictionary:@{@"id": @"badgeId",
                                                  @"campus_badge" : @"campusBadge",
                                                  @"campus_updated_at" : @"campusUpdatedAt",
                                                  @"activity_badge" : @"activityBadge",
                                                  @"activity_updated_at" : @"activityUpdatedAt",
                                                  @"timeline_badge" : @"timelineBadge",
                                                  @"timeline_updated_at" : @"timelineUpdatedAt",
                                                  @"my_rides_badge" : @"myRidesBadge",
                                                  @"my_rides_updated_at" : @"myRidesUpdatedAt",
                                                  @"created_at" : @"createdAt"
                                                          }];
    
    
    return mapping;
}

+(RKResponseDescriptor *)getBadgesResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_ACTIVITIES_BADGES keyPath:@"badge_counter"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
