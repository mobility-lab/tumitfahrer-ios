//
//  RidesViewController.m
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

#import "RidesViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "RidesCell.h"
#import "HeaderImageView.h"
#import "Ride.h"
#import "NavigationBarUtilities.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "CustomUILabel.h"
#import "ControllerUtilities.h"
#import "Photo.h"

@interface RidesViewController ()

@property (nonatomic, retain) UILabel *zeroRidesLabel;
@property CGFloat previousScrollViewYOffset;
@property UIRefreshControl *refreshControl;
@property NSCache *imageCache;
@property NSArray *cellsArray;
@property UIImage *passengerIcon;
@property UIImage *driverIcon;

@end

@implementation RidesViewController {
    UIWebView *webview;
    UIImageView *arrowLeft;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PanoramioUtilities sharedInstance] addObserver:self];
    [[RidesStore sharedStore] addObserver:self];
    
    [self.view setBackgroundColor:[UIColor customLightGray]];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"BrowseRidesPanoramioFooter" owner:self options:nil] objectAtIndex:0];
    self.tableView.tableFooterView = footerView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing rides"];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor darkerBlue];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.imageCache = [[NSCache alloc] init];
    
    self.passengerIcon = [ActionManager colorImage:[UIImage imageNamed:@"PassengerIcon"] withColor:[UIColor customLightGray]];
    self.driverIcon =  [ActionManager colorImage:[UIImage imageNamed:@"DriverIcon"] withColor:[UIColor customLightGray]];
    [self prepareZeroRidesLabel];
    if (iPhone5) {
        self.tableView.frame = CGRectMake(0, 0, 320, 498);
    } else {
        self.tableView.frame = CGRectMake(0, 0, 320, 408);
    }
    
    NSString *fullURL = @"https://carsharing.mvg-mobil.de/";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    [webview stringByEvaluatingJavaScriptFromString:[ActionManager prepareJavaScriptCodeWithGeolocation:[LocationController sharedInstance].currentLocation]];
    [webview loadRequest:requestObj];
    
    arrowLeft = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 250, 70, 70)];
    arrowLeft.image = [UIImage imageNamed:@"ArrowLeft"];
}

-(void)handleRefresh {
    NSDate *lastUpdate = [NSDate date];
    for (Ride *ride in [self ridesForCurrentIndex]) {
        if ([ride.updatedAt compare:lastUpdate] == NSOrderedAscending) {
            lastUpdate = ride.updatedAt;
        }
        if ([ride.createdAt compare:lastUpdate] == NSOrderedAscending) {
            lastUpdate = ride.createdAt;
        }
    }
    
    [[RidesStore sharedStore] fetchRidesfromDate:lastUpdate rideType:self.RideType block:^(BOOL fetched) {
        if (fetched) {
            [[RidesStore sharedStore] initRidesByType:self.RideType block:^(BOOL fetched) {
                [self checkIfAnyRides];
                [self addToImageCache];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }];
        }
    }];
}

