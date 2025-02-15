//
//  AppDelegate.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 2/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *refererAppLink;
@property (strong, nonatomic) RKObjectManager *panoramioObjectManager;
@property (strong, nonatomic) RKObjectManager *stomtObjectManager;

@end
