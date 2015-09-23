//
//  CustomBarButtonItem.m
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

#import "CustomBarButton.h"

@implementation CustomBarButton

-(instancetype)initWithTitle:(NSString*)title {
    
    self = [super init];
    if (self) {

        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.frame = CGRectMake(0, 0, 70, 30);
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 4;
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Thin" size:7]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    }

    return self;
}
@end
