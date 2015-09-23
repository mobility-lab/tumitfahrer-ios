//
//  Rating.h
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

@class Ride;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * ratingId;
@property (nonatomic, retain) NSNumber * ratingType;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * toUserId;
@property (nonatomic, retain) NSNumber * fromUserId;
@property (nonatomic, retain) NSNumber * rideId;
@property (nonatomic, retain) Ride *ride;

@end
