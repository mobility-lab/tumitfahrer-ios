//
//  PanoramioMapping.m
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

#import "PanoramioMapping.h"
#import "Photo.h"

@implementation PanoramioMapping

+(RKEntityMapping *)panoramioMapping {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Photo" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"photoId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"photo_id": @"photoId",
                                                      @"photo_title":@"photoTitle",
                                                      @"photo_url":@"photoUrl",
                                                      @"photo_file_url":@"photoFileUrl",
                                                      @"upload_date":@"uploadDate",
                                                      @"owner_name": @"ownerName",
                                                      }];
    return mapping;
}

+(RKResponseDescriptor *)getPhotoResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"photos" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return responseDescriptor;
}

@end
