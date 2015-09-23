//
//  RidePersonCell.h
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


@protocol RidePersonCellDelegate <NSObject>

-(void)leftButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType;
-(void)rightButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType;

@end

@interface RidePersonCell : UITableViewCell

+ (RidePersonCell*)ridePersonCell;

@property (nonatomic, strong) id<RidePersonCellDelegate> delegate;
@property id leftObject;
@property id rightObject;

@property (assign, nonatomic) CellTypeEnum cellTypeEnum;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;

-(void) isDriver:(bool)isDriver;
- (IBAction)rightButtonPressed:(id)sender;
- (IBAction)leftButtonPressed:(id)sender;

@end
