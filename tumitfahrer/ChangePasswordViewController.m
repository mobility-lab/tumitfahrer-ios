//
//  ChangePasswordViewController.m
//  tumitfahrer
//
//  Created by Daniel Böning on 21/05/15.
//  Copyright (c) 2015 Pawel Kwiecien. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ConnectionManager.h"
#import "ActionManager.h"
#import "CurrentUser.h"


@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"ChangePassword" owner:self options:nil] objectAtIndex:0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    NSLog(@"cancel");
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    [ConnectionManager serverIsOnline:YES];//Making sure we are connected

    //PW need 6 signs and they need to match
    NSString *np = self.changedPW.text;
    NSString *nprepeat = self.repeatChangedPW.text;
    NSString *oldpw = self.currentPW.text;
    
    if(![np isEqual:nprepeat]){
          [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"New Passwords don't match"];
        return;
    }
    if([np length] < 6){
          [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Password needs to be at least 6 characters long"];
        return;
    }
    
    //The old pw is checked via the authorization string
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [CurrentUser sharedInstance].user.email, oldpw];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding ];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    
    //
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_ADDRESS, API_CHANGE_PASSWORD]]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:[[NSString stringWithFormat:@"{\"password\":\"%@\"}",np] dataUsingEncoding:NSUTF8StringEncoding]];//[NSKeyedArchiver archivedDataWithRootObject:@{@"password":np}]];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse statusCode]==200){
        [ActionManager showAlertViewWithTitle:@"Success" description:@"Your password has been changed."];
        [[self navigationController] popViewControllerAnimated:YES];
    } else if ([httpResponse statusCode] == 400){
        [ActionManager showAlertViewWithTitle:@"Error" description:@"Your old password was incorrect."];
    } else {
        [ActionManager showAlertViewWithTitle:@"Failure" description:@"An error occured changing your password. Please try again later."];
    }
    NSLog(@"ChangePasswordViewController-didRecieveResponse: %ld",(long)[httpResponse statusCode]);
    NSLog(@"ChangePasswordViewController-didRecieveResponse: %@",response.debugDescription);
    NSLog(@"ChangePasswordViewController-didRecieveResponse: %@",response.description);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"ChangePasswordViewController-connectionDidFinishLoading");
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ChangePasswordViewController-Error: %@",error);
}
@end
