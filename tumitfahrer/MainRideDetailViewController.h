//
//  MainRideDetailViewController.h
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

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class HeaderContentView, Ride, Rating;

@interface MainRideDetailViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
    @protected UIButton *editButton;
}

@property (nonatomic, strong) HeaderContentView *rideDetail;
@property (nonatomic, assign) ShouldDisplayEnum displayEnum;
@property (nonatomic, assign) ShouldGoBackEnum shouldGoBackEnum;
@property (strong, nonatomic) NSArray *headerTitles;
@property (strong, nonatomic) NSArray *headerIcons;
@property (nonatomic, strong) Ride* ride;

@property (nonatomic, strong) UILabel *counterLabel;
@property (nonatomic, strong) UITextView *textView;

- (void)showCancelationAlertView;
- (void)showCancelationAlertViewWithTitle:(NSString *)title;
- (BOOL)isPastRide;
- (Rating *)isRatingGivenForUserId:(NSNumber *)otherUserId;
- (void)updateRide;
- (void)reloadTableAndRide;


@end
