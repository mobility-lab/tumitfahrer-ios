//
//  EditRideViewController.m
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

#import "EditRideViewController.h"
#import "CustomBarButton.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "ActionManager.h"
#import "LocationController.h"
#import "RidesStore.h"
#import "NavigationBarUtilities.h"
#import "MMDrawerBarButtonItem.h"
#import "SearchRideViewController.h"
#import "SegmentedControlCell.h"
#import "OwnerOfferViewController.h"
#import "LocationController.h"
#import "Ride.h"
#import "HeaderContentView.h"
#import "ActivityStore.h"
#import "MeetingPointViewController.h"
#import "DestinationViewController.h"
#import "FreeSeatsTableViewCell.h"
#import "RMDateSelectionViewController.h"

@interface EditRideViewController () <SegmentedControlCellDelegate, DestinationViewControllerDelegate, FreeSeatsCellDelegate, RMDateSelectionViewControllerDelegate, MeetingPointDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D departureCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D destinationCoordinate;
@property (nonatomic, strong) NSMutableArray *tableDriverValues;
@property (nonatomic, strong) NSMutableArray *tablePlaceholders;
@property (nonatomic, strong) NSMutableArray *tableValues;
@property (nonatomic, assign) ContentType RideType;
@property (nonatomic, strong) CustomBarButton *saveButton;
@property (nonatomic, strong) NSMutableDictionary *selectedRepeatValues;
@property (nonatomic, strong) NSArray *repeatDates;

@end

@implementation EditRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableValues = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"1", @"", @"", @"", nil];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTables];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor customLightGray];
    self.RideType = ContentTypeCampusRides;
}

