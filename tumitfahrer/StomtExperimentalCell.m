//
//  StomtExperimentalCell.m
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

#import "StomtExperimentalCell.h"
#import "ActionManager.h"
#import "StomtUtilities.h"

@implementation StomtExperimentalCell

- (void)awakeFromNib {
    self.plusButton.backgroundColor = [UIColor customGreen];
    [self.plusButton addTarget:self action:@selector(plusHighlight) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchCancel];

    self.minusButton.backgroundColor = [UIColor lightRed];
    [self.minusButton addTarget:self action:@selector(minusHighlight) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchCancel];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)plusHighlight {
    self.plusButton.backgroundColor = [UIColor greenColor];
}

-(void)plusNormal {
    self.plusButton.backgroundColor = [UIColor customGreen];
}

-(void)minusHighlight {
    self.minusButton.backgroundColor = [UIColor redColor];
}

-(void)minusNormal {
    self.minusButton.backgroundColor = [UIColor lightRed];
}

- (IBAction)plusButtonPressed:(id)sender {
    if (self.stomtOpinionType == NoneStomt) {
        [StomtUtilities postAgreementWithId:self.stomt.stomtId isNegative:[NSNumber numberWithInt:0] boolCompletionHandler:^(BOOL posted) {
            [self.delegate shouldReloadTable];
        }];
    } else if(self.stomtOpinionType == NegativeStomt) { // cancel negative stomt, delete user's agreement
        [StomtUtilities deleteAgreementFromStomt:self.stomt block:^(BOOL posted) {
            self.minusButton.backgroundColor = [UIColor lightGrayColor];
            self.plusButton.backgroundColor = [UIColor lightGrayColor];
            [self.delegate shouldReloadTable];
        }];
    } else {
        self.plusButton.backgroundColor = [UIColor customGreen];
    }
}

- (IBAction)minusButtonPressed:(id)sender {
    if (self.stomtOpinionType == NoneStomt) {
        [StomtUtilities postAgreementWithId:self.stomt.stomtId isNegative:[NSNumber numberWithInt:1] boolCompletionHandler:^(BOOL posted) {
            [self.delegate shouldReloadTable];
        }];
    } else if(self.stomtOpinionType == PositiveStomt) { // cancel positive stomt, delete user's agreement
        [StomtUtilities deleteAgreementFromStomt:self.stomt block:^(BOOL posted) {
            self.minusButton.backgroundColor = [UIColor lightGrayColor];
            self.plusButton.backgroundColor = [UIColor lightGrayColor];
            [self.delegate shouldReloadTable];
        }];
    } else {
        self.minusButton.backgroundColor = [UIColor lightRed];
    }
}

@end
