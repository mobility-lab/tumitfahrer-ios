//
//  SimpleChatViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "Conversation.h"

@class User;

@interface SimpleChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) Conversation *conversation;
@property (strong, nonatomic) User *otherUser;

@end
