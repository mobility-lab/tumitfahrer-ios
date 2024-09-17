//
//  RequestMapping.m
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

#import "RequestMapping.h"
#import "StatusMapping.h"

@implementation RequestMapping

+(RKEntityMapping *)requestMapping {
    
    RKEntityMapping *requestMapping = [RKEntityMapping mappingForEntityForName:@"Request" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    requestMapping.identificationAttributes = @[@"requestId"];
    [requestMapping addAttributeMappingsFromDictionary:@{@"id": @"requestId",
                                                      @"ride_id":@"rideId",
                                                      @"passenger_id":@"passengerId",
                                                      @"requested_from":@"requestedFrom",
                                                      @"request_to":@"requestedTo",
                                                      @"ride_type":@"rideType",
                                                      @"created_at": @"createdAt",
                                                      @"updated_at": @"updatedAt"
                                                      }];
    return requestMapping;
}

+(RKResponseDescriptor *)postRequestResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:API_RIDES_REQUESTS                                                                                          keyPath:@"request"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}


+(RKObjectMapping *)putRequestMapping {
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[StatusMapping class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"message":@"message"}];
    
    return responseMapping;
}

+(RKResponseDescriptor *)putRequestResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPUT                                                                                      pathPattern:API_RIDES_REQUEST                                                                                          keyPath:nil                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKResponseDescriptor *)getRequestResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET                                                                                      pathPattern:API_RIDES_REQUEST                                                                                          keyPath:nil                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
