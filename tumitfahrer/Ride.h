//
//  Ride.h
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

@class Activity, Conversation, Photo, Rating, Request, User;

@interface Ride : NSManagedObject

@property (nonatomic, retain) NSString * car;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * departureLatitude;
@property (nonatomic, retain) NSNumber * departureLongitude;
@property (nonatomic, retain) NSString * departurePlace;
@property (nonatomic, retain) NSDate * departureTime;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSData * destinationImage;
@property (nonatomic, retain) NSNumber * destinationLatitude;
@property (nonatomic, retain) NSNumber * destinationLongitude;
@property (nonatomic, retain) NSNumber * freeSeats;
@property (nonatomic, retain) NSNumber * freeSeatsCurrent;
@property (nonatomic, retain) NSNumber * isPaid;
@property (nonatomic, retain) NSNumber * regularRideId;
@property (nonatomic, retain) NSNumber * isRideRequest;
@property (nonatomic, retain) NSDate * lastCancelTime;
@property (nonatomic, retain) NSDate * lastSeenTime;
@property (nonatomic, retain) NSString * meetingPoint;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * rideId;
@property (nonatomic, retain) NSNumber * rideType;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Activity *activities;
@property (nonatomic, retain) NSSet *conversations;
@property (nonatomic, retain) NSSet *passengers;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) NSSet *ratings;
@property (nonatomic, retain) NSSet *requests;
@property (nonatomic, retain) User *rideOwner;
@end

@interface Ride (CoreDataGeneratedAccessors)

- (void)addConversationsObject:(Conversation *)value;
- (void)removeConversationsObject:(Conversation *)value;
- (void)addConversations:(NSSet *)values;
- (void)removeConversations:(NSSet *)values;

- (void)addPassengersObject:(User *)value;
- (void)removePassengersObject:(User *)value;
- (void)addPassengers:(NSSet *)values;
- (void)removePassengers:(NSSet *)values;

- (void)addRatingsObject:(Rating *)value;
- (void)removeRatingsObject:(Rating *)value;
- (void)addRatings:(NSSet *)values;
- (void)removeRatings:(NSSet *)values;

- (void)addRequestsObject:(Request *)value;
- (void)removeRequestsObject:(Request *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

@end
