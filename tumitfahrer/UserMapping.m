//
//  UserMapping.m
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

#import "UserMapping.h"
#import "StatusMapping.h"
#import "RideMapping.h"

@implementation UserMapping

+(RKEntityMapping *)userMapping {
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    userMapping.identificationAttributes = @[ @"userId" ];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                      @"id":             @"userId",
                                                      @"first_name":     @"firstName",
                                                      @"last_name":      @"lastName",
                                                      @"email":          @"email",
                                                      @"is_student":     @"isStudent",
                                                      @"phone_number":   @"phoneNumber",
                                                      @"car":            @"car",
                                                      @"rating_avg":     @"ratingAvg",
                                                      @"department":     @"department",
                                                      @"created_at":     @"createdAt",
                                                      @"updated_at":     @"updatedAt"}];
    
    return userMapping;
}

+(RKObjectMapping *)postUserMapping {
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[StatusMapping class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"message":@"message"}];
    return responseMapping;
}

+(RKResponseDescriptor *)postUserResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    // create response description for user's session
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:API_USERS                                                                                           keyPath:nil                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKResponseDescriptor *)putUserResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    // create response description for user's session
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPUT                                                                                       pathPattern:API_USERS                                                                                           keyPath:nil                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKResponseDescriptor *)getUserResponseDescriptorWithMapping:(RKEntityMapping *)mapping {

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:@"/api/v3/users/:userId" keyPath:@"user"                                                                                      statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
