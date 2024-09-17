//
//  LoginViewController.m
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

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "TimelinePageViewController.h"

@interface LoginViewController ()

@property CustomTextField *emailTextField;
@property CustomTextField *passwordTextField;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
        UIImage *emailWhiteIcon = [ActionManager colorImage:[UIImage imageNamed:@"EmailIconBlack"] withColor:[UIColor whiteColor]];
        self.emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailWhiteIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress shouldStartWithCapital:NO];
        self.emailTextField.tag = 10;
        self.emailTextField.delegate = self;
        
        UIImage *passwordWhiteIcon = [ActionManager colorImage:[UIImage imageNamed:@"PasswordIconBlack"] withColor:[UIColor whiteColor]];
        self.passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop+self.emailTextField.frame.size.height + cUIElementPadding, cUIElementWidth, cUIElementHeight) placeholderText:@"Your password" customIcon:passwordWhiteIcon returnKeyType:UIReturnKeyDone keyboardType:UIKeyboardTypeDefault secureInput:YES];
        self.passwordTextField.tag = 11;
        self.passwordTextField.delegate = self;
        
        [self.view addSubview:self.emailTextField];
        [self.view addSubview:self.passwordTextField];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Login screen";
    
    NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"storedEmail"];
    if (email!=nil) {
        self.emailTextField.text = email;
    }
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"3_iphone_big" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    
    if(self.moviePlayerController == nil) {
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(introMovieFinished:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayerController];
        
        // Hide the video controls from the user
        [self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
        
        [self.moviePlayerController prepareToPlay];

        if (iPhone5) {
            [self.moviePlayerController.view setFrame:CGRectMake(0, 0, 320, 568)];
        } else {
            [self.moviePlayerController.view setFrame:CGRectMake(0, 0, 320, 510)];
        }
        [self.view addSubview:self.moviePlayerController.view];
        [self.view sendSubviewToBack:self.moviePlayerController.view];
    }
    [self.moviePlayerController play];
}

- (void)introMovieFinished:(NSNotification *)notification {
    [self.moviePlayerController play];
}

- (IBAction)loginButtonPressed:(id)sender {
    
//    // firstly check if the user was previously stored in core data
//    User *user= [CurrentUser fetchUserFromCoreDataWithEmail:self.emailTextField.text encryptedPassword:[ActionManager createSHA512:self.passwordTextField.text]];
//    if (user != nil) {
//        // user fetched successfully from core data
//        [[CurrentUser sharedInstance] initCurrentUser:user];
//        [self storeCurrentUserInDefaults:user.authentication];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        // new user, get account from webservice
//        [self createUserSession];
//    }
    [self createUserSession];
}

- (void)createUserSession {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.emailTextField.text, self.passwordTextField.text];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding ];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:authValue]; //[ActionManagerencryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]
    
    RKLogError(@"authValue %@",authValue);
    RKLogError(@"Email=%@, pw=%@, baseUrl=%@", self.emailTextField.text, self.passwordTextField.text, objectManager.baseURL);
    
    [objectManager postObject:nil path:API_SESSIONS parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        
        
        User *user = (User *)[mappingResult firstObject];
        
        user.password = [ActionManager createSHA512:self.passwordTextField.text];
        [[CurrentUser sharedInstance] initCurrentUser:user];
        [CurrentUser saveUserToPersistentStore:user];
        NSString *auth =  user.apiKey;

        RKLogError(@"Authentication: %@", auth);
        [self storeCurrentUserInDefaults:auth];
        // check if fetch user has assigned a device token
//        [self checkDeviceToken];
        UIApplication *application = [UIApplication sharedApplication];
        AppDelegate *delegate = (AppDelegate*) application.delegate;
        [delegate setupPushNotifications:application];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [ActionManager showAlertViewWithTitle:@"Invalid email/password" description:@"Could not login, please check your email and password."];
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)checkDeviceToken {
//Everything is now done via start [delegate setupPushNotification]
//    [[CurrentUser sharedInstance] hasDeviceTokenInWebservice:^(BOOL tokenExistsInDatabase) {
//        // device token is not in db, need to send it
//        if (!tokenExistsInDatabase && [CurrentUser sharedInstance].user.userId > 0) {
//            [[CurrentUser sharedInstance] sendDeviceTokenToWebservice];
//        }
//    }];
}

-(void)storeCurrentUserInDefaults: (NSString*)auth {
    [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:@"emailLoggedInUser"];
    [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:@"storedEmail"];
    [[NSUserDefaults standardUserDefaults] setValue:auth forKey:@"authorization"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// show register view
- (IBAction)registerButtonPressed:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC animated:NO completion:nil];
}

// show forgot password view
- (IBAction)forgotPasswordButtonPressed:(id)sender {
    ForgotPasswordViewController *forgotVC = [[ForgotPasswordViewController alloc] init];
    [self presentViewController:forgotVC animated:NO completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    //try to find next responder
    CustomTextField *nextTextField = (CustomTextField *)[self.view viewWithTag:nextTag];
    
    if (nextTextField) {
        // found next responce ,so set it
        [nextTextField becomeFirstResponder];
    }
    else {
        // not found remove keyboard
        [textField resignFirstResponder];
        return YES;
    }
    
    return YES;
}

@end
