//
//  AddRideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AddRideViewController.h"
#import "CustomBarButton.h"
#import "ActionManager.h"

@interface AddRideViewController ()

@property (nonatomic) UIColor *customGrayColor;

@end

@implementation AddRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customGrayColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.view setBackgroundColor:self.customGrayColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setupNavbar];
}

-(void)viewWillAppear:(BOOL)animated {
}

-(void)setupNavbar
{
    UIColor *navBarColor = [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1]; /*#0e3750*/
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:navBarColor];
    [self.navigationController.navigationBar setBackgroundImage:[[ActionManager sharedManager] imageWithColor:navBarColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    // left button of the navigation bar
    CustomBarButton *closeButton = [[CustomBarButton alloc] initWithTitle:@"Close"];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = closeButtonItem;
    
    // right button of the navigation bar
    CustomBarButton *searchButton = [[CustomBarButton alloc] initWithTitle:@"Add"];
    [searchButton addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    // title of the navigation bar
    self.title = @"Add a Ride";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}


-(void)searchButtonPressed {
    
}

-(void)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
