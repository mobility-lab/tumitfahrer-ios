//
//  DriverPassengerCell.m
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

#import "SegmentedControlCell.h"

@implementation SegmentedControlCell

+(SegmentedControlCell *)segmentedControlCell {
    
    SegmentedControlCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SegmentedControlCell" owner:self options:nil] objectAtIndex:0];
    cell.backgroundColor = [UIColor customLightGray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.segmentedControl.selectedSegmentIndex = 0;
    
    return cell;
}

-(void)setFirstSegmentTitle:(NSString *)firstSegmentTitle secondSementTitle:(NSString *)secondSegmentTitle {
    [self.segmentedControl setTitle:firstSegmentTitle forSegmentAtIndex:0];
    [self.segmentedControl setTitle:secondSegmentTitle forSegmentAtIndex:1];
}

-(void)addHandlerToSegmentedControl {
    [self.segmentedControl addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
}

-(void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    [self.delegate segmentedControlChangedToIndex:segmentedControl.selectedSegmentIndex segmentedControlId:self.controlId];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
