//
//  CircularImageView.m
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

#import "CircularImageView.h"

@implementation CircularImageView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.image = image;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addMaskToBounds:self.frame];
}

- (void)addMaskToBounds:(CGRect)maskBounds
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	
    CGPathRef maskPath = CGPathCreateWithEllipseInRect(maskBounds, NULL);
    maskLayer.bounds = maskBounds;
	maskLayer.path = maskPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
    maskLayer.position = point;
    
	[self.layer setMask:maskLayer];
    
    if ([self.borderWidth integerValue] > 0)
    {
        // create the outline layer
        CAShapeLayer*   shape   = [CAShapeLayer layer];
        shape.bounds = maskBounds;
        shape.path = maskPath;
        shape.lineWidth = [self.borderWidth doubleValue] * 2.0f;
        shape.strokeColor = self.borderColor.CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.position = point;
        
        [self.layer addSublayer:shape];
    }
    
    CGPathRelease(maskPath);
}

- (void)setup
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    self.borderWidth    = @0.0f;
    self.borderColor    = [UIColor whiteColor];
}



@end
