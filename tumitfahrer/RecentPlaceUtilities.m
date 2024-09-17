//
//  RecentPlaceUtilities.m
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

#import "RecentPlaceUtilities.h"
#import "ActionManager.h"

@implementation RecentPlaceUtilities

+(NSArray *)fetchPlacesFromCoreData {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"RecentPlace"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    request.sortDescriptors = @[descriptor];
    
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return fetchedObjects;
}

+(void)createRecentPlaceWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate {
    
    NSManagedObject *recentPlace = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"RecentPlace"
                                          inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    [recentPlace setValue:[ActionManager currentDate]  forKey:@"createdAt"];
    [recentPlace setValue:name forKey:@"placeName"];
    [recentPlace setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"placeLatitude"];
    [recentPlace setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"placeLongitude"];
    NSError *error;
    
    if (![[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
