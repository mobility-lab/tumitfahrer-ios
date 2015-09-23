//
//  CircularImageView.h
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

#import <UIKit/UIKit.h>

/**
 *  Class that creates a circular image view from the normal image.
 */
@interface CircularImageView : UIImageView

/**
 *  Inits image view with the normal image.
 *
 *  @param frame Size of the requested frame.
 *  @param image Original image.
 *
 *  @return the class object.
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) UIColor* borderColor;
@property (nonatomic, copy) NSNumber* borderWidth;

@end
