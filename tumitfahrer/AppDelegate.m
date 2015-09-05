//
//  AppDelegate.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 2/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//
#import <RestKit/RestKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AWSRuntime/AWSRuntime.h>
#import <HockeySDK/HockeySDK.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "MenuViewController.h"
#import "Device.h"
#import "UserMapping.h"
#import "SessionMapping.h"
#import "RideMapping.h"
#import "DeviceMapping.h"
#import "RequestMapping.h"
#import "LocationController.h"
#import "PanoramioUtilities.h"
#import "CurrentUser.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "TimelineViewController.h"
#import "TimelinePageViewController.h"
#import "ActivityMapping.h"
#import "RidesStore.h"
#import "ActivityStore.h"
#import "ConversationMapping.h"
#import "MessageMapping.h"
#import "SearchResultMapping.h"
#import "BadgeMapping.h"
#import "RatingMapping.h"
#import "PanoramioMapping.h"
#import "GAI.h"
#import "StomtMapping.h"
#import "StomtAgreementMapping.h"
#import "Google/CloudMessaging.h"
#import "GGLInstanceID.h"

@interface AppDelegate ()

    @property (nonatomic,strong) MMDrawerController * drawerController;
    //@property kGGLInstanceIDRegisterAPNSOption _registrationOptions;
    @property(nonatomic, strong) void (^registrationHandler)
    (NSString *registrationToken, NSError *error);
    @property(nonatomic, assign) BOOL connectedToGCM;
    @property(nonatomic, strong) NSString* registrationToken;
    @property(nonatomic, assign) BOOL subscribedToTopic;
@end

NSString *const SubscriptionTopic = @"/topics/global";


@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // register app for receiving push notifications
//    [self setupPushNotifications: application];
    
    [self setupNavigationController];
    [self setupRestKit];
    
    //Logging, remove for release version.
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    [self setupCurrentUser];
    [self setupObservers];
    
    // Hockey-app initialization
    [self setupHockeyApp];
    
    // Load the FBLoginView class (needed for login)
    [FBLoginView class];
    
#ifdef DEBUG
    [AmazonLogger verboseLogging];
#else
    [AmazonLogger turnLoggingOff];
#endif
    [self initUniversalAnalytics];
    
    [AmazonErrorHandler shouldNotThrowExceptions];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Connect to the GCM server to receive non-APNS notifications
    [[GCMService sharedInstance] connectWithHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Could not connect to GCM: %@", error.localizedDescription);
        } else {
            _connectedToGCM = true;
            NSLog(@"Connected to GCM");
            // ...
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [RKManagedObjectStore defaultStore].
    mainQueueManagedObjectContext;
    if (managedObjectContext != nil) {
        [managedObjectContext save:&error];
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSNumber *userId = [userInfo valueForKey:@"user_id"];
        NSLog(@" <y<< GOT NOTIFICATION for User:%@",userId);
    if(userId == [CurrentUser sharedInstance].user.userId){
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
        [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    } else {
        NSLog(@"<y< notification for wrong user! Discarded.");
    }

    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
    NSNumber *userId = [userInfo valueForKey:@"user_id"];
    NSLog(@" <y<< GOT NOTIFICATION for User:%@",userId);
    NSLog(@"<y<< Notification received for User=%@  notification: %@",userId, userInfo);
    if(userId == [CurrentUser sharedInstance].user.userId || true){// || true -> nur zum testen 
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    // ...
    
    if (application.applicationState == UIApplicationStateActive ) {
        NSLog(@" <y<< ACTIVE");
      ;
        NSDictionary *aps = [userInfo valueForKey:@"aps"];

        NSDictionary *alert = [aps valueForKey:@"alert"];
        [ActionManager showAlertViewWithTitle: [alert valueForKey:@"title"] description:[alert valueForKey:@"body"]];
    }
    } else {
          NSLog(@"<y< notification for wrong user! Discarded.");
    }
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSLog(@" <y< GOT DEVICE TOKEN %@", deviceToken);
    
    //GCM implementation
    // Start the GGLInstanceID shared instance with the default config and request a registration
    // token to enable reception of notifications
    [[GGLInstanceID sharedInstance] startWithConfig:[GGLInstanceIDConfig defaultConfig]];
    _registrationOptions = @{kGGLInstanceIDRegisterAPNSOption:deviceToken,
                             kGGLInstanceIDAPNSServerTypeSandboxOption:@YES};
    
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:@"919031243448"
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];

}
- (void)onTokenRefresh {
    // A rotation of the registration tokens is happening, so the app needs to request a new token.
    NSLog(@" <y< The GCM registration token needs to be changed.");
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
	NSLog(@" <y<  Failed to get token, error: %@", error);
}

-(void)setupPushNotifications: (UIApplication *)application {
    NSLog(@" <y<  setupPushNotifications -- get token");
    // [START_EXCLUDE]
    _registrationKey = @"onRegistrationCompleted";
    _messageKey = @"onMessageReceived";
    // Configure the Google context: parses the GoogleService-Info.plist, and initializes
    // the services that have entries in the file
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    if (configureError != nil) {
        NSLog(@"Error configuring the Google context: %@", configureError);
    }
    _gcmSenderID = [[[GGLContext sharedInstance] configuration] gcmSenderID];
    
    //
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIUserNotificationTypeNone;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    // Register for remote notifications
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
    } else {
        // iOS 8 or later
        // [END_EXCLUDE]
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes: allNotificationTypes categories: nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings: settings ];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    
    //
    // [START start_gcm_service]
    [[GCMService sharedInstance] startWithConfig:[GCMConfig defaultConfig]];

    __weak typeof(self) weakSelf = self;
    // Handler for registration token request
    _registrationHandler = ^(NSString *registrationToken, NSError *error){
        if (registrationToken != nil) {
            weakSelf.registrationToken = registrationToken;
            NSLog(@"<y< Registration Token: %@", registrationToken);
            [weakSelf subscribeToTopic];
            NSDictionary *userInfo = @{@"registrationToken":registrationToken};
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];
            
            //Check for registration token
            [Device sharedInstance].deviceToken = registrationToken;
            [ [CurrentUser sharedInstance] hasDeviceTokenInWebservice:^(BOOL keyIsOnline) {
                if(keyIsOnline){
                    NSLog(@"<y< registration key is on webserver. no need to upload");
                } else {
                    NSLog(@"<y< registration key is not on webserver. need to upload");
                    [weakSelf uploadRegistrationToken: registrationToken];
                }
            }];
        
            
        } else {
            NSLog(@"Registration to GCM failed with error: %@", error.localizedDescription);
            NSDictionary *userInfo = @{@"error":error.localizedDescription};
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];
        }
    };

}

