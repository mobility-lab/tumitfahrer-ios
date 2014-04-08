//
//  LoginViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "Constants.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface LoginViewController () <NSFetchedResultsControllerDelegate>

@property CustomTextField *emailTextField;
@property CustomTextField *passwordTextField;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
        float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
        UIImage *emailWhiteIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"EmailIcon"] withColor:[UIColor whiteColor]];
        self.emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailWhiteIcon returnKeyType:UIReturnKeyNext];
        
        UIImage *passwordWhiteIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"PasswordIcon"] withColor:[UIColor whiteColor]];
        self.passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop+self.emailTextField.frame.size.height + cUIElementPadding, cUIElementWidth, cUIElementHeight) placeholderText:@"Your password" customIcon:passwordWhiteIcon returnKeyType:UIReturnKeyDone];
        
        [self.view addSubview:self.emailTextField];
        [self.view addSubview:self.passwordTextField];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized)];
    tapRecognizer.delegate = self;
    // Set required taps and number of touches
    
    // Add the gesture to the view
    [self.view addGestureRecognizer:tapRecognizer];
    
    // Set debug logging level. Set to 'RKLogLevelTrace' to see JSON payload
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailLoggedInUser"];
    if (email) {
        //        self.emailField.text = email;
    }
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"highway-nosound@2x" ofType:@"mp4"];
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
        [self.moviePlayerController.view setFrame: CGRectMake(0, 0, 416, 1100)];
        [self.view addSubview:self.moviePlayerController.view];
        [self.view sendSubviewToBack:self.moviePlayerController.view];
    }
    [self.moviePlayerController play];
}

- (void)introMovieFinished:(NSNotification *)notification
{
    [self.moviePlayerController play];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self createUserSession];
}

- (BOOL)createUserSession {
    BOOL __block result = false;
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager postObject:nil path:@"/api/v2/sessions" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [CurrentUser sharedInstance].user = (User *)[mappingResult firstObject];
        RKLogInfo(@"Load complete, current user %@!", [CurrentUser sharedInstance].user.firstName);
        
        result = true;
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"loggedIn"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[ActionManager sharedManager] showAlertViewWithTitle:[error localizedDescription]];
        RKLogError(@"Load failed with error: %@", error);
    }];
    
     /*
      // sample method for getting users
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/v2/users" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [CurrentUser sharedInstance].user = (User *)[mappingResult firstObject];
        RKLogInfo(@"Load complete, current user %@!", [CurrentUser sharedInstance].user.firstName);
        
        result = true;
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"loggedIn"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[ActionManager sharedManager] showAlertViewWithTitle:[error localizedDescription]];
        RKLogError(@"Load failed with error: %@", error);
    }];*/
    
    return result;
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

-(void)tapRecognized
{
    
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)fetchedResultsController
{
    NSArray *result = [fetchedResultsController fetchedObjects];
    NSLog(@"Fetched %d results!", [result count]);
}

#pragma mark - Fetched results controller

-(NSFetchedResultsController *)fetchedResultsController
{
    if (self.fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[RKManagedObjectStore defaultStore].
                                     mainQueueManagedObjectContext
                                     sectionNameKeyPath:nil cacheName:@"User"];
    self.fetchedResultsController.delegate = self;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        [[ActionManager sharedManager] showAlertViewWithTitle:[error localizedDescription]];
    }
    
    return self.fetchedResultsController;
}

-(NSString *)encryptCredentialsWithEmail:(NSString *)email password:(NSString *)password {
    
    NSString *encryptedPassword = [[ActionManager sharedManager] createSHA512:password];
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", email, encryptedPassword];
    NSString *encryptedCredentials = [[ActionManager sharedManager] encodeBase64WithCredentials:credentials];
    
    return encryptedCredentials;
}


@end
