//
//  CustomRepeatViewController.h
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

#import <UIKit/UIKit.h>

@protocol CustomRepeatViewController <NSObject>

- (void)didSelectRepeatDates:(NSArray *)repeatDates descriptionLabel:(NSString *)descriptionLabel selectedValues:(NSMutableDictionary *)selectedValues;

@end

@interface CustomRepeatViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) id<CustomRepeatViewController> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *repeatDailySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *repeatWeeklySwitch;
@property (weak, nonatomic) IBOutlet UIStepper *dayStepper;
@property (weak, nonatomic) IBOutlet UILabel *everyDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;

- (IBAction)dayStepperChanged:(id)sender;
- (IBAction)repeatDailySwitchChanged:(id)sender;
- (IBAction)repeatWeeklySwitchChanged:(id)sender;
- (IBAction)fromButtonPressed:(id)sender;
- (IBAction)toButtonPressed:(id)sender;

@end
