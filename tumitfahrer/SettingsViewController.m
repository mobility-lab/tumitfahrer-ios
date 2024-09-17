//
//  CampusRidesViewController.m
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

#import "SettingsViewController.h"
#import "ActionManager.h"
#import "LoginViewController.h"
#import "NavigationBarUtilities.h"
#import "LogoView.h"
#import "MMDrawerBarButtonItem.h"
#import "PrivacyViewController.h"
#import "ReminderViewController.h"
#import "FeedbackViewController.h"
#import "CarsharingViewController.h"
#import "EAIntroView.h"
#import "ControllerUtilities.h"
#import "TeamViewController.h"
#import "StomtViewController.h"
#import "CurrentUser.h"
#import "AppDelegate.h"

@interface SettingsViewController () <EAIntroDelegate>

@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSArray *readOptions;
@property (nonatomic, strong) NSArray *readIcons;
@property (nonatomic, strong) NSArray *actionOptions;
@property (nonatomic, strong) NSArray *actionIcons;
@property (nonatomic, strong) NSArray *contactOptions;
@property (nonatomic, strong) NSArray *contactIcons;
@property (nonatomic, strong) NSArray *tableValues;
@property (nonatomic, strong) NSArray *tableIcons;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.headers = [[NSArray alloc] initWithObjects:@"Feedback", @"General", @"About TUMitfahrer", nil];
        self.actionOptions = [[NSArray alloc] initWithObjects: @"Send feedback",  nil];
        self.actionIcons = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"FeedbackIconBlack"], [UIImage imageNamed:@"ProblemIconBlack"], nil];
        self.readOptions = [[NSArray alloc] initWithObjects:@"Reminder", @"Terms of Use", @"Licenses", @"Carsharing", nil];
        self.readIcons = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ReminderIconBlack"], [UIImage imageNamed:@"PrivacyIconBlack"], [UIImage imageNamed:@"LicenseIconBlack"], [UIImage imageNamed:@"CarIconBlack"], nil];
        self.contactOptions = [[NSArray alloc] initWithObjects:@"About TUMitfahrer", @"Team", @"Contact us", nil];
        self.contactIcons = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"InfoIconBlack"], [UIImage imageNamed:@"TeamIconBlack"], [UIImage imageNamed:@"EmailIconBlackSmall"], nil];
        self.tableValues = [[NSArray alloc] initWithObjects:self.actionOptions, self.readOptions, self.contactOptions, nil];
        self.tableIcons = [[NSArray alloc] initWithObjects:self.actionIcons, self.readIcons, self.contactIcons, nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Setting screen";
    
    [self setupLeftMenuButton];
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor customDarkGray]];
    self.title = @"Settings";
    
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"LogoutIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonPressed:)];
#ifdef DEBUG
    // set label for kif test
    [self.navigationItem setAccessibilityLabel:@"Back Setting Button"];
    [self.navigationItem setIsAccessibilityElement:YES];
#endif
    
    [self.navigationItem setRightBarButtonItem:refreshButtonItem];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
#ifdef DEBUG
    // set label for kif test
    [leftDrawerButton setAccessibilityLabel:@"Menu Button"];
    [leftDrawerButton setIsAccessibilityElement:YES];
#endif
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.tableValues objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.tableValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [[self.tableIcons objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

//    if (indexPath.section == 0 && indexPath.row == 0) {
//        StomtViewController *stomtVC = [[StomtViewController alloc] init];
//        stomtVC.title = @"Feeback";
//        [self.navigationController pushViewController:stomtVC animated:YES];
//        return;
//    }
    
    if(indexPath.section == 0) {
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        if (indexPath.row == 0) {
            feedbackVC.title = @"Send Feedback";
        } else if(indexPath.row == 1) {
            feedbackVC.title = @"Report Problem";
        }
        [self.navigationController pushViewController:feedbackVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        ReminderViewController *reminderVC = [[ReminderViewController alloc] init];
        reminderVC.title = @"Reminder";
        [self.navigationController pushViewController:reminderVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        PrivacyViewController *privacyVC = [[PrivacyViewController alloc] init];
        privacyVC.title = @"Terms of Use";
        privacyVC.privacyViewTypeEnum = Privacy;
        [self.navigationController pushViewController:privacyVC animated:YES];
    } else if(indexPath.section == 1 && indexPath.row == 2) {
        PrivacyViewController *licenses = [[PrivacyViewController alloc] init];
        licenses.title = @"Licenses";
        licenses.privacyViewTypeEnum = Licenses;
        [self.navigationController pushViewController:licenses animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        CarsharingViewController *carsharingVC = [[CarsharingViewController alloc] init];
        carsharingVC.title = @"Carsharing";
        [self.navigationController pushViewController:carsharingVC animated:YES];
    } else if(indexPath.section == 2 && indexPath.row == 0) {
        [self showIntroButtonPressed];
    } else if(indexPath.section == 2 && indexPath.row == 1) {
        TeamViewController *teamVC = [[TeamViewController alloc] init];
        teamVC.title = @"Team";
        [self.navigationController pushViewController:teamVC animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        feedbackVC.title = @"Contact us";
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}

- (IBAction)sendFeedbackButtonPressed:(id)sender {
}

- (void)showIntroButtonPressed {
    EAIntroView *intro = (EAIntroView *)[ControllerUtilities prepareIntroForView:self.navigationController.view];
    intro.delegate = self;
    [intro showInView:self.navigationController.view animateDuration:0.0];
}

- (IBAction)logoutButtonPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate logoutCurrentUser];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


@end
