//
//  RatingMapping.m
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

#import "RatingMapping.h"

@implementation RatingMapping

+(RKEntityMapping *)ratingMapping {
    
    RKEntityMapping *ratingMapping = [RKEntityMapping mappingForEntityForName:@"Rating" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    ratingMapping.identificationAttributes = @[@"ratingId"];
    [ratingMapping addAttributeMappingsFromDictionary:@{@"id": @"ratingId",
                                                        @"to_user_id":@"toUserId",
                                                        @"from_user_id":@"fromUserId",
                                                        @"ride_id":@"rideId",
                                                        @"rating_type":@"ratingType",
                                                        @"created_at": @"createdAt",
                                                        @"updated_at": @"updatedAt"
                                                        }];
    return ratingMapping;
}

+(RKResponseDescriptor *)postRatingResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:mapping method:RKRequestMethodPOST pathPattern:API_USERS_RATINGS keyPath:@"rating" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
