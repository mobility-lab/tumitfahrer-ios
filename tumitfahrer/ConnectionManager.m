//
//  ConnectionManager.m
//  tumitfahrer
//
//  Created by Daniel Böning on 19/05/15.
//  Copyright (c) 2015 Pawel Kwiecien. All rights reserved.
//

#import "ConnectionManager.h"
#import "ActionManager.h"

@implementation ConnectionManager

/*! @brief Tests whether there is an internet connection
    @param withAlert whether the user should be notfied via Alert
  */
+(BOOL) internetConnection:(BOOL)withAlert{
    BOOL ic = [self testInternetConnectionForURL:@"www.google.de"];
    if(ic){
        return true;
    } else if(withAlert){
        [ActionManager showAlertViewWithTitle:@"Error" description:@"No connection to the internet."];
        return false;
    } else {
        return false;
    }
}
/*!
  @brief Tests whether there is a connection to the Server&Internet. Better than the internetConnection methode.
   @param withAlert: Whether or not an alert should be presented to the user
 */
+(BOOL) serverIsOnline:(BOOL)withAlert {
    BOOL serverIsOnline = [self testInternetConnectionForURL:API_ADDRESS];
    if(serverIsOnline){
        return true;
    } else if(withAlert){
        if([self internetConnection:NO]){
           //We got internet, but the server is down
            [ActionManager showAlertViewWithTitle:@"Error" description:@"The server seems to be unavailable. Please try again later."];
        } else {
             [ActionManager showAlertViewWithTitle:@"Error" description:@"No connection to the internet."];
        }
    }
    return false;
}

+(BOOL) testInternetConnectionForURL:(NSString*) url{
    NSURL *scriptUrl = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        NSLog(@"Device is connected to the internet");
        return true;
    } else {
        NSLog(@"Device is not connected to the internet");
        return false;
    }
}



@end
