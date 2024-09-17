//
//  RideDetailView.h
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
#import "HeaderImageView.h"
#import "Ride.h"

@protocol HeaderContentViewDelegate

@optional

- (void)headerViewTapped;
- (void)mapButtonTapped;
- (void)editButtonTapped;
- (void)initFields;

@end

@interface HeaderContentView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) id<HeaderContentViewDelegate> delegate;

@property (nonatomic) CGFloat defaultimagePagerHeight;
@property (nonatomic) CGFloat parallaxScrollFactor;

@property (nonatomic) CGFloat headerFade;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIColor *backgroundViewColor;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) HeaderImageView *rideDetailHeaderView;
@property (nonatomic) CGRect rideDetailFrame;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<UITableViewDataSource> tableViewDataSource;
@property (nonatomic, weak) id<UITableViewDelegate> tableViewDelegate;

@property (nonatomic, strong) NSData *selectedImageData;
@property (nonatomic, strong) UIImage *circularImage;

@property (nonatomic, assign) BOOL shouldDisplayGradient;

@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UILabel *departureLabel;
@property (nonatomic, strong) UILabel *destinationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *calendarLabel;

@end
