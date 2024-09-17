//
//  UIColor+LayoutColors.m
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

#import "UIColor+LayoutColors.h"

@implementation UIColor (LayoutColors)

+ (UIColor *)lightestBlue {
    return [UIColor colorWithRed:0.325 green:0.655 blue:0.835 alpha:1];
}

+ (UIColor *)lighterBlue {
    return [UIColor colorWithRed:0 green:0.463 blue:0.722 alpha:1];
}

+ (UIColor *)darkerBlue {
    return [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1];
}

+ (UIColor *)darkestBlue {
    return [UIColor colorWithRed:0.059 green:0.216 blue:0.314 alpha:1];
}

+ (UIColor *)customLightGray {
    return [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
}

+(UIColor *)customGreen {
    return [UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:1];
}

+(UIColor *)customDarkGray {
    return [UIColor colorWithRed:0.227 green:0.227 blue:0.227 alpha:1];
}

+(UIColor *)lightRed {
    return [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1];
}

@end