-(void) uploadRegistrationToken: (NSString*) registrationToken {
    NSLog(@"<y< uploadDeviceToken");

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/users/%@/devices",API_ADDRESS,[CurrentUser sharedInstance].user.userId]]];
    [request setHTTPMethod:@"POST"];
    NSString *bodyString =[NSString stringWithFormat: @"{\"device\":{\"token\":\"%@\", \"enabled\":true, \"platform\":\"ios\", \"language\":\"de\" }}", registrationToken ];
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[CurrentUser sharedInstance].user.apiKey forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: body];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSLog(@"<y<ChangePasswordViewController-didRecieveResponse: %ld",(long)[httpResponse statusCode]);
    NSLog(@"<y<ChangePasswordViewController-didRecieveResponse: %@",response.debugDescription);
    NSLog(@"<y<ChangePasswordViewController-didRecieveResponse: %@",response);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"ChangePasswordViewController-connectionDidFinishLoading");
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ChangePasswordViewController-Error: %@",error);
}

- (void)subscribeToTopic {
    NSLog(@"<y< registration token %@", _registrationToken);
    // If the app has a registration token and is connected to GCM, proceed to subscribe to the
    // topic
    if (_registrationToken && _connectedToGCM) {
            NSLog(@"<y<2 device token %@", _registrationToken);
        [[GCMPubSub sharedInstance] subscribeWithToken:_registrationToken
                                                 topic:SubscriptionTopic
                                               options:nil
                                               handler:^(NSError *error) {
                                                   if (error) {
                                                       // Treat the "already subscribed" error more gently
                                                       if (error.code == 3001) {
                                                           NSLog(@"Already subscribed to %@",
                                                                 SubscriptionTopic);
                                                       } else {
                                                           NSLog(@"Subscription failed: %@",
                                                                 error.localizedDescription);
                                                       }
                                                   } else {
                                                       self.subscribedToTopic = true;
                                                       NSLog(@"Subscribed to %@", SubscriptionTopic);
                                                   }
                                               }];
    }
}


-(void)setupHockeyApp {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"6ca33e4226218908f6d423fd04772a60"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
}

-(void)initUniversalAnalytics {
    // automatically send uncaught exceptions
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-52228842-1"];
}

-(void)setupNavigationController {
    // init controllers
    MenuViewController *leftMenu = [[MenuViewController alloc] init];
    
    TimelinePageViewController *parentVC = [[TimelinePageViewController alloc] init];
    UINavigationController *navControler = [[UINavigationController alloc] initWithRootViewController:parentVC];

    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navControler
                             leftDrawerViewController:leftMenu
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    
    [self.drawerController setMaximumLeftDrawerWidth:280];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    // set root view controller
    self.window.rootViewController = self.drawerController;
}

