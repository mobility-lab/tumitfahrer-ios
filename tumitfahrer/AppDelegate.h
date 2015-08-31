//
//  AppDelegate.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 2/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Google/CloudMessaging.h>
#import "ActionManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, GGLInstanceIDDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *refererAppLink;
@property (strong, nonatomic) RKObjectManager *panoramioObjectManager;
@property (strong, nonatomic) RKObjectManager *stomtObjectManager;

//GCM
@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;

-(void) logoutCurrentUser;
-(void)setupPushNotifications: (UIApplication *)a;
@end
