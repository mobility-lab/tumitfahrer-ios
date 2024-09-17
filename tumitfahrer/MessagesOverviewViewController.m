//
//  MessagesOverviewViewController.m
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

#import "MessagesOverviewViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "NavigationBarUtilities.h"
#import "ChatViewController.h"
#import "MessageListCell.h"
#import "WebserviceRequest.h"
#import "Conversation.h"
#import "CurrentUser.h"
#import "User.h"
#import "Message.h"
#import "ActionManager.h"
#import "SimpleChatViewController.h"

@interface MessagesOverviewViewController ()

@property (nonatomic, strong) NSMutableArray *conversations;

@end

@implementation MessagesOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (self.conversations == nil || self.conversations.count == 0) {
        [self fetchConversations];
    }
    
    [self setupNavigationBar];
}

-(void)fetchConversations {
    [WebserviceRequest getConversationsForRideId:[self.ride.rideId intValue] block:^(BOOL fetched) {
        if (fetched) {
            [self reloadTable];
        }
    }];
}

-(void)reloadTable {
    self.conversations = [NSMutableArray arrayWithArray:[self.ride.conversations allObjects]];
    [self.tableView reloadData];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkerBlue]];
    self.title = @"Messages Overview";
    
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    [self.navigationItem setRightBarButtonItem:refreshButtonItem];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conversations count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListCell"];
    
    if(cell == nil)
    {
        cell = [MessageListCell messageListCell];
    }
    Conversation *conversation = [self.conversations objectAtIndex:indexPath.section];
    NSNumber *otherUserId = nil;
    if ([conversation.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        otherUserId = conversation.otherUserId;
    } else {
        otherUserId = conversation.userId;
    }
    User *otherUser = [CurrentUser fetchFromCoreDataUserWithId:otherUserId];
    cell.passengerNameLabel.text = [NSString stringWithFormat:@"%@ %@", otherUser.firstName, otherUser.lastName] ;
    
    Message *lastMesage = [[conversation.messages allObjects] lastObject];
    cell.lastMessageLabel.text = lastMesage.content;
    cell.lastMessageDateLabel.text = [ActionManager dateStringFromDate:lastMesage.createdAt];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*ChatViewController *chatVC = [[ChatViewController alloc] init];
    Conversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    chatVC.conversation = conversation;
    [self.navigationController pushViewController:chatVC animated:YES];
    */
    SimpleChatViewController *chatVC = [[SimpleChatViewController alloc] init];
    Conversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    chatVC.conversation = conversation;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (IBAction)contactAllPassengersButtonPressed:(id)sender {
    /*ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
     */
    SimpleChatViewController *chatVC = [[SimpleChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];

}

-(void)refreshButtonPressed {
    [self fetchConversations];
}

@end