-(void)setupLeftMenu {
    MenuViewController *menuController = [[MenuViewController alloc] init];
    menuController.preferredContentSize = CGSizeMake(180, 0);
}

-(void)setupRestKit {
    
    NSError *error = nil;
    
    // Initialize RestKit
    NSURL *baseURL = [NSURL URLWithString:API_ADDRESS];

    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // register date formatter compliant with the date format in the backend
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZZ"]; //'T'
    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:dateFormatter atIndex:0];
    
    // add mappings to object manager
    [self initMappingsForObjectManager:objectManager];
    // add mappings to panormation object manager
    [self initPanoramioMapping];
    self.panoramioObjectManager.managedObjectStore = managedObjectStore;
    [self initStomtMapping];
    self.stomtObjectManager.managedObjectStore = managedObjectStore;
    
    // complete Core Data stack initialization
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Tumitfahrer.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if(!persistentStore)
    {
        RKLogError(@"Failed to add persistent store with error: %@", error);
    }
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
}

-(void)initMappingsForObjectManager:(RKObjectManager *)objectManager {
    
    RKEntityMapping *postSessionMapping =[SessionMapping sessionMapping];
    [objectManager addResponseDescriptor:[SessionMapping postSessionResponseDescriptorWithMapping:postSessionMapping]];
    RKObjectMapping *postUserMapping =[UserMapping postUserMapping];
    [objectManager addResponseDescriptor:[UserMapping postUserResponseDescriptorWithMapping:postUserMapping]];

    [objectManager addResponseDescriptor:[UserMapping putUserResponseDescriptorWithMapping:postUserMapping]];
    RKEntityMapping *generalRidesMapping = [RideMapping generalRideMapping];
    [objectManager addResponseDescriptor:[RideMapping getRidesResponseDescriptorWithMapping:generalRidesMapping]];
    [objectManager addResponseDescriptor:[RideMapping getSimpleRidesResponseDescriptorWithMapping:generalRidesMapping]];
    [objectManager addResponseDescriptor:[RideMapping getSingleRideResponseDescriptorWithMapping:generalRidesMapping]];
    RKObjectMapping *postDeviceTokenMapping = [DeviceMapping postDeviceMapping];
    [objectManager addResponseDescriptor:[DeviceMapping postDeviceResponseDescriptorWithMapping:postDeviceTokenMapping]];
    RKEntityMapping *postRideMapping = [RideMapping postRideMapping];
    [objectManager addResponseDescriptorsFromArray:@[[RideMapping postRideResponseDescriptorWithMapping:postRideMapping]]];
    [objectManager addResponseDescriptor:[RideMapping postRegularRideResponseDescriptorWithMapping:postRideMapping]];
    RKEntityMapping *requestMapping = [RequestMapping requestMapping];
    [objectManager addResponseDescriptor:[RequestMapping postRequestResponseDescriptorWithMapping:requestMapping]];
    [objectManager addResponseDescriptor:[RequestMapping getRequestResponseDescriptorWithMapping:requestMapping]];
    RKEntityMapping *activitiesMapping = [ActivityMapping generalActivityMapping];
    [objectManager addResponseDescriptor:[ActivityMapping getActivityResponseDescriptorWithMapping:activitiesMapping]];
    
    RKEntityMapping *conversationsMapping = [ConversationMapping conversationMapping];
    [objectManager addResponseDescriptor:[ConversationMapping getConversationsResponseDescriptorWithMapping:conversationsMapping]];
    [objectManager addResponseDescriptor:[ConversationMapping getConversationResponseDescriptorWithMapping:conversationsMapping]];
    [objectManager addResponseDescriptor:[ConversationMapping postConversationResponseDescriptorWithMapping:conversationsMapping]];
    
    RKEntityMapping *postMessageMapping =[MessageMapping messageMapping];
    [objectManager addResponseDescriptor:[MessageMapping postMessageResponseDescriptorWithMapping:postMessageMapping]];
    
    RKObjectMapping *getRidesIdsMapping = [RideMapping getRideIds];
    [objectManager addResponseDescriptor:[RideMapping getRideIdsresponseDescriptorWithMapping:getRidesIdsMapping]];
    
    [objectManager addResponseDescriptor:[SearchResultMapping postSearchResponseDescriptorWithMapping:generalRidesMapping]];
    
    RKObjectMapping *putRequestMapping = [RequestMapping putRequestMapping];
    [objectManager addResponseDescriptor:[RequestMapping putRequestResponseDescriptorWithMapping:putRequestMapping]];
    
    RKObjectMapping *putRideMapping = [RideMapping putRideMapping];
    [objectManager addResponseDescriptor:[RideMapping putRideResponseDescriptorWithMapping:putRideMapping]];
    
    RKEntityMapping *getUserMapping =[UserMapping userMapping];
    [objectManager addResponseDescriptor:[UserMapping getUserResponseDescriptorWithMapping:getUserMapping]];
    
    
    RKEntityMapping *getBadgesMapping =[BadgeMapping badgeMapping];
    [objectManager addResponseDescriptor:[BadgeMapping getBadgesResponseDescriptorWithMapping:getBadgesMapping]];
    
    RKEntityMapping *postRatingMapping =[RatingMapping ratingMapping];
    [objectManager addResponseDescriptor:[RatingMapping postRatingResponseDescriptorWithMapping:postRatingMapping]];
}

