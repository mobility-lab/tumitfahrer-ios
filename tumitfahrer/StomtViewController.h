//
//  StomtViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StomtViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
