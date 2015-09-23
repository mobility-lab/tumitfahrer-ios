//
//  CustomUILabel.m
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

#import "CustomUILabel.h"

@implementation CustomUILabel

- (instancetype)initInMiddle:(CGRect)frame text:(NSString *)text viewWithNavigationBar:(UINavigationBar *)navigationBar {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0; //will wrap text in new line
        [self setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]];//font size and style
        [self setTextColor:[UIColor whiteColor]];
        self.text = text;
        self.textAlignment = NSTextAlignmentCenter;
        [self sizeToFit];
        
        // postition label exactly in the middle of the screen with navigation bar
        self.frame = CGRectMake(frame.size.width/2-self.frame.size.width/2, frame.size.height/2-75-navigationBar.frame.size.height, self.frame.size.width, 150);
    }

    return self;
}

@end