-(void)addToImageCache {
    int counter = 0;
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    
    for (Ride *ride in [self ridesForCurrentIndex]) {
        UIImage *image = [UIImage imageWithData:ride.destinationImage];
        if (image == nil) {
            image = placeholderImage;
        }
        [_imageCache setObject:image forKey:[NSNumber numberWithInteger:counter]];
        counter++;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = [NSString stringWithFormat:@"Rides screen: %d", (int)self.index];
    [self.delegate willAppearViewWithIndex:self.index];
    
    if (self.index == 2) {
        [self.view addSubview:webview];
//        [self.view addSubview:arrowLeft];
        [self.view bringSubviewToFront:arrowLeft];
        self.tableView.hidden = YES;
        
        //Navbar
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            UINavigationController *navController = self.navigationController;
        [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1]];
            self.navigationController.navigationBar.translucent = YES;
        self.navigationItem.title = @"Get a car";
        
        MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftMenuButtonPressed)];
        
        [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
        
        
//            if(self.logo==nil){
//                self.logo = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 200, 41) title:[[self.pageTitles objectAtIndex:self.RideType] objectAtIndex:0]];
//            }
//            [self.navigationItem setTitleView:self.logo];
        
    } else {
        [arrowLeft removeFromSuperview];
        [webview removeFromSuperview];
        [self addToImageCache];
        [self.tableView reloadData];
        [self checkIfAnyRides];
        [self checkPhotosOfRides];
    }
}
-(void) leftMenuButtonPressed {
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)checkPhotosOfRides {
    for (Ride *ride in [self ridesForCurrentIndex]) {
        if (ride.destinationImage == nil) {
            [[RidesStore sharedStore] fetchImageForCurrentRide:ride];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self ridesForCurrentIndex] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RidesCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RidesCell"];
    
    if (cell == nil) {
        cell = [RidesCell ridesCell];
    }
    
    Ride *ride = [[self ridesForCurrentIndex] objectAtIndex:indexPath.section];
    UIImage *image = [_imageCache objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    if (image == nil) {
        if(ride.destinationImage == nil) {
            image = [UIImage imageNamed:@"Placeholder"];
        } else {
            image = [UIImage imageWithData:ride.destinationImage];
        }
        [_imageCache setObject:image forKey:[NSNumber numberWithInteger:indexPath.section]];
    }
    cell.rideImageView.image = image;
    cell.rideImageView.clipsToBounds = YES;
    cell.rideImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.timeLabel.text = [ActionManager timeStringFromDate:[ride departureTime]];
    cell.dateLabel.text = [ActionManager dateStringFromDate:[ride departureTime]];
    if([ride.isRideRequest boolValue]) {
        cell.seatsView.backgroundColor = [UIColor orangeColor];
        cell.roleImageView.image = self.passengerIcon;
        if ([ride.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
            cell.actionLabel.text = @"Your request";
        } else {
            cell.actionLabel.text = @"Offer ride";
        }
        
    } else {
        cell.seatsView.backgroundColor = [UIColor orangeColor];
        cell.roleImageView.image = self.driverIcon;
        if ([ride.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
            cell.actionLabel.text = @"Your ride";
        } else {
            cell.actionLabel.text = @"Join now";
        }
    }
    
    if ([ride.isRideRequest boolValue]) {
        cell.seatsView.hidden = YES;
    } else if ([ride.freeSeats intValue] - [ride.passengers count] == 1) {
        cell.seatsView.hidden = NO;
        cell.seatsLabel.text = @"1 seat left";
    } else {
        cell.seatsLabel.text = [NSString stringWithFormat:@"%d seats left", (int)([ride.freeSeats intValue]  - [ride.passengers count])];
    }
    
    cell.directionsLabel.text = [ride.departurePlace componentsSeparatedByString:@", "][0];
    cell.destinationLabel.text = [ride.destination componentsSeparatedByString:@", "][0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[ControllerUtilities viewControllerForRide:[[self ridesForCurrentIndex] objectAtIndex:indexPath.section]] animated:YES];
}

#pragma mark - scroll view methods
// http://stackoverflow.com/questions/19819165/imitate-ios-7-facebook-hide-show-expanding-contracting-navigation-bar

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frame.origin.y = 20;
        self.tableView.frame= CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frame.origin.y = -size;
    } else {
        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - (frame.size.height * (scrollDiff / scrollHeight))));
        // frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
    }
    
    [self.navigationController.navigationBar setFrame:frame];
    [self updateBarButtonItems:(1 - framePercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y < 20) {
        [self animateNavBarTo:-(frame.size.height - 21)];
    } else {
        [self updateBarButtonItems:1];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.navigationBar setFrame:frame];
        [self updateBarButtonItems:alpha];
    }];
}

#pragma mark - Observers Handlers

-(void)didReceivePhotoForRide:(NSNumber *)rideId {
    [self addToImageCache];
    [self.tableView reloadData];
}

-(void)didReceivePhotoForCurrentLocation:(UIImage *)image {
    [LocationController sharedInstance].currentLocationImage = image;
}

-(void)didRecieveRidesFromWebService:(NSArray *)rides {
    for (Ride *ride in rides) {
        NSLog(@"Ride: %@", ride);
    }
}

// if lower refres is show (pull up), then fetch rides that are later that the ride with last date

-(NSArray *)ridesForCurrentIndex {
    switch (self.index) {
        case 0:
            return [[RidesStore sharedStore] allRidesByType:self.RideType];
        case 1:
            return [[RidesStore sharedStore] ridesNearbyByType:self.RideType];
        case 2:
            return [[RidesStore sharedStore] favoriteRidesByType:self.RideType];
        default:
            return 0;
    }
}

-(void)checkIfAnyRides {
    if (self.index != 2 && [[self ridesForCurrentIndex] count] == 0) {
        if (self.index == 1 && ![LocationController locationServicesEnabled]) { // around me
            self.zeroRidesLabel.text = @"Please enable location services on your iPhone:\n\nSettings -> Privacy -> Location Services -> TUMitfahrer";
        } else {
            self.zeroRidesLabel.text = @"Currently no rides availble";
        }
        [self.view addSubview:self.zeroRidesLabel];
        self.zeroRidesLabel.hidden = NO;
        self.tableView.tableFooterView.hidden = YES;
    } else {
        [self.zeroRidesLabel removeFromSuperview];
        self.zeroRidesLabel.hidden = YES;
        self.tableView.tableFooterView.hidden = NO;
    }
}

-(void)prepareZeroRidesLabel {
    self.zeroRidesLabel = [[CustomUILabel alloc] initInMiddle:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) text:@"Currently no rides availble" viewWithNavigationBar:self.navigationController.navigationBar];
    self.zeroRidesLabel.textColor = [UIColor blackColor];
}

-(void)dealloc {
    [webview removeFromSuperview];
    [self.imageCache removeAllObjects];
    self.delegate = nil;
    [[RidesStore sharedStore] removeObserver:self];
    [[PanoramioUtilities sharedInstance] removeObserver:self];
}

@end
