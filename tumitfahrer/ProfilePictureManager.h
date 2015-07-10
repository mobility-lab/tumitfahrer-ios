//
//  ProfilePictureManager.h
//  tumitfahrer
//
//  Created by Daniel Böning on 28/06/15.
//  Copyright (c) 2015 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ProfilePictureManager : NSObject <NSURLConnectionDataDelegate>

-(void) uploadImage:(UIImage*)image;
-(void) downloadImagerForUser: (User*)user;

@end
