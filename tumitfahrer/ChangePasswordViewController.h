//
//  ChangePasswordViewController.h
//  tumitfahrer
//
//  Created by Daniel Böning on 21/05/15.
//  Copyright (c) 2015 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <NSURLConnectionDataDelegate>
@property (strong, nonatomic) IBOutlet UIView *view;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonSave;
@property (strong, nonatomic) IBOutlet UITextField *repeatChangedPW;
@property (strong, nonatomic) IBOutlet UITextField *changedPW;
@property (strong, nonatomic) IBOutlet UITextField *currentPW;
@end
