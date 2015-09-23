//
//  RecentPlaceUtilities.h
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
#import <CoreLocation/CoreLocation.h>

/**
 *  Class that handles the RecentPlace objects from the core data.
 */
@interface RecentPlaceUtilities : NSObject

/**
 *  Fetches all user's RecentPlaces from the core data. RecentPlace object is based on the search history.
 *
 *  @return Array with user's RecentPlaces.
 */
+(NSArray *)fetchPlacesFromCoreData;
/**
 *  Creates a RecentPlace with given coordinates for the current user. Recent place is based on the search query and is either destination or departure place.
 *
 *  @param name       Name of the recent place from the Google Places API
 *  @param coordinate Coordinates of the object with recent place.
 */
+(void)createRecentPlaceWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate;

@end
