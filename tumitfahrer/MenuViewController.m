//
//  MenuViewController.m
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

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "SettingsViewController.h"
#import "ActionManager.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "CurrentUser.h"
#import "SearchRideViewController.h"
#import "AddRideViewController.h"
#import "YourRidesPageViewController.h"
#import "MMDrawerController.h"
#import "TimelinePageViewController.h"
#import "RidesPageViewController.h"
#import "CircularImageView.h"
#import "WebserviceRequest.h"
#import "Badge.h"
#import "RidesViewController.h"

@interface MenuViewController ()

@property NSArray *timelineSection;
@property NSArray *timelineViewControllers;
@property NSArray *timelineIcons;
@property NSArray *browseRidesSection;
@property NSArray *browseRidesViewControllers;
@property NSArray *browseRidesIcons;
@property NSArray *addRidesSection;
@property NSArray *addRidesViewControllers;
@property NSArray *addRidesIcons;
@property NSArray *profileSection;
@property NSArray *profileViewControllers;
@property NSArray *profileIcons;

@property NSArray *allMenuItems;
@property NSArray *allViewControllers;
@property NSArray *allIcons;
@property Badge *badge;

@end

@implementation MenuViewController

#pragma mark - initializers
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initViewControllers];
        [self initCellTitles];
        [self initCellIcons];
    }
    return self;
}

-(void)initViewControllers {

    TimelinePageViewController *timelinePageVC = [[TimelinePageViewController alloc] init];
    self.timelineViewControllers = [NSArray arrayWithObjects:timelinePageVC, nil];
    
    // section 0 - view controllers
    RidesPageViewController *campusRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeCampusRides];
    RidesPageViewController *activityRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeActivityRides];
    RidesViewController *getACar =  [[RidesViewController alloc] init];
    [getACar setIndex:2];
    self.browseRidesViewControllers = [NSArray arrayWithObjects:campusRidesVC, activityRidesVC,getACar, nil];
    
    
    // section 1 - view controllers
    AddRideViewController *addRideVC = [[AddRideViewController alloc] init];
    addRideVC.RideDisplayType = ShowAsViewController;
    addRideVC.TableType = Driver;
    addRideVC.RideType = ContentTypeCampusRides;
    SearchRideViewController *searchRidesVC = [[SearchRideViewController alloc] init];
    searchRidesVC.SearchDisplayType = ShowAsViewController;
    self.addRidesViewControllers = [NSArray arrayWithObjects: addRideVC, searchRidesVC, nil];
    
    // section 2 - view controllers
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    YourRidesPageViewController *yourRidesPageVC = [[YourRidesPageViewController alloc] init];
    self.profileViewControllers = [NSArray arrayWithObjects:profileVC, yourRidesPageVC, nil];
    
    // add all sections to view controllers
    self.allViewControllers = [NSArray arrayWithObjects:self.timelineViewControllers, self.browseRidesViewControllers, self.addRidesViewControllers, self.profileViewControllers, nil];
}

-(void)initCellTitles {
    self.timelineSection = [NSArray arrayWithObjects:@"Timeline", nil];
    self.browseRidesSection = [NSArray arrayWithObjects:@"Campus Rides", @"Activity Rides",@"Get a car",  nil];
    self.addRidesSection = [NSArray arrayWithObjects:@"Add", @"Search", nil];
    self.profileSection = [NSArray arrayWithObjects:@"Your Profile", @"Your Rides", nil];
    self.allMenuItems = [NSArray arrayWithObjects:self.timelineSection, self.browseRidesSection, self.addRidesSection, self.profileSection, nil];
}

-(void)initCellIcons {
    self.timelineIcons = [NSArray arrayWithObjects:@"NewsFeedIcon", nil];
    self.browseRidesIcons = [NSArray arrayWithObjects:@"CampusIcon", @"ActivityIcon",@"GetACar", nil];
    self.addRidesIcons = [NSArray arrayWithObjects:@"AddIcon", @"SearchIcon", nil];
    self.profileIcons = [NSArray arrayWithObjects:@"ProfileIcon", @"ScheduleIcon", nil];
    self.allIcons = [NSArray arrayWithObjects:self.timelineIcons, self.browseRidesIcons, self.addRidesIcons, self.profileIcons, nil];
}

#pragma mark - view controller configuration

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackgroundToTableView];
}

-(void)addBackgroundToTableView {
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.325 green:0.655 blue:0.835 alpha:1];
}

