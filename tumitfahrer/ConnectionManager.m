//
//  ConnectionManager.m
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
