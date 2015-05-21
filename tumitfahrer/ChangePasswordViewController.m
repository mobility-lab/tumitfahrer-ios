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
          [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Old Passwords don't match"];
        return;
    }
    if([oldpw length] < 6){
          [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Password needs to be at least 6 characters long"];
        return;
    }
    
    [ActionManager showAlertViewWithTitle:@"Success" description:@"Sobald der Server läuft wird dein PW geändert.."];
    [[self navigationController] popViewControllerAnimated:YES];
    
}
@end
