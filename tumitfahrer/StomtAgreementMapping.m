//
//  StomtAgreementMapping.m
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

#import "StomtAgreementMapping.h"
#import "StatusMapping.h"

@implementation StomtAgreementMapping

+(RKEntityMapping *)agreementMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"StomtAgreement" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"agreementId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"id": @"agreementId",
                                                      @"negative":@"isNegative",
                                                      @"creator": @"creator",
                                                      }];
    
    return mapping;

}

+(RKResponseDescriptor *)postAgreementResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:@"/agreement"                                                                                           keyPath:@"data"                                                                                      statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKObjectMapping *)deleteStomtAgreementMapping {
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[StatusMapping class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"data":@"data"}];
    return responseMapping;
}

+(RKResponseDescriptor *)deleteStomtAgreementResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodDELETE                                                                                   pathPattern:@"/agreement/:agreementId"                                                                                           keyPath:@"meta"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
