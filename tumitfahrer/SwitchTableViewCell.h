//
//  SwitchTableViewCell.h
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

@protocol SwitchTableViewCellDelegate

-(void)switchChangedToStatus:(BOOL)status switchId:(NSInteger)switchId;

@end

@interface SwitchTableViewCell : UITableViewCell

@property (nonatomic, strong) id <SwitchTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *switchCellTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchElement;
@property (nonatomic, assign) NSInteger switchId;

- (IBAction)switchChanged:(id)sender;

@end
