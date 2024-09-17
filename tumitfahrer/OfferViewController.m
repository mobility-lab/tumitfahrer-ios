//
//  RideDetailViewController.m
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

#import "OfferViewController.h"
#import "RideInformationCell.h"
#import "ActionManager.h"
#import "Request.h"
#import "CurrentUser.h"
#import "KGStatusBar.h"
#import "RidesStore.h"
#import "HeaderContentView.h"
#import "CircularImageView.h"
#import "WebserviceRequest.h"
#import "RideDetailActionCell.h"
#import "ActivityStore.h"
#import "User.h"
#import "RidePersonCell.h"
#import "SimpleChatViewController.h"
#import "RideSectionHeaderCell.h"
#import "ProfileViewController.h"
#import "Rating.h"
#import "ConversationUtilities.h"
#import "AWSUploader.h"
#import "Conversation.h"

@interface OfferViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, HeaderContentViewDelegate, RidePersonCellDelegate>

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerView.backgroundColor = [UIColor darkerBlue];
    [self.view bringSubviewToFront:_headerView];
    [[RidesStore sharedStore] addObserver:self];
    editButton.hidden = YES;
    
    self.rideDetail.headerView = _headerView;
    self.headerTitles = [NSArray arrayWithObjects:@"Details", @"Driver", @"",nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Offer screen";
    
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 100.0f;
    } else if (indexPath.section == 1) {
        return 60;
    }
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // if past ride then don't show last section with action button
    if ([self isPastRide]) {
        return 2;
    }
    return 3;
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
        RideInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideInformationCell"];
        if(cell == nil){
            cell = [RideInformationCell rideInformationCell];
        }
        
        if (self.ride.car != nil) {
            cell.carLabel.text = self.ride.car;
        } else if (self.ride.rideOwner != nil && self.ride.rideOwner.car != nil) {
            cell.carLabel.text = self.ride.rideOwner.car;
        } else {
            cell.carLabel.text = @"Not specified";
        }
        cell.informationLabel.text = self.ride.meetingPoint;
        cell.freeSeatsLabel.text = [NSString stringWithFormat:@"%d/%@",[self.ride.freeSeats intValue]- [self.ride.freeSeatsCurrent intValue], self.ride.freeSeats];

        return cell;
    } else if (indexPath.section == 1) { // show driver
        
        RidePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RidePersonCell"];
        if (cell == nil) {
            cell = [RidePersonCell ridePersonCell];
        }


        cell.delegate = self;
        if (self.ride.rideOwner != nil) {
            cell.personNameLabel.text = [self.ride.rideOwner.firstName stringByAppendingString:[NSString stringWithFormat:@"\nRating: %@", self.ride.rideOwner.ratingAvg]];
            if (self.ride.rideOwner.profileImageData != nil) {
                cell.personImageView.image = [UIImage imageWithData:self.ride.rideOwner.profileImageData];
            } else {
                [[AWSUploader sharedStore] downloadProfilePictureForUser:self.ride.rideOwner];
            }
        }
        if ([self isPastRide] && self.ride.rideOwner != nil) {
            [cell.leftButton setImage:[UIImage imageNamed:@"DislikeIconBlack"] forState:UIControlStateNormal];
            [cell.rightButton setImage:[UIImage imageNamed:@"LikeIconBlack"] forState:UIControlStateNormal];
            
            Rating *rating = [self isRatingGivenForUserId:self.ride.rideOwner.userId];
            if (rating != nil && [rating.ratingType boolValue]) {
                cell.leftButton.hidden = YES;
                cell.rightButton.enabled = NO;
            } else if(rating != nil && ![rating.ratingType boolValue]) {
                cell.leftButton.enabled = NO;
                cell.rightButton.hidden = YES;
            }
        } else {
            cell.leftButton.hidden = YES;
            if([self isPassengerOfRide]) {
                cell.rightButton.hidden = NO;
            } else {
                cell.rightButton.hidden = YES;
            }
        }
        return cell;
    } else if(indexPath.section == 2) { // show leave button if it's not a past ride
        
        RideDetailActionCell *actionCell = [RideDetailActionCell offerRideCell];
        [actionCell.actionButton addTarget:self action:@selector(joinButtonPressed) forControlEvents:UIControlEventTouchDown];
        Request *request = [self requestFoundInCoreData];
        
        if (request != nil) {
            [actionCell.actionButton setTitle:@"Leave ride" forState:UIControlStateNormal];
        } else if([self isPassengerOfRide]) {
            [actionCell.actionButton setTitle:@"Leave ride as passenger" forState:UIControlStateNormal];
        } else {
            [actionCell.actionButton setTitle:@"Join ride" forState:UIControlStateNormal];
        }
        return actionCell;
    }
    
    return generalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        profileVC.user = self.ride.rideOwner;
        profileVC.returnEnum = ViewController;
        [self.navigationController pushViewController:profileVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - LocationDetailViewDelegate

#pragma mark - Button actions

-(Request *)requestFoundInCoreData {
    for (Request *request in self.ride.requests) {
        if ([request.passengerId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
            return request;
        }
    }
    return nil;
}

-(BOOL)isPassengerOfRide {
    if ([self.ride.passengers containsObject:[CurrentUser sharedInstance].user]) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - offer ride cell

-(void)joinButtonPressed {
    if([self.ride.freeSeatsCurrent isEqual:[NSNumber numberWithInt:0]]){
        [ActionManager showAlertViewWithTitle: @"Error" description:@"The ride is currently full."];
        return;
    }
    
    if (![self isPassengerOfRide]) {
        
        Request *request = [self requestFoundInCoreData];
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        objectManager.requestSerializationMIMEType = RKMIMETypeJSON ;
        
        if (request == nil) {
            NSDictionary *queryParams;
            // add enum
            NSString *userId = [NSString stringWithFormat:@"%@", [CurrentUser sharedInstance].user.userId];
            queryParams = @{@"passenger_id": userId};
            

            
            [objectManager postObject:nil path:[NSString stringWithFormat:@"/api/v3/rides/%@/requests", self.ride.rideId] parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [KGStatusBar showSuccessWithStatus:@"Request was sent"];
                
                Request *rideRequest = (Request *)[mappingResult firstObject];
                [self fetchRide];
                [[RidesStore sharedStore] addRideRequestToStore:rideRequest forRide:self.ride];
                
                [self.rideDetail.tableView reloadData];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [ActionManager showAlertViewWithTitle:@"Error" description:@"Could not send ride request"];
                RKLogError(@"Load failed with error: %@", error);
            }];
        } else {
            [objectManager deleteObject:request path:[NSString stringWithFormat:@"/api/v3/rides/%@/requests/%d", self.ride.rideId, [request.requestId intValue]] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                
                [KGStatusBar showSuccessWithStatus:@"Request canceled"];
                [[RidesStore sharedStore] deleteRideRequest:request];
                [[ActivityStore sharedStore] deleteRequestFromActivites:request];
                
                [self.rideDetail.tableView reloadData];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                RKLogError(@"Load failed with error: %@", error);
            }];
        }
    } else {
        [WebserviceRequest removePassengerWithId:[CurrentUser sharedInstance].user.userId rideId:self.ride.rideId block:^(BOOL fetched) {
            if (fetched) {
                [[RidesStore sharedStore] removePassengerForRide:self.ride.rideId passenger:[CurrentUser sharedInstance].user];
                [self.rideDetail.tableView reloadData];
            }
        }];
    }
}

-(void)fetchRide {
    [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:self.ride.rideId block:^(Ride *fetchedRide) {
        if (fetchedRide) {
            [self initRide];
        }
    }];
}

-(void)initRide {
    self.ride = [[RidesStore sharedStore] fetchRideFromCoreDataWithId:self.ride.rideId];
}

-(void)leftButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType {
    
    if ([self isPastRide]) {
        [WebserviceRequest giveRatingToUserWithId:self.ride.rideOwner.userId rideId:self.ride.rideId ratingType:0 block:^(BOOL given) {
            if (given) {
                [self updateRide];
            }
        }];
    }
}

-(void)rightButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType {
    
    if ([self isPastRide]) {
        [WebserviceRequest giveRatingToUserWithId:self.ride.rideOwner.userId rideId:self.ride.rideId ratingType:1 block:^(BOOL given) {
            if (given) {
                [self updateRide];
            }
        }];
    } else {
        [self contactDriverButtonPressed];
    }
}

-(void)removeRideRequest:(NSIndexPath *)indexPath requestor:(Request *)request {
    if ([[RidesStore sharedStore] removeRequestForRide:self.ride.rideId request:request]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)passengerCellChangedForPassenger:(User *)passenger {
    if ([[RidesStore sharedStore] removePassengerForRide:self.ride.rideId passenger:passenger]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)contactDriverButtonPressed {
    SimpleChatViewController *simpleChatVC = [[SimpleChatViewController alloc] init];
    simpleChatVC.otherUser = self.ride.rideOwner;
    Conversation *conversation = [ConversationUtilities findConversationBetweenUser:[CurrentUser sharedInstance].user otherUser:self.ride.rideOwner conversationArray:[self.ride.conversations allObjects]];
    if (conversation != nil) {
        simpleChatVC.conversation =conversation;
        [self.navigationController pushViewController:simpleChatVC animated:YES];
    } else {
    }
}


-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

@end