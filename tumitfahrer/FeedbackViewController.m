//
//  FeedbackViewController.m
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

#import "FeedbackViewController.h"
#import "KGStatusBar.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface FeedbackViewController () <UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate>

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    self.contentTextView.delegate = self;
    self.titleTextField.delegate = self;
    if (iPhone5) {
        self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 120, 238, 38);
        self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 200);
    } else {
        self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 70);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Feedback view";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [self.titleTextField resignFirstResponder];
        [self.contentTextView becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(IBAction)sendButtonPressed:(id)sender {
    if (self.titleTextField.text.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No description" description:@"Please describe your feedback"];
        return;
    }
    
    NSString *urlString = [API_ADDRESS stringByAppendingString:[NSString stringWithFormat:@"/api/v3/feedback"]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:[CurrentUser sharedInstance].user.apiKey forHTTPHeaderField:@"Authorization"];
    NSString *postString = [NSString stringWithFormat:@"{\"title\":\"%@\", \"content\":\"%@\"}", self.titleTextField.text, self.contentTextView.text];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            NSLog(@"Could not send feedback");
        } else {
            NSLog(@"Feedback sent! %@", response);
        }}];
    
    [KGStatusBar showSuccessWithStatus:@"Message sent. Thank you!"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

@end
