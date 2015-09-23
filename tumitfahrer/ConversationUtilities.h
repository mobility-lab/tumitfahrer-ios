//
//  ConversationUtilities.h
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

@class User, Conversation;

/**
 *  Class that handles and manages conversations of the ride.
 */
@interface ConversationUtilities : NSObject

/**
 *  Finds a conversation in the array of conversation between user and ohter user.
 *
 *  @param user          The User object.
 *  @param otherUser     The other User object.
 *  @param conversations Array with conversation.
 *
 *  @return The specific conversation.
 */
+(Conversation *)findConversationBetweenUser:(User *)user otherUser:(User *)otherUser conversationArray:(NSArray *)conversations;
/**
 *  Fetches a conversation from the core data.
 *
 *  @param conversationId Id of the conversation.
 *
 *  @return Fetched conversation.
 */
+ (Conversation *)fetchConversationFromCoreDataWithId:(NSNumber *)conversationId;

/**
 *  Fetches conversation from core data between two users for a give ride.
 *
 *  @param userId      Id of first user.
 *  @param otherUserId Id of the other user.
 *  @param rideId      Id of the ride.
 *
 *  @return The specific conversation.
 */
+ (Conversation *)fetchConversationFromCoreDataBetweenUserId:(NSNumber *)userId otherUserId:(NSNumber *)otherUserId rideId:(NSNumber *)rideId;

/**
 *  Checks whether the conversation has any unseen messages.
 *
 *  @param conversation The conversation object.
 *
 *  @return True if conversation has any unseen message.
 */
+ (BOOL)conversationHasUnseenMessages:(Conversation *)conversation;

/**
 *  Updated time when the conversation was last seen.
 *
 *  @param conversation The Conversation object.
 */
+ (void)updateSeenTimeForConversation:(Conversation *)conversation;

/**
 *  Saves updated conversation in the core data.
 *
 *  @param conversation The conversation object.
 */
+ (void)saveConversationToPersistentStore:(Conversation *)conversation;

@end
