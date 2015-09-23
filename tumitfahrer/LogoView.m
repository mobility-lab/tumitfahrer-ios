//
//  LogoView.m
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

#import "LogoView.h"

@implementation LogoView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoView" owner:self options:nil];
        LogoView *mainView = [subviewArray firstObject];
        
        UILabel *titleLabel = (UILabel *)[mainView viewWithTag:3];
        titleLabel.text = title;
//        titleLabel.textColor = [UIColor customLightGray];

        [self addSubview:mainView];
    }
    return self;
}

@end
