//
//  CurrentUser.m
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

#import "CurrentUser.h"
#import "LocationController.h"
#import "JsonParser.h"
#import "Device.h"
#import "Ride.h"
#import "RidesStore.h"
#import "AWSUploader.h"

@interface CurrentUser () <AWSUploaderDelegate>

@end

@implementation CurrentUser

-(instancetype)init {
    self = [super init];
    if (self) {
        [[LocationController sharedInstance] startUpdatingLocation];
    }
    return self;
}

+(instancetype)sharedInstance {
    static CurrentUser *currentUser = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        currentUser = [[self alloc] init];
    });
    
    return currentUser;
}

-(void)initCurrentUser:(User *)user {
    self.user = user;
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:[CurrentUser sharedInstance].user.apiKey];
    if (self.user.profileImageData == nil) {
        [AWSUploader sharedStore].delegate = self;
        [[AWSUploader sharedStore] downloadProfilePictureForUser:self.user];
    }
}

+ (User *)fetchUserFromCoreDataWithEmail:(NSString *)email {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"User"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email = %@)", email];
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return  (User *)[result firstObject];
}

+ (User *)fetchUserFromCoreDataWithEmail:(NSString *)email encryptedPassword:(NSString *)encryptedPassword{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"User"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email = %@ && password= %@)", email, encryptedPassword];
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return (User *)[result firstObject];
}

+(User *)fetchFromCoreDataUserWithId:(NSNumber *)userId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"User"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return (User *)[result firstObject];
}



#pragma mark - Device token methods

- (void)hasDeviceTokenInWebservice:(boolCompletionHandler)block {
    
    [NSURLConnection sendAsynchronousRequest:[self buildGetDeviceTokenRequest] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            NSLog(@"Could not retrieve device token. %@",connectionError.debugDescription);
            block(NO);
        } else {
            NSError *error;
            NSArray *deviceTokens = [JsonParser  devicesFromJson:data error:error];
            if (!error) {
                for (NSString *deviceToken in deviceTokens) {
                    if ([deviceToken isEqualToString:[Device sharedInstance].deviceToken]) {
                        block(YES);
                        NSLog(@"Device token machtes.");
                        return;
                    }
                }
            }
            block(NO);
        }}];
}

- (NSURLRequest *)buildGetDeviceTokenRequest {
    
    NSString *urlString = [API_ADDRESS stringByAppendingString:[NSString stringWithFormat:@"/api/v3/users/%@/devices", [CurrentUser sharedInstance].user.userId]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:[CurrentUser sharedInstance].user.apiKey forHTTPHeaderField:@"Authorization"];
    [urlRequest setHTTPMethod:@"GET"];

    return urlRequest;
}

- (void)sendDeviceTokenToWebservice {
    if([[Device sharedInstance] deviceToken]) {
        NSDictionary *queryParams;
        // add enum
        queryParams = @{@"platform": @"ios", @"token": [[Device sharedInstance] deviceToken], @"enabled":@"true"};
        NSDictionary *deviceParams = @{@"device": queryParams};
        
        NSString *pathString = [NSString stringWithFormat:@"/api/v3/users/%@/devices", [CurrentUser sharedInstance].user.userId];
        [[RKObjectManager sharedManager] postObject:nil path:pathString parameters:deviceParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"Device token successfully sent.");
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Could not send device token to DB. Error connecting data from server: %@", error.localizedDescription);
        }];
    }
}

#pragma mark - user utility functions

-(void)didDownloadImageData:(NSData *)imageData user:(User *)user {
    NSLog(@"<<didDownloadImageData - CurrentUser");
    self.user.profileImageData = imageData;
    [CurrentUser saveUserToPersistentStore:self.user];
}

- (NSMutableArray *)userRides {
    NSMutableArray *privateUserRides = [NSMutableArray arrayWithArray:[self.user.ridesAsOwner allObjects]];
    [privateUserRides addObjectsFromArray:[self.user.ridesAsPassenger allObjects]];
    [privateUserRides addObjectsFromArray:[[RidesStore sharedStore] fetchUserRequestsFromCoreDataForUserId:self.user.userId]];
    return  privateUserRides;
}

+(void)saveUserToPersistentStore:(User *)user {
    NSLog(@"<<saveUserToPersistentStore");
    NSManagedObjectContext *context = user.managedObjectContext;
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"saving error %@", [error localizedDescription]);
    }
}

-(NSArray *)requests {
    return [[RidesStore sharedStore] fetchUserRequestsFromCoreDataForUserId:[CurrentUser sharedInstance].user.userId];
}

# pragma mark - Object to string

-(NSString *)description {
    return [NSString stringWithFormat:@"Name: %@ %@, email: %@, registered at: %@", self.user.firstName, self.user.lastName, self.user.email, self.user.createdAt];
}

-(void)dealloc {
    [AWSUploader sharedStore].delegate = nil;
}

@end