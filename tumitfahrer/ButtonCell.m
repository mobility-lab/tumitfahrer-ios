//
//  ButtonCell.m
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

#import "ButtonCell.h"
#import "ActionManager.h"

@implementation ButtonCell

+(ButtonCell *)buttonCell {
    ButtonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.cellButton setTitle:@"Search" forState:UIControlStateNormal];
    [cell.cellButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"BlueButton"] withColor:[UIColor lighterBlue]] forState:UIControlStateNormal];
    
    return cell;
}

- (IBAction)buttonPressed:(id)sender {
    [self.delegate buttonSelected];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
