//
//  ConnectionManager.h
//  tumitfahrer
//
//  Created by Daniel Böning on 19/05/15.
//  Copyright (c) 2015 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionManager : NSObject

+(BOOL) internetConnection:(BOOL) withAlert;
+(BOOL) serverIsOnline:(BOOL) withAlert;
@end
