//
//  StomtHeaderView.m
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

#import "StomtHeaderView.h"

@implementation StomtHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIPickerView *opinionPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(50.0, -40.0, 100.0, 120.0)];
        UIPickerView *targetsPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(120.0, -40.0, 200.0, 120.0)];
        [opinionPickerView setTag:100];
        [targetsPickerView setTag:101];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 150, 280, 60)];
        textView.text = @"because ";
        [textView setFont:[UIFont systemFontOfSize:13.0f]];
        [textView setTag:102];
        
        UIButton *btnStomt = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 220, 100, 35)];
        [btnStomt setTitle:@"stomt!" forState:UIControlStateNormal];
        [btnStomt setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateNormal];
        [btnStomt setTag:103];
        
        UILabel *iLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 20, 40)];
        iLabel.text = @"I";
        [iLabel setFont:[UIFont systemFontOfSize:25.0f]];
        
        UILabel *optionalText = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 280, 20)];
        optionalText.text = @"Optional text (100 characters):";
        [optionalText setFont:[UIFont systemFontOfSize:13.0f]];
        [optionalText setTag:104];
        
        [self addSubview:optionalText];
        [self addSubview:iLabel];
        [self addSubview:btnStomt];
        [self addSubview:textView];
        [self addSubview:opinionPickerView];
        [self addSubview:targetsPickerView];
        [self sendSubviewToBack:targetsPickerView];
    }
    return self;
}

@end
