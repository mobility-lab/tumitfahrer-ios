//
//  MeetingPointViewController.m
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

#import "MeetingPointViewController.h"
#import "ActionManager.h"
#import "CustomBarButton.h"

@interface MeetingPointViewController ()

@end

@implementation MeetingPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
}

-(void)viewWillAppear:(BOOL)animated {
    self.textView.text = self.startText;
    [self.textView becomeFirstResponder];
}

-(void)setupNavbar {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor customLightGray];
    
    // right button of the navigation bar
    CustomBarButton *searchButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [searchButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)saveButtonPressed {
    [self.selectedValueDelegate didSelectValue:self.textView.text forIndexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
