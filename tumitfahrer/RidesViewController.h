//
//  RidesViewController.h
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
#import "PanoramioUtilities.h"
#import "RidesStore.h"
#import "GAITrackedViewController.h"

@protocol RidesViewControllerDelegate

-(void)willAppearViewWithIndex:(NSInteger)index;

@end

@interface RidesViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate,  PanoramioUtilitiesDelegate, RideStoreDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<RidesViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, assign) ContentType RideType;


@end