-(void)initTables {
    
    NSString *car = @"";
    if (self.ride.car != nil) {
        car = self.ride.car;
    } else if (self.ride.rideOwner != nil && self.ride.rideOwner.car != nil) {
        car = self.ride.rideOwner.car;
    }

    NSString *meetingPoint = @"";
    if (self.ride.meetingPoint != nil) {
        meetingPoint = self.ride.meetingPoint;
    }
    NSString *isRegularRide = @"No";
    if(self.ride.regularRideId != nil) {
        isRegularRide = @"Yes";
    }
    
    self.tableValues = [[NSMutableArray alloc] initWithObjects:self.ride.departurePlace, self.ride.destination, [ActionManager stringFromDate:self.ride.departureTime], isRegularRide, [self.ride.freeSeats stringValue], car, meetingPoint, @"", nil];
    self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"Departure", @"Destination", @"Time", @"Repeat", @"Free Seats", @"Car", @"Meeting Point", @"", nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Edit ride screen";
    [self.tableView reloadData];
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    
    // right button of the navigation bar
    self.saveButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [self.saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchDown];
    self.saveButton.enabled = YES;
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    self.title = @"Edit ride";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tablePlaceholders count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"GeneralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    if(indexPath.row == 4) {
        FreeSeatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeSeatsTableViewCell"];
        
        if(cell == nil){
            cell = [FreeSeatsTableViewCell freeSeatsTableViewCell];
        }
        
        cell.stepper.value = [self.ride.freeSeats intValue];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.stepperLabelText.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
        cell.passengersCountLabel.text = [self.tableValues objectAtIndex:indexPath.row];
        return  cell;
    } else if(indexPath.row == [self.tableValues count]-1) {
        SegmentedControlCell *cell = [SegmentedControlCell segmentedControlCell];
        [cell setFirstSegmentTitle:@"Campus" secondSementTitle:@"Activity"];
        cell.segmentedControl.selectedSegmentIndex = self.RideType;
        cell.delegate = self;
        [cell addHandlerToSegmentedControl];
        cell.controlId = 1;
        return cell;
    }
    
    if (indexPath.row < [self.tableValues count] && [self.tableValues objectAtIndex:indexPath.row] != nil) {
        cell.detailTextLabel.text = [self.tableValues objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    }
    cell.textLabel.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
    if (indexPath.row == 3) { // don't show accessory for repeat
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if ([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Meeting Point"] || [[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Car"]) {
            MeetingPointViewController *meetingPointVC = [[MeetingPointViewController alloc] init];
            meetingPointVC.selectedValueDelegate = self;
            meetingPointVC.indexPath = indexPath;
            meetingPointVC.title = [self.tableValues objectAtIndex:indexPath.row];
            meetingPointVC.startText = [self.tableValues objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:meetingPointVC animated:YES];
        }
        else if (([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Destination"]) || [[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Departure"]) {
            DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
            destinationVC.delegate = self;
            destinationVC.rideTableIndexPath = indexPath;
            [self.navigationController pushViewController:destinationVC animated:YES];
        } else if([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Time"]) {
            RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
            dateSelectionVC.delegate = self;
            [dateSelectionVC show];
        }
    }
}

-(void)saveButtonPressed {
    
    self.saveButton.enabled = NO;
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    NSString *departurePlace = [self.tableValues objectAtIndex:0];
    NSString *destination = [self.tableValues objectAtIndex:1];
    NSString *departureTime = [self.tableValues objectAtIndex:2];
    
    if (!departurePlace || departurePlace.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No departure time" description:@"To add a ride please specify the departure place"];
        self.saveButton.enabled = YES;
        return;
    } else if(!destination || destination.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No destination" description:@"To add a ride please specify the destination"];
        self.saveButton.enabled = YES;
        return;
    } else if(!departureTime || departureTime.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No departure time" description:@"To add a ride please specify the departure time"];
        self.saveButton.enabled = YES;
        return;
    }
    
    NSNumber *departureLatitude = nil, *departureLongitude = nil, *destinationLatitude = nil, *destinationLongitude = nil;
    if (self.departureCoordinate.latitude != 0) {
        departureLatitude = [NSNumber numberWithDouble:self.departureCoordinate.latitude];
        departureLongitude = [NSNumber numberWithDouble:self.departureCoordinate.longitude];
    } else {
        departureLatitude = self.ride.departureLatitude;
        departureLongitude = self.ride.departureLongitude;
    }
    if(self.destinationCoordinate.latitude != 0) {
        destinationLatitude = [NSNumber numberWithDouble:self.destinationCoordinate.latitude];
        destinationLongitude = [NSNumber numberWithDouble:self.destinationCoordinate.longitude];
    } else {
        destinationLatitude = self.ride.destinationLatitude;
        destinationLongitude = self.ride.destinationLongitude;
    }
    
    BOOL isNearby = [LocationController isLocation:[[CLLocation alloc] initWithLatitude:[departureLatitude doubleValue] longitude:[departureLongitude doubleValue]] nearbyAnotherLocation:[[CLLocation alloc] initWithLatitude:[destinationLatitude doubleValue] longitude:[destinationLongitude doubleValue]] thresholdInMeters:1000];
    if (isNearby) {
        [ActionManager showAlertViewWithTitle:@"Problem" description:@"The route is too short"];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
    NSDate *dateString = [formatter dateFromString:departureTime];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];//'T'
    NSString *time = [formatter stringFromDate:dateString];
    
    if ([dateString compare:[NSDate date]] == NSOrderedAscending) {
        [ActionManager showAlertViewWithTitle:@"Problem" description:@"You can't add ride in the past"];
        return;
    }
    
    NSDictionary *rideParams = nil;
    
    NSString *freeSeats = [self.tableValues objectAtIndex:4];
    if (freeSeats == nil || freeSeats.length == 0) {
        freeSeats = @"1";
    }
    
    NSString *car = [self.tableValues objectAtIndex:5];
    if (car.length == 0 && [CurrentUser sharedInstance].user.car != nil) {
        car = [CurrentUser sharedInstance].user.car;
    }
    
    NSString *meetingPoint = [self.tableValues objectAtIndex:6];
    if (meetingPoint == nil) {
        [ActionManager showAlertViewWithTitle:@"No meeting place" description:@"To add a ride please specify the meeting place"];
        return;
    }
    
    queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": time, @"free_seats": freeSeats, @"meeting_point": meetingPoint, @"ride_type": [NSNumber numberWithInt:self.RideType], @"car": car, @"departure_latitude": departureLatitude, @"departure_longitude" : departureLongitude, @"destination_latitude" : destinationLatitude, @"destination_longitude" : destinationLongitude};
    rideParams = @{@"ride": queryParams};
    
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"apiKey" value:[[CurrentUser sharedInstance] user].apiKey];
    
    [objectManager putObject:self.ride path:[NSString stringWithFormat:@"/api/v3/users/%@/rides/%@", [CurrentUser sharedInstance].user.userId, self.ride.rideId] parameters:rideParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        // put return no content (according to HTTP spec), so to update a ride we need to do another get request or update params manually
        self.ride.departurePlace = departurePlace;
        self.ride.destination = destination;
        self.ride.departureTime = [ActionManager dateFromString:departureTime];
        self.ride.departureLatitude = departureLatitude;
        self.ride.departureLongitude = departureLongitude;
        self.ride.destinationLatitude = destinationLatitude;
        self.ride.destinationLongitude = destinationLongitude;
        [[RidesStore sharedStore] fetchImageForCurrentRide:self.ride];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * freeSeatsNumber = [f numberFromString:freeSeats];
        
        self.ride.car = car;
        self.ride.freeSeats = freeSeatsNumber;
        self.ride.meetingPoint = meetingPoint;
        [[RidesStore sharedStore] saveToPersistentStore:self.ride];
        self.tableDriverValues = nil;
        [[ActivityStore sharedStore] updateActivities];
        
        OwnerOfferViewController *rideDetailVC = (OwnerOfferViewController*)self.presentingViewController;
        rideDetailVC.ride = self.ride;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        self.saveButton.enabled = YES;
        [ActionManager showAlertViewWithTitle:@"Could not update" description:@"There was an error while updating your ride"];
        RKLogError(@"Load failed with error: %@", error);
    }];
}


