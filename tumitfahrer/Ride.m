//
//  Ride.m
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

#import "Ride.h"
#import "Activity.h"
#import "Conversation.h"
#import "Photo.h"
#import "Rating.h"
#import "Request.h"
#import "User.h"


@implementation Ride

@dynamic car;
@dynamic createdAt;
@dynamic departureLatitude;
@dynamic departureLongitude;
@dynamic departurePlace;
@dynamic departureTime;
@dynamic destination;
@dynamic destinationImage;
@dynamic destinationLatitude;
@dynamic destinationLongitude;
@dynamic freeSeats;
@dynamic freeSeatsCurrent;
@dynamic isPaid;
@dynamic regularRideId;
@dynamic isRideRequest;
@dynamic lastCancelTime;
@dynamic lastSeenTime;
@dynamic meetingPoint;
@dynamic price;
@dynamic rideId;
@dynamic rideType;
@dynamic updatedAt;
@dynamic activities;
@dynamic conversations;
@dynamic passengers;
@dynamic photo;
@dynamic ratings;
@dynamic requests;
@dynamic rideOwner;

@end
