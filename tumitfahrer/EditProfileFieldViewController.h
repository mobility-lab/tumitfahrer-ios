//
//  EditProfileFieldViewController.h
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

@interface EditProfileFieldViewController : UIViewController <UITextViewDelegate, NSURLConnectionDataDelegate>

typedef enum {
    FirstName = 0,
    LastName = 1,
    Email = 2,
    Phone = 3,
    Car = 4,
    Password = 5,
    Department = 6
} UpdateField;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *initialDescription;
@property (assign, nonatomic) UpdateField updatedFiled;

@end