-(void)initPanoramioMapping {
    
    NSURL *baseURL = [NSURL URLWithString:@"http://www.panoramio.com"];
    
    self.panoramioObjectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    RKEntityMapping *photoMapping =[PanoramioMapping panoramioMapping];
    [self.panoramioObjectManager addResponseDescriptor:[PanoramioMapping getPhotoResponseDescriptorWithMapping:photoMapping]];
}

-(void)initStomtMapping {
    
    NSURL *baseURL = [NSURL URLWithString:@"http://rest.stomt.com"];
    
    self.stomtObjectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    RKEntityMapping *stomtMapping = [StomtMapping stomtMapping];
    [self.stomtObjectManager addResponseDescriptor:[StomtMapping getStomtsResponseDescriptorWithMapping:stomtMapping]];
    [self.stomtObjectManager addResponseDescriptor:[StomtMapping postStomtResponseDescriptorWithMapping:stomtMapping]];
    RKEntityMapping *agreementMapping = [StomtAgreementMapping agreementMapping];
    [self.stomtObjectManager addResponseDescriptor:[StomtAgreementMapping postAgreementResponseDescriptorWithMapping:agreementMapping]];
    [self.stomtObjectManager addResponseDescriptor:[StomtAgreementMapping deleteStomtAgreementResponseDescriptorWithMapping:[StomtAgreementMapping deleteStomtAgreementMapping]]];
    RKObjectMapping *deleteStomtMapping = [StomtMapping deleteStomtMapping];
    [self.stomtObjectManager addResponseDescriptor:[StomtMapping deleteStomtResponseDescriptorWithMapping:deleteStomtMapping]];
}

-(void)setupCurrentUser {
    NSString *emailLoggedInUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailLoggedInUser"];
    
    if (emailLoggedInUser != nil) {
        User *user = [CurrentUser fetchUserFromCoreDataWithEmail:emailLoggedInUser];
        if (user != nil) {
            [[CurrentUser sharedInstance] initCurrentUser:user];
            RKObjectManager *objectManager = [RKObjectManager sharedManager];
            [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:[CurrentUser sharedInstance].user.apiKey];
        }
    }
}

-(void) logoutCurrentUser {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"emailLoggedInUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:[CurrentUser sharedInstance].user.apiKey];
    [CurrentUser sharedInstance].user.apiKey = nil;
    [objectManager deleteObject:nil path:API_SESSIONS parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"logout sucessfull");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"logout NOT sucessfull");
    }];
}

-(void)setupObservers {
    // for getting location of a specific photo
    
    [[LocationController sharedInstance] addObserver:[PanoramioUtilities sharedInstance]];
    [[LocationController sharedInstance] addObserver:[RidesStore sharedStore]];
    [[LocationController sharedInstance] addObserver:[ActivityStore sharedStore]];
    // for getting images for a specific location
    [[PanoramioUtilities sharedInstance] addObserver:[RidesStore sharedStore]];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication
             fallbackHandler:
     ^(FBAppCall *call) {
         // Parse the incoming URL to look for a target_url parameter
         NSString *query = [url query];
         NSDictionary *params = [self parseURLParams:query];
         // Check if target URL exists
         NSString *appLinkDataString = [params valueForKey:@"al_applink_data"];
         if (appLinkDataString) {
             NSError *error = nil;
             NSDictionary *applinkData =
             [NSJSONSerialization JSONObjectWithData:[appLinkDataString dataUsingEncoding:NSUTF8StringEncoding]
                                             options:0
                                               error:&error];
             if (!error &&
                 [applinkData isKindOfClass:[NSDictionary class]] &&
                 applinkData[@"target_url"]) {
                 self.refererAppLink = applinkData[@"referer_app_link"];
                 NSString *targetURLString = applinkData[@"target_url"];
                 // Show the incoming link in an alert
                 // Your code to direct the user to the
                 // appropriate flow within your app goes here
                 [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                             message:targetURLString
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
         }
     }];
    
    return urlWasHandled;
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
@end
