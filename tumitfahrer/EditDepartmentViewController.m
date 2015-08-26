//
//  EditRepartmentViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "EditDepartmentViewController.h"
#import "FacultyManager.h"
#import "NavigationBarUtilities.h"
#import "CustomBarButton.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface EditDepartmentViewController ()

@property NSUInteger chosenFaculty;

@end

@implementation EditDepartmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.chosenFaculty = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor customLightGray];
    [self.pickerView selectRow:[[CurrentUser sharedInstance].user.department intValue] inComponent:0 animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    
    // right button of the navigation bar
    CustomBarButton *rightBarButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[FacultyManager sharedInstance] allFaculties].count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosenFaculty = row;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[FacultyManager sharedInstance] nameOfFacultyAtIndex:row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50.0f;
}

-(void)rightBarButtonPressed {
    User *user = [CurrentUser sharedInstance].user;
    NSString  *body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, [NSNumber numberWithInt:(int)self.chosenFaculty], user.firstName, user.lastName, user.phoneNumber];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/users/%@",API_ADDRESS, [CurrentUser sharedInstance].user.userId]]];
    user.department = [NSNumber numberWithInt:(int) self.chosenFaculty];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:[CurrentUser sharedInstance].user.apiKey  forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];//[NSKeyedArchiver archivedDataWithRootObject:@{@"password":np}]];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
    
    
//    RKObjectManager *objectManager = [RKObjectManager sharedManager];
//     objectManager.requestSerializationMIMEType = RKMIMETypeJSON ;
////    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[ActionManager encryptCredentialsWithEmail:[CurrentUser sharedInstance].user.email encryptedPassword:[CurrentUser sharedInstance].user.password]];
//    
//
//    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CurrentUser sharedInstance].user.car, @"car",[CurrentUser sharedInstance].user.phoneNumber, @"phone_number", [CurrentUser sharedInstance].user.firstName,@"first_name" , [CurrentUser sharedInstance].user.lastName,  @"last_name",  [CurrentUser sharedInstance].user.department,@"department", nil];
//    
//    NSDictionary *userParams = @{@"user": queryParams};
//    NSNumber *facultyNumber =[NSNumber numberWithInt:(int)self.chosenFaculty];
//    [queryParams setValue:facultyNumber forKey:@"department"];
//
//    [objectManager putObject:nil path:[NSString stringWithFormat:@"/api/v3/users/%@", [CurrentUser sharedInstance].user.userId] parameters:userParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        [CurrentUser sharedInstance].user.department = facultyNumber;
//        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"Updated user deparment.");
//        NSError *error;
//        if (![[CurrentUser sharedInstance].user.managedObjectContext saveToPersistentStore:&error]) {
//            NSLog(@"Whoops. Could not save edited values for user profile.");
//        }
//        
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        RKLogError(@"Load failed with error: %@", error);
//    }];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse statusCode]==200){
        [ActionManager showAlertViewWithTitle:@"Success" description:@"Your department has been changed."];
        [[self navigationController] popViewControllerAnimated:YES];
        [CurrentUser saveUserToPersistentStore:[CurrentUser sharedInstance].user];
    } else {
        [ActionManager showAlertViewWithTitle:@"Failure" description:@"An error occured changing your department. Please try again later."];
    }
    NSLog(@"EditDepartment-didRecieveResponse: %ld",(long)[httpResponse statusCode]);
    NSLog(@"EditDepartment-didRecieveResponse: %@",response.debugDescription);
    NSLog(@"EditDepartment-didRecieveResponse: %@",response.description);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"EditDepartment-connectionDidFinishLoading");
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"EditDepartment-Error: %@",error);
}
@end