#pragma mark - RMDateSelectionViewController Delegates

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateString = [ActionManager stringFromDate:aDate];
    [self.tableValues replaceObjectAtIndex:2 withObject:dateString];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    
}

-(void)didSelectValue:(NSString *)value forIndexPath:(NSIndexPath *)indexPath {
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:value];
}

-(void)selectedDestination:(NSString *)destination coordinate:(CLLocationCoordinate2D)coordinate indexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
            self.departureCoordinate = coordinate;
    } else if (indexPath.row == 1){
            self.destinationCoordinate = coordinate;
    }
    
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:destination];
    
}

-(void)stepperValueChanged:(NSInteger)stepperValue {
    [self.tableValues replaceObjectAtIndex:4 withObject:[[NSNumber numberWithInt:(int)stepperValue] stringValue]];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    ;
}

-(void)segmentedControlChangedToIndex:(NSInteger)index segmentedControlId:(NSInteger)controlId{
    if(controlId == 1) { //ride type
        if (index == 0) {
            self.RideType = ContentTypeCampusRides;
        } else {
            self.RideType = ContentTypeActivityRides;
        }
    }
}

-(void)didSelectRepeatDates:(NSArray *)repeatDates descriptionLabel:(NSString *)descriptionLabel selectedValues:(NSMutableDictionary *)selectedValues {
    self.selectedRepeatValues = selectedValues;
    self.repeatDates = repeatDates;
    if (repeatDates.count > 0) {
        [self.tableValues replaceObjectAtIndex:4 withObject:descriptionLabel];
    } else {
        [self.tableValues replaceObjectAtIndex:4 withObject:@"No"];
    }
}

@end
