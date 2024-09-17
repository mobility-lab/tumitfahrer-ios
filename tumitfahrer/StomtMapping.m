//
//  StomtMapping.m
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

#import "StomtMapping.h"
#import "StatusMapping.h"
#import "StomtAgreementMapping.h"

@implementation StomtMapping

+(RKEntityMapping *)stomtMapping {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Stomt" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"stomtId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"id": @"stomtId",
                                                      @"text":@"text",
                                                      @"lang":@"language",
                                                      @"negative":@"isNegative",
                                                      @"counter":@"counter",
                                                      @"creator": @"creator",
                                                      @"created_at":@"createdAt",
                                                      }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"agreements" toKeyPath:@"agreements" withMapping:[StomtAgreementMapping agreementMapping]]];

    return mapping;
}

+(RKObjectMapping *)deleteStomtMapping {
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[StatusMapping class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"data":@"data"}];
    return responseMapping;
}

+(RKResponseDescriptor *)getStomtsResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return responseDescriptor;
}

+(RKResponseDescriptor *)postStomtResponseDescriptorWithMapping:(RKObjectMapping *)mapping {

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:@"/stomt"                                                                                           keyPath:@"data"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKResponseDescriptor *)deleteStomtResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodDELETE                                                                                   pathPattern:@"/stomt/:stomtId"                                                                                           keyPath:@"data"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}


@end
