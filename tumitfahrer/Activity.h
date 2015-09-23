//
//  Activity.h
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
#import <CoreData/CoreData.h>

@class Request, Ride, RideSearch;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSSet *requests;
@property (nonatomic, retain) NSSet *rides;
@property (nonatomic, retain) NSSet *rideSearches;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addRequestsObject:(Request *)value;
- (void)removeRequestsObject:(Request *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

- (void)addRidesObject:(Ride *)value;
- (void)removeRidesObject:(Ride *)value;
- (void)addRides:(NSSet *)values;
- (void)removeRides:(NSSet *)values;

- (void)addRideSearchesObject:(RideSearch *)value;
- (void)removeRideSearchesObject:(RideSearch *)value;
- (void)addRideSearches:(NSSet *)values;
- (void)removeRideSearches:(NSSet *)values;

@end
