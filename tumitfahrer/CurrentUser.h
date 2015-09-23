//
//  CurrentUser.h
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
#import "User.h"

@interface CurrentUser : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString  *authorization;
@property (nonatomic, retain) NSDate * profileImageLastUpdate;



+ (User *)fetchUserFromCoreDataWithEmail:(NSString *)email encryptedPassword:(NSString *)encryptedPassword;
+ (User *)fetchUserFromCoreDataWithEmail:(NSString *)email;

- (void)hasDeviceTokenInWebservice:(boolCompletionHandler)block;
- (void)sendDeviceTokenToWebservice;
- (NSMutableArray *)userRides;
+ (User *)fetchFromCoreDataUserWithId:(NSNumber *)userId;
+ (void)saveUserToPersistentStore:(User *)user;
- (NSArray *)requests;
- (void)initCurrentUser:(User *)user;
@end
