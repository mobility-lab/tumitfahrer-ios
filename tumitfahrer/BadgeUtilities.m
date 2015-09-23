//
//  BadgeUtilities.m
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

#import "BadgeUtilities.h"
#import "Badge.h"

@implementation BadgeUtilities

// fetch all past rides
+(Badge *)fetchLastBadgeDateFromCoreData {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Badge"
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
    
    Badge *badge = [fetchedObjects firstObject];
    
    return badge;
}

+(void)updateTimelineDateInBadge:(NSDate*)date {
    Badge *badge = [self fetchLastBadgeDateFromCoreData];
    badge.timelineUpdatedAt = date;
    if (badge != nil) {
        [self saveBadgeToPersisentStore:badge];
    }
}

+(void)updateMyRidesDateInBadge:(NSDate*)date {
    Badge *badge = [BadgeUtilities fetchLastBadgeDateFromCoreData];
    badge.myRidesUpdatedAt = date;
    badge.myRidesBadge = [NSNumber numberWithInt:0];
    if (badge != nil) {
        [BadgeUtilities saveBadgeToPersisentStore:badge];
    }
}

+(void)updateCampusDateInBadge:(NSDate*)date {
    Badge *badge = [BadgeUtilities fetchLastBadgeDateFromCoreData];
    badge.campusUpdatedAt = date;
    badge.campusBadge = [NSNumber numberWithInt:0];
    if (badge != nil) {
        [BadgeUtilities saveBadgeToPersisentStore:badge];
    }
}

+(void)updateActivityDateInBadge:(NSDate*)date {
    Badge *badge = [BadgeUtilities fetchLastBadgeDateFromCoreData];
    badge.activityUpdatedAt = date;
    badge.activityBadge = [NSNumber numberWithInt:0];
    if (badge != nil) {
        [BadgeUtilities saveBadgeToPersisentStore:badge];
    }
}

+(void)saveBadgeToPersisentStore:(Badge *)badge {
    
    NSManagedObjectContext *context = badge.managedObjectContext;
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"saving error %@", [error localizedDescription]);
    }
}

@end
