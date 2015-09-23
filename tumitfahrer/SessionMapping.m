//
//  SessionMapping.m
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

#import "SessionMapping.h"

@implementation SessionMapping

+ (RKEntityMapping *)sessionMapping {
    RKEntityMapping *sessionMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    sessionMapping.identificationAttributes = @[ @"userId" ];
    [sessionMapping addAttributeMappingsFromDictionary:@{
                                                         @"id":             @"userId",
                                                         @"first_name":     @"firstName",
                                                         @"last_name":      @"lastName",
                                                         @"email":          @"email",
                                                         @"is_student":     @"isStudent",
                                                         @"phone_number":   @"phoneNumber",
                                                         @"car":            @"car",
                                                         @"department":     @"department",
                                                         @"api_key":        @"apiKey",
                                                         @"created_at":     @"createdAt",
                                                         @"updated_at":     @"updatedAt"}];
    
    return sessionMapping;
}

+ (RKResponseDescriptor *)postSessionResponseDescriptorWithMapping:(RKEntityMapping*)mapping {
    // create response description for user's session
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:API_SESSIONS                                                                                           keyPath:@"user"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
