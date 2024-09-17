//
//  Badge.h
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


@interface Badge : NSManagedObject

@property (nonatomic, retain) NSNumber * timelineBadge;
@property (nonatomic, retain) NSNumber * campusBadge;
@property (nonatomic, retain) NSNumber * badgeId;
@property (nonatomic, retain) NSNumber * activityBadge;
@property (nonatomic, retain) NSNumber * myRidesBadge;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * activityUpdatedAt;
@property (nonatomic, retain) NSDate * campusUpdatedAt;
@property (nonatomic, retain) NSDate * myRidesUpdatedAt;
@property (nonatomic, retain) NSDate * timelineUpdatedAt;

@end
