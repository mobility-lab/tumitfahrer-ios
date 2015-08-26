//
//  EditProfileFieldViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/12/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "EditProfileFieldViewController.h"
#import "CustomBarButton.h"
#import "NavigationBarUtilities.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface EditProfileFieldViewController ()

@property (nonatomic, strong) NSString *passwordString;

@end

@implementation EditProfileFieldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    self.textView.delegate = self;
    self.passwordString = @"";
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.updatedFiled == Password) {
        self.textView.text = self.initialDescription = @"";
        [self.textView setSecureTextEntry:YES];
    } else {
        self.textView.text = self.initialDescription;
    }
    [self.textView becomeFirstResponder];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lightestBlue]];
    
    // right button of the navigation bar
    CustomBarButton *rightBarButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightBarButtonPressed {
    if (self.textView.text.length == 0) {
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Before saving changes, please fill in the text view"];
    } else if(self.updatedFiled == Password && self.textView.text.length < 6) {
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Password needs to be at least 6 characters long"];
    }
    
//    RKObjectManager *objectManager = [RKObjectManager sharedManager];
//    objectManager.requestSerializationMIMEType = RKMIMETypeJSON ;
//    [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:[CurrentUser sharedInstance].user.apiKey];
//    

//    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys
//: [CurrentUser sharedInstance].user.car, @"car",[CurrentUser sharedInstance].user.phoneNumber, @"phone_number", [CurrentUser sharedInstance].user.firstName,@"first_name" , [CurrentUser sharedInstance].user.lastName,  @"last_name",  [CurrentUser sharedInstance].user.department,@"department", nil];
    
    NSString *trimmedString = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *escapedString = [trimmedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [queryParams setValue:[CurrentUser sharedInstance].user.firstName forKey:@"first_name"];
//    [queryParams setValue:[CurrentUser sharedInstance].user.lastName forKey:@"last_name"];
//    [queryParams setValue:[CurrentUser sharedInstance].user.phoneNumber forKey:@"phone_number"];
//    [queryParams setValue:[CurrentUser sharedInstance].user.car forKey:@"car"];
//    [queryParams setValue:[CurrentUser sharedInstance].user.department forKey:@"department"];
    
    // add enum
    NSString *body;
    User *user = [CurrentUser sharedInstance].user;
    switch (self.updatedFiled) {
        case FirstName:
            body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, user.department, escapedString, user.lastName, user.phoneNumber];
            user.firstName = trimmedString;
            break;
        case LastName:
            body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, user.department, user.firstName, escapedString, user.phoneNumber];
                user.lastName = trimmedString;
            break;
        case Phone:
            body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, user.department, user.firstName, user.lastName, escapedString];
            user.phoneNumber = trimmedString;
            break;
        case Car:
           body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",escapedString, user.department, user.firstName, user.lastName, user.phoneNumber];
            user.car = trimmedString;
            break;
        case Department:
            body = [NSString stringWithFormat:@"{\"user\": {\"car\":\"%@\", \"department\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"phone_number\":\"%@\"}}",user.car, escapedString, user.firstName, user.lastName, user.phoneNumber];
            user.car = trimmedString;
            break;
        default:
            break;
    }
    
    
    //
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/users/%@",API_ADDRESS, [CurrentUser sharedInstance].user.userId]]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[CurrentUser sharedInstance].user.apiKey  forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];//[NSKeyedArchiver archivedDataWithRootObject:@{@"password":np}]];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
    
    
//    [objectManager putObject:nil path:[NSString stringWithFormat:@"/api/v3/users/%@", [CurrentUser sharedInstance].user.userId] parameters:userParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    
//        NSLog(@"<y< PAASt");
//        [self.navigationController popViewControllerAnimated:YES];
//
//        NSError *error;
//        if (![[CurrentUser sharedInstance].user.managedObjectContext saveToPersistentStore:&error]) {
//            [ActionManager showAlertViewWithTitle:@"Error" description:@"Could not save edited values for user profile."];
//            NSLog(@"Whoops. Could not save edited values for user profile.");
//        }
//        
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        
//        RKLogError(@"Load failed with error: %@", error);
//    }];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse statusCode]==200){
        [CurrentUser saveUserToPersistentStore: [CurrentUser sharedInstance].user];
        [ActionManager showAlertViewWithTitle:@"Success" description:@"Your data has been changed."];
        [[self navigationController] popViewControllerAnimated:YES];
    } else {
        [ActionManager showAlertViewWithTitle:@"Failure" description:@"An error occured changing your data. Please try again later."];
    }
    NSLog(@"EditProfileField-didRecieveResponse: %ld",(long)[httpResponse statusCode]);
    NSLog(@"EditProfileField-didRecieveResponse: %@",response.debugDescription);
    NSLog(@"EditProfileField-didRecieveResponse: %@",response.description);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"EditProfileField-connectionDidFinishLoading");
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"EditProfileField-Error: %@",error);
}


-(void)textViewDidChange:(UITextView *)textView {
    
    if (self.updatedFiled == Password) {
        if (self.textView.text.length > self.passwordString.length) {
            self.passwordString = [self.passwordString stringByAppendingFormat:@"%c",[self.textView.text characterAtIndex:(self.textView.text.length-1)]];
            self.textView.text = [self.textView.text stringByReplacingCharactersInRange:NSMakeRange(self.textView.text.length-1,1) withString:@"●"];
        } else if(self.textView.text.length < self.passwordString.length && self.passwordString.length > 0) {
            self.passwordString = [self.passwordString stringByReplacingCharactersInRange:NSMakeRange(self.passwordString.length-1,1) withString:@""];
        }
    }
}

-(void)dealloc {
    self.textView.delegate = nil;
}
    
@end
