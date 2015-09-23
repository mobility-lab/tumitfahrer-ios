//
//  ConversationUtilities.m
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

#import "ConversationUtilities.h"
#import "Conversation.h"
#import "User.h"

@implementation ConversationUtilities

+(Conversation *)findConversationBetweenUser:(User *)user otherUser:(User *)otherUser conversationArray:(NSArray *)conversations {
    
    for (Conversation *conversation in conversations) {
        if (([conversation.userId isEqualToNumber:user.userId] && [conversation.otherUserId isEqualToNumber:otherUser.userId]) || ([conversation.userId isEqualToNumber:otherUser.userId] && [conversation.otherUserId isEqualToNumber:user.userId])) {
            return conversation;
        }
    }
    return nil;
}


+ (Conversation *)fetchConversationFromCoreDataWithId:(NSNumber *)conversationId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Conversation"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversationId = %@", conversationId];
    [request setPredicate:predicate];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return [fetchedObjects firstObject];
}

+ (Conversation *)fetchConversationFromCoreDataBetweenUserId:(NSNumber *)userId otherUserId:(NSNumber *)otherUserId rideId:(NSNumber *)rideId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Conversation"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.userId = %@ && self.otherUserId = %@ && self.rideId = %@) || (self.userId = %@ && self.otherUserId = %@ && self.rideId = %@)", userId, otherUserId, rideId, otherUserId, userId, rideId];
    [request setPredicate:predicate];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return [fetchedObjects firstObject];
}

+ (BOOL)conversationHasUnseenMessages:(Conversation *)conversation {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Conversation"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY messages.isSeen = NO"];
    
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }

    if ([fetchedObjects count] > 0) {
        return YES;
    }
    return NO;
}

+(void)saveConversationToPersistentStore:(Conversation *)conversation {
    NSManagedObjectContext *context = conversation.managedObjectContext;
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"saving error %@", [error localizedDescription]);
    }
}

+(void)updateSeenTimeForConversation:(Conversation *)conversation {
    conversation.seenTime = [NSDate date];
    [self saveConversationToPersistentStore:conversation];
}

@end