-(void)makeHeaderForTableView {
    UIView *menuTopHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"MenuTopHeaderView" owner:self options:nil] firstObject];
    menuTopHeaderView.frame = CGRectMake(0, 0, 280, 128);
    UILabel *initialsLabel = (UILabel *)[menuTopHeaderView viewWithTag:2];
    UILabel *usernameLabel = (UILabel *)[menuTopHeaderView viewWithTag:3];
    UIButton *settingsButton = (UIButton *)[menuTopHeaderView viewWithTag:4];
    
    usernameLabel.text = [CurrentUser sharedInstance].user.firstName;
    initialsLabel.text = [[[CurrentUser sharedInstance].user.firstName substringToIndex:1] stringByAppendingString:[[CurrentUser sharedInstance].user.lastName substringToIndex:1]];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"SettingsIcon"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    if([CurrentUser sharedInstance].user.profileImageData != nil) {
        CircularImageView *circularImageView = circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake(18, 30, 70, 70) image:[UIImage imageWithData:[CurrentUser sharedInstance].user.profileImageData]];
        [menuTopHeaderView addSubview:circularImageView];
    } else {
        CircularImageView *circularImageView = circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake(18, 30, 70, 70) image:[UIImage imageNamed:@"CircleBlue"]];
        [menuTopHeaderView addSubview:circularImageView];
    }
    menuTopHeaderView.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    self.tableView.tableHeaderView = menuTopHeaderView;
}

-(void)initTableViewSize {
    if (iPhone5) {
        self.view.frame = CGRectMake(0, 0, 480, 568);
        self.tableView.frame = CGRectMake(0, 0, 280, 568);
    } else {
        self.view.frame = CGRectMake(0, 0, 480, 480);
        self.tableView.frame = CGRectMake(0, 0, 280, 480);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeHeaderForTableView];
    [self getBadges];
    [self initTableViewSize];
}

-(void)getBadges {
    [WebserviceRequest getBadgeCounterForUserId:[CurrentUser sharedInstance].user.userId block:^(Badge *badge) {
        if (badge != nil) {
            [self setCurrentBadge:badge];
            [self reloadTable];
        }
    }];
}

-(void)reloadTable {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

-(void)setCurrentBadge:(Badge *)badge {
    self.badge = badge;
}

#pragma mark - table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allMenuItems count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.allMenuItems objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuTableViewCell";
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    
    cell.menuLabel.text = [[self.allMenuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    // add icon to the cell
    UIImage *newImg = [UIImage imageNamed:[[self.allIcons objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.iconMenuImageView.image = newImg;
    cell.menuLabel.highlightedTextColor = [UIColor whiteColor];
    // set background of cell to transparent
    // configure background of selected cell
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    if(indexPath.section == 0) {
        cell.backgroundColor = [UIColor darkestBlue];
        cell.contentView.backgroundColor = [UIColor darkestBlue];
    } else if(indexPath.section == 1) {
        cell.backgroundColor = [UIColor darkerBlue];
        cell.contentView.backgroundColor = [UIColor darkerBlue];
    } else if(indexPath.section == 2) {
        cell.backgroundColor = [UIColor lighterBlue];
        cell.contentView.backgroundColor = [UIColor lighterBlue];
    } else if(indexPath.section == 3) {
        cell.backgroundColor = [UIColor lightestBlue];
        cell.contentView.backgroundColor = [UIColor lightestBlue];
    }
    
    //badges
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([self.badge.campusBadge intValue] > 0) {
            cell.anotherTest.hidden = NO;
            cell.anotherTest.text = [NSString stringWithFormat:@"%d", [self.badge.campusBadge intValue]];
            cell.backgroundBadgeTest.hidden = NO;
        } else {
            cell.badgeTestLabel.hidden = YES;
            cell.backgroundBadgeTest.hidden = YES;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if ([self.badge.activityBadge intValue] > 0) {
            cell.anotherTest.hidden = NO;
            cell.anotherTest.text = [NSString stringWithFormat:@"%d", [self.badge.activityBadge intValue]];
            cell.backgroundBadgeTest.hidden = NO;
        } else {
            cell.badgeTestLabel.hidden = YES;
            cell.backgroundBadgeTest.hidden = YES;
        }
    }
    
    if (indexPath.section == 3 && indexPath.row == 1) {
        if ([self.badge.myRidesBadge intValue] > 0) {
            cell.anotherTest.hidden = NO;
            cell.anotherTest.text = [NSString stringWithFormat:@"%d", [self.badge.myRidesBadge intValue]];
            cell.backgroundBadgeTest.hidden = NO;
        } else {
            cell.badgeTestLabel.hidden = YES;
            cell.backgroundBadgeTest.hidden = YES;
        }
    }
    
    return cell;
}

-(void)showBadgeForCell:(MenuTableViewCell **)cell labelNumber:(NSNumber *)labelNumber{
    (*cell).badgeImageView.hidden = NO;
    (*cell).badgeLabel.hidden = NO;
    (*cell).badgeLabel.text = [NSString stringWithFormat:@"%@", labelNumber];
}

-(void)hideBadgeForCell:(MenuTableViewCell **)cell {
    (*cell).badgeLabel.hidden = YES;
    (*cell).badgeImageView.hidden = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = [[self.allViewControllers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(viewController) {
        UITableViewCell *c = [self.tableView cellForRowAtIndexPath:indexPath];
        c.textLabel.font = [UIFont boldSystemFontOfSize:14.0]; // for example
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self.sideBarController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }
}

-(void)settingsButtonPressed {
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self.sideBarController setCenterViewController:navController withCloseAnimation:YES completion:nil];
}

@end
