//
//  ConversationMapping.m
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

#import "ConversationMapping.h"
#import "MessageMapping.h"
#import "RideMapping.h"

@implementation ConversationMapping

+(RKEntityMapping *)conversationMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Conversation" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"conversationId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"id": @"conversationId",
                                                      @"user_id": @"userId",
                                                      @"ride_id": @"rideId",
                                                      @"other_user_id": @"otherUserId",
                                                      @"created_at": @"createdAt",
                                                      @"updated_at": @"updatedAt"
                                                      }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"messages" toKeyPath:@"messages" withMapping:[MessageMapping messageMapping]]];
    
    return mapping;
}

+(RKEntityMapping *)simpleConversationMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Conversation" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"conversationId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"id": @"conversationId",
                                                      @"user_id": @"userId",
                                                      @"ride_id": @"rideId",
                                                      @"other_user_id": @"otherUserId",
                                                      @"last_message_time" : @"lastMessageTime",
                                                      @"last_sender_id" : @"lastSenderId",
                                                      @"created_at": @"createdAt",
                                                      @"updated_at": @"updatedAt"
                                                      }];
    
    return mapping;
}


+(RKResponseDescriptor *)getConversationsResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    // create response description for rides
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_RIDES_CONVERSATIONS keyPath:@"conversations"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKResponseDescriptor *)getConversationResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    // create response description for rides
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_RIDES_CONVERSATION keyPath:@"conversation"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKResponseDescriptor *)postConversationResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    // create response description for rides
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST pathPattern:API_RIDES_CONVERSATIONS keyPath:@"conversation"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
