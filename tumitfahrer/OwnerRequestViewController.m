//
//  OwnerRequestViewController.m
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

#import "OwnerRequestViewController.h"
#import "Ride.h"
#import "RideInformationCell.h"
#import "CurrentUser.h"
#import "RidesStore.h"
#import "RideSectionHeaderCell.h"
#import "HeaderContentView.h"
#import "RideRequestInformationCell.h"
#import "WebserviceRequest.h"
#import "RideDetailActionCell.h"
#import "EditRequestViewController.h"
#import "CustomIOS7AlertView.h"
#import "KGStatusBar.h"

@interface OwnerRequestViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, HeaderContentViewDelegate, CustomIOS7AlertViewDelegate>

@end

@implementation OwnerRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerView.backgroundColor = [UIColor darkerBlue];
    [self.view bringSubviewToFront:_headerView];
    [[RidesStore sharedStore] addObserver:self];
    
    self.rideDetail.headerView = _headerView;
    self.rideDetail.tableView.backgroundColor = [UIColor customLightGray];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Owner request string";
    
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
    self.headerTitles = [NSArray arrayWithObjects:@"Details", @"", nil];
    
    [self reloadTableAndRide];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == [self.headerTitles count] -1) {
        return 0;
    }
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headerTitles objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RideSectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideNoticeCell"];
    if(cell == nil) {
        cell = [RideSectionHeaderCell rideSectionHeaderCell];
    }
    cell.noticeLabel.text = [self.headerTitles objectAtIndex:section];
    [cell.editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *generalCell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
    if (!generalCell) {
        generalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
    }
    
    generalCell.textLabel.text = @"Default cell";
    
    if(indexPath.section == 0) {
        RideRequestInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideRequestInformationCell"];
        if(cell == nil){
            cell = [RideRequestInformationCell rideRequestInformationCell];
        }
        cell.requestInfoLabel.text = self.ride.meetingPoint;
        return cell;
    } else {  // show delete button
        RideDetailActionCell *actionCell = [RideDetailActionCell offerRideCell];
        [actionCell.actionButton setTitle:@"Delete ride" forState:UIControlStateNormal];
        [actionCell.actionButton addTarget:self action:@selector(showCancelationAlertView) forControlEvents:UIControlEventTouchDown];
        return actionCell;
    }
    
    return generalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)deleteRideButtonPressed {
    [WebserviceRequest deleteRideFromWebservice:self.ride block:^(BOOL isDeleted) {
        if (isDeleted) {
            [KGStatusBar showSuccessWithStatus:@"Ride request successfully deleted"];

            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (self.textView.text.length < 25) {
            self.counterLabel.textColor = [UIColor redColor];
        } else {
            [self deleteRideButtonPressed];
            [alertView close];
        }
    } else {
        [alertView close];
    }
}

-(void)editButtonTapped {
    EditRequestViewController *editRequestVC = [[EditRequestViewController alloc] init];
    editRequestVC.ride = self.ride;
    [self.navigationController pushViewController:editRequestVC animated:YES];
}

-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

@end
