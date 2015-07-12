//
//  ProfilePictureManager.m
//  tumitfahrer
//
//  Created by Daniel Böning on 28/06/15.
//  Copyright (c) 2015 Pawel Kwiecien. All rights reserved.
//

#import "ProfilePictureManager.h"
#import "CurrentUser.h"
#import "ActionManager.h"

@implementation ProfilePictureManager

-(void) uploadImage:(UIImage*)image{
    
    NSMutableData *body1 = [NSMutableData data];
    // add image data
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        [body1 appendData:imageData];
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/users/%@/avatar",API_ADDRESS, [CurrentUser sharedInstance].user.userId]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[CurrentUser sharedInstance].user.apiKey forHTTPHeaderField:@"Authorization"];

    NSString *boundary = @"14737809831466499882746641449";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadImage\";\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
   
    
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    NSLog(@"ProfilePictureManager connection started. %@", request);

}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse statusCode]==200){
        [ActionManager showAlertViewWithTitle:@"Success" description:@"Your profile picture has been changed"];
    } else {
        [ActionManager showAlertViewWithTitle:@"Failure" description:@"An error occured changing your profile picture. Please try again later."];
    }
    NSLog(@"ProfilePictureManager-didRecieveResponse: %@",response);
    NSLog(@"ProfilePictureManager-didRecieveResponse: %@",response.debugDescription);
        NSLog(@"ProfilePictureManager-didRecieveResponse: %@",response.description);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"ProfilePictureManager-connectionDidFinishLoading");
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ProfilePictureManager-Error: %@",error);
}

@end
