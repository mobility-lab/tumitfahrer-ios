//
//  NavigationBarUtilities.m
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

#import "NavigationBarUtilities.h"
#import "ActionManager.h"

@implementation NavigationBarUtilities

+(void)setupNavbar:(UINavigationController **)navigationController withColor:(UIColor *)color{
    [(*navigationController).navigationBar setBarTintColor:color];
    (*navigationController).navigationBar.tintColor = [UIColor whiteColor];
    (*navigationController).navigationBar.translucent = NO;
    (*navigationController).navigationBarHidden = NO;
    (*navigationController).navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

@end
