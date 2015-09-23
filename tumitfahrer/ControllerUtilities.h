//
//  ControllerUtilities.h
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

#import <Foundation/Foundation.h>

@class Ride;

/**
 *  Class with utilitie function for view controllers.
 */
@interface ControllerUtilities : NSObject

/**
 *  Returns a right type of ride detail view controller for a ride.
 *
 *  @param ride The Ride object.
 *
 *  @return View controller
 */
+(UIViewController *)viewControllerForRide:(Ride *)ride;

/**
 *  Prepares an intro view that can by displayed anywhere in a view controller.
 *
 *  @param view The current view.
 *
 *  @return UIView with intro pages.
 */
+(UIView *)prepareIntroForView:(UIView *)view;

@end
