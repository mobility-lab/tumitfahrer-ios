//
//  RideSearchMapping.m
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

#import "RideSearchMapping.h"

@implementation RideSearchMapping

+(RKEntityMapping *)generalRideSearchMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"RideSearch" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    
    mapping.identificationAttributes = @[@"rideSearchId"];
    [mapping addAttributeMappingsFromDictionary:@{@"id": @"rideSearchId",
                                                        @"departure_place":@"departurePlace",
                                                        @"destination":@"destination",
                                                        @"departure_time":@"departureTime",
                                                        @"ride_type":@"rideType",
                                                        @"created_at": @"createdAt",
                                                        @"updated_at": @"updatedAt"
                                                        }];
    
    return mapping;
}

@end
