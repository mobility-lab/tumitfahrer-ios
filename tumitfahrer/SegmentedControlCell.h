//
//  DriverPassengerCell.h
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

@protocol SegmentedControlCellDelegate

-(void)segmentedControlChangedToIndex:(NSInteger)index segmentedControlId:(NSInteger)controlId;

@end

@interface SegmentedControlCell : UITableViewCell

+(SegmentedControlCell *)segmentedControlCell;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) id <SegmentedControlCellDelegate> delegate;
@property (nonatomic, strong) NSString *firstSegmentTitle;
@property (nonatomic, strong) NSString *secondSegmentTitle;
@property (nonatomic, assign) NSInteger controlId;

-(void)setFirstSegmentTitle:(NSString *)firstSegmentTitle secondSementTitle:(NSString *)secondSegmentTitle;
-(void)addHandlerToSegmentedControl;

@end
