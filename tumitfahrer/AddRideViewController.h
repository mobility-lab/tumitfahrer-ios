//
//  AddRideViewController.h
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
#import "GAITrackedViewController.h"

@class Ride;

@interface AddRideViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

typedef enum {
    Passenger = 0,
    Driver = 1
} TableTypeEnum;

typedef enum {
    TestValue = 0,
    SecondValue,
    ThirdValue,
} AddRideTableValue;

typedef NS_ENUM(NSUInteger, CellName) {
    DRIVER_ROLE_ENUM = 0,
    DRIVER_DEPARTURE_ENUM,
    DRIVER_DESTINATION_ENUM,
    DRIVER_DEPARTURE_TIME_ENUM,
    DRIVER_REPEAT_ENUM,
    DRIVER_SEATS_ENUM,
    DRIVER_CAR_ENUM,
    DRIVER_MEETING_POINT_ENUM,
    DRIVER_RIDE_TYPE_ENUM,
};

-(NSString *)stringForName:(CellName)paramName;

@property (nonatomic, strong) Ride *potentialRequestedRide;
@property (nonatomic, assign) ShouldDisplayEnum displayEnum;
@property (nonatomic, assign) AddRideTableValue addRideTableValue;
@property (nonatomic, assign) TableTypeEnum TableType;
@property (nonatomic, assign) ContentType RideType;
@property (nonatomic, assign) DisplayType RideDisplayType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableValues;
@property BOOL shouldClose;

@end
