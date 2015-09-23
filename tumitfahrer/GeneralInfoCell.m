//
//  GeneralInfoCell.m
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

#import "GeneralInfoCell.h"
#import "ActionManager.h"

@implementation GeneralInfoCell

+(GeneralInfoCell *)generalInfoCell {
    
    GeneralInfoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"GeneralInfoCell" owner:self options:nil] objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor lightestBlue];
    cell.driverImageView.image = [UIImage imageNamed:@"DriverIconBig"];
    cell.passengerImageView.image = [UIImage imageNamed:@"PassengerIconMiddle"];
    cell.ratingImageView.image = [UIImage imageNamed:@"RatingIconBig"];
    
    return cell;
}


@end
