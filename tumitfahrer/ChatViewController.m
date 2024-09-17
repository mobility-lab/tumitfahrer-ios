//
//  ChatControllerViewController.m
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

#import "ChatViewController.h"
#import "JSMessage.h"
#import "ActionManager.h"
#import "Message.h"
#import "User.h"
#import "CurrentUser.h"

@interface ChatViewController ()

@property (nonatomic, strong) User *receiver;

@end

@implementation ChatViewController {
    SRWebSocket *_webSocket;
}

- (void)viewDidLoad
{
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    
    self.title = @"Messages";
    self.messageInputView.textView.placeHolder = @"New Message";
    
    //    self.avatars = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                    [JSAvatarImageFactory avatarImageNamed:@"futureAvatar1" croppedToCircle:YES], kSubtitleMe,
    //                    [JSAvatarImageFactory avatarImageNamed:@"futureAvatar2" croppedToCircle:YES], kSubtitleDriver,nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:NO];
    [self setupNavbar];
    //[self _reconnect];
}

-(void)setupNavbar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor darkerBlue]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    if (self.conversation == nil) {
        self.title = @"Message to all";
    } else {
        self.title = @"Messages";
    }
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.conversation.messages count];
}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    if ((self.conversation.messages.count - 1) % 2) {
        [JSMessageSoundEffect playMessageSentSound];
    }
    else {
        // for demo purposes only, mimicing received messages
        [JSMessageSoundEffect playMessageReceivedSound];
    }
    
    //    [self.conversation.messages addObject:[[JSMessage alloc] initWithText:text sender:sender date:date]];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleLightGrayColor]];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_bubbleBlueColor]];
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages view delegate: OPTIONAL

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 3 == 0) {
        return YES;
    }
    return NO;
}

//
//  *** Implement to customize cell further
//
- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
        
        if ([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)]) {
            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
            [attrs setValue:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
            
            cell.bubbleView.textView.linkTextAttributes = attrs;
        }
    }
    
    if (cell.timestampLabel) {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if (cell.subtitleLabel) {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
    
#if TARGET_IPHONE_SIMULATOR
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeNone;
#else
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeAll;
#endif
}

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
//  - (UIButton *)sendButtonForInputView
//

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

// *** Implemnt to enable/disable pan/tap todismiss keyboard
//
- (BOOL)allowsPanToDismissKeyboard {
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [[self.conversation.messages allObjects ]objectAtIndex:indexPath.row];
    JSMessage *jsMessage = [[JSMessage alloc] initWithText:message.content sender:[CurrentUser sharedInstance].user.firstName date:message.createdAt];
    
    return jsMessage ;
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender
{
    UIImage *image = [self.avatars objectForKey:sender];
    return [[UIImageView alloc] initWithImage:image];
}

# pragma mark - websocket - for complete implementation see SocketRocket demo

- (void)_reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.0.102:9000/chat"]]];
    _webSocket.delegate = self;
    
    self.title = @"Opening Connection...";
    [_webSocket open];
}

- (void)reconnect:(id)sender;
{
    [self _reconnect];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    self.title = @"Connected!";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
    //[_messages addObject:[[TCMessage alloc] initWithMessage:message fromMe:NO]];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.conversation.messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
}


@end