//
//  YourRidesPageViewController.m
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

#import "YourRidesPageViewController.h"
#import "YourRidesViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "LogoView.h"
#import "CurrentUser.h"
#import "LoginViewController.h"
#import "CustomBarButton.h"
#import "NavigationBarUtilities.h"
#import "TimelineMapViewController.h"
#import "MenuViewController.h"
#import "ActionManager.h"
#import "LocationController.h"

@interface YourRidesPageViewController () <YourRidesViewControllerDelegate>

@property NSArray *pageTitles;

@end

@implementation YourRidesPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageTitles = [NSArray arrayWithObjects:@"Created", @"Joined", @"Past", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    YourRidesViewController *initialViewController = [self viewControllerAtIndex:0];
    initialViewController.delegate = self;
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    self.view.backgroundColor = [UIColor customLightGray];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupLeftMenuButton];
    [self setupNavigationBar];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lightestBlue]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.logo = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 200, 41) title:[self.pageTitles objectAtIndex:0]];
    [self.navigationItem setTitleView:self.logo];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(YourRidesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    index--;
    if(index==2){//Around me, request location
        [[LocationController sharedInstance] startUpdatingLocation];
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(YourRidesViewController *)viewController index];
    
    index++;
    if (index == 3) {
        return nil;
    }
    if(index==2){//Around me, request location
        [[LocationController sharedInstance] startUpdatingLocation];
    }
    
    return [self viewControllerAtIndex:index];
}

- (YourRidesViewController *)viewControllerAtIndex:(NSUInteger)index {
    YourRidesViewController *yourRidesViewController = [[YourRidesViewController alloc] init];
    yourRidesViewController.index = index;
    yourRidesViewController.delegate = self;
    return yourRidesViewController;
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    MenuViewController *menu = (MenuViewController *)self.sideBarController.leftDrawerViewController;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:3];
    [menu.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];

    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

# pragma mark - delegate methods

-(void)willAppearViewWithIndex:(NSInteger)index {
    self.logo.titleLabel.text = [self.pageTitles objectAtIndex:index];
    self.logo.pageControl.currentPage = index;
    [self.navigationController.navigationBar setBarTintColor:[UIColor lightestBlue]];
}

@end