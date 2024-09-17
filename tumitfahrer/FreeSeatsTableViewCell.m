//
//  FreeSeatsTableViewCell.m
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

#import "FreeSeatsTableViewCell.h"

@implementation FreeSeatsTableViewCell

+(FreeSeatsTableViewCell *)freeSeatsTableViewCell {
    
    FreeSeatsTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FreeSeatsTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.stepper.value = 1;
    cell.stepper.maximumValue = 8;
    cell.stepper.minimumValue = 1;
#ifdef DEBUG
    // set label for kif test
    [cell.stepper setAccessibilityLabel:@"Seat Stepper"];
    [cell.stepper setIsAccessibilityElement:YES];
#endif
    return cell;
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    NSUInteger value = sender.value;
    self.passengersCountLabel.text = [NSString stringWithFormat:@"%d", (int)value];
    [self.delegate stepperValueChanged:value];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
