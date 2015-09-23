//
//  RidesCell.m
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

#import "RidesCell.h"
#import "ActionManager.h"

@implementation RidesCell

+(RidesCell *)ridesCell {
    RidesCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RidesCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIColor *grayColor = [UIColor colorWithRed:0.808 green:0.808 blue:0.808 alpha:1];
    cell.roleView.backgroundColor = [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1];
    cell.roleImageView.image = [UIImage imageNamed:@"DriverIcon"];
//    cell.timeLabel.textColor = grayColor;
//    cell.dateLabel.textColor = grayColor;
//    cell.seatsLabel.textColor = [UIColor whiteColor];
//    cell.destinationLabel.textColor = grayColor;
//    cell.directionsLabel.textColor = grayColor;

    return cell;
}

- (void)awakeFromNib {
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.size.width -= 2 * 10;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
