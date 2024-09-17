//
//  PhotoDetailsViewController.m
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

#import "PhotoDetailsViewController.h"
#import "NavigationBarUtilities.h"
#import "Photo.h"
#import "ActionManager.h"

@interface PhotoDetailsViewController ()

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customLightGray];
    
    self.photoImageView.image = self.photo;
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self setupLabels];
}

-(void)setupLabels {
    if (self.photoInfo.photoTitle.length == 0) {
        self.titleLabel.text = @"Unknown";
    } else {
        self.titleLabel.text = self.photoInfo.photoTitle;
    }
    if (self.photoInfo.ownerName.length == 0) {
        self.authorLabel.text = @"Unknown";
    } else {
        self.authorLabel.text = self.photoInfo.ownerName;
    }
    if (self.photoInfo.uploadDate.length == 0) {
        self.dateLabel.text = @"Unknown";
    } else {
        self.dateLabel.text = self.photoInfo.uploadDate;
    }
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkerBlue]];
}

- (IBAction)linkButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.photoInfo.photoUrl]];
}
@end
