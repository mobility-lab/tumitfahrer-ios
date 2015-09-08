//
//  TeamViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamMemberCell.h"
#import "CircularImageView.h"
#import "ActionManager.h"

@interface TeamViewController () <UITextViewDelegate>

@property (nonatomic, strong) NSArray *teamPhotos;
@property (nonatomic, strong) NSArray *shortAboutArray;
@property (nonatomic, strong) NSArray *longAboutArray;

@end

@implementation TeamViewController

NSMutableArray * currentTeam, *lastTeam;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self requestTeamDataForTeam:@"SS15"];
    [self requestTeamDataForTeam:@"SS14"];
    if (self) {
        self.teamPhotos = [NSArray arrayWithObjects:[UIImage imageNamed:@"PawelPhoto.jpg"], [UIImage imageNamed:@"MichaelPhoto.jpg"], [UIImage imageNamed:@"LukasPhoto.jpg"], [UIImage imageNamed:@"BehrozPhoto.jpg"], [UIImage imageNamed:@"SaqibPhoto.jpg"], [UIImage imageNamed:@"AnuradaPhoto.jpg"], [UIImage imageNamed:@"ShahidPhoto.jpg"], [UIImage imageNamed:@"AbiPhoto.jpg"], [UIImage imageNamed:@"AmrPhoto.jpg"], [UIImage imageNamed:@"DansenPhoto.jpg"], nil];
        self.shortAboutArray = [NSArray arrayWithObjects:@"Pawel Kwiecien\nRole: Main developer of iOS app\nMotto: Life begins at the end of your comfort zone.",@"Michael Schermann\nRole:  Creative director\nMotto: When in danger, when in doubt, run in circles, scream, and shout.",@"Lukasz Kwiatkowski\nRole: UI/UX Designer, Photography, Marketing\nMotto: Creativity is doing something out of nothing", @"Behroz Sikander\nRole: Backend / VisioM developer\nAfter this project, I like Ruby more than Natalie Portman ;)",@"Hafiz Saqib Javed\nRole: Notification Engine/Pebble smartwatch developer",@"Anuradha Ganapathi\nRole: Web application developer\nMotto: Ruby is better than diamond.",@"Muhammad Shahid Aslam\nRole: Backend and Web application Developer\nMotto: Failure is not an option, it comes bundled with the software.",@"Abhijith Srivatsav\nRole: Android Developer\nMotto: There is no spoon.",@"Amr Arafat\nRole: Android Developer\nMotto: It’s not a Bug, It’s a feature *evil smile*", @"Dansen Zhou\nRole:  iOS, Android, Web application tester", nil];
        self.longAboutArray = [NSArray arrayWithObjects:@"TUMitfahrer was for me the final project for my Master Thesis. I developed complete iOS application and backend using Ruby on Rails. My research included innovative product development processes.", @"TUMitfahrer is an awesome project because the teams grew together on an innovative project. TUMitfahrer enabled the students to pursue their ideas while fulfilling their study requirements.",@"I took this project as my IDP. Personally i enjoyed that project because i could use my slightly artistic background in real application, to design something which students could enjoy.", @"TUMitfahrer was an awesome project that gave me the chance to work on multiple platforms. I learnt ROR, Android, iPhone, Java and C++ in a single project.",@"Getting an opportunity to work on a real time project with collaborative environment and multiple technologies, couldn’t get anything better. I took it as an IDP and really enjoyed working on Pebble and RoR.",@"I took this project as my IDP and it is an awesome experience and opportunity to learn new language like Ruby on Rails.", @"I took this project as IDP. I learned new things like how to use websockets for chat and how to develop responsive web application.",@"TUMitfahrer is my IDP, for which I’m responsible for the Android application. I’m the resident Android evangelist and the go-to guy for everything Android. The project gives me an opportunity to exercise my skills and experiment with app building techniques.", @"TUMitfahrer is an exciting project.  I learned a lot of stuff and had a lot of fun. I was on the Android team and I really enjoyed working on the project.",@"I took this project as my IDP. In this awesome project, I take charge of all the tests including unit test, ui automatic test, integration test, etc. It is both excited and painful to join all the different platforms with different environments, different programme languages.",  nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customLightGray];
    
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TeamHeaderView" owner:self options:nil] objectAtIndex:0];
    self.tableView.tableHeaderView = headerView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Team screen";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return [currentTeam count];
    } else {
        return [lastTeam count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return @"SS15";
    } else {
        return @"SS14";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    if (!cell) {
        cell = [TeamMemberCell teamMemberCell];
    }
    NSDictionary *member;
    if(indexPath.section==0){
        member = [currentTeam objectAtIndex:indexPath.row];
    } else {
        member = [lastTeam objectAtIndex:indexPath.row];
    }
    
    
    CircularImageView *circularImageView = nil;
    UITextView *shortTextView = nil;
    NSString *avatarString =[member objectForKey:@"avatar"];
    UIImage *image = [UIImage imageNamed:@"dummy.jpeg"];
    if(![avatarString isEqual:[NSNull null]] && ![avatarString isEqualToString:@"<null>"]){
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:avatarString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        image = [[UIImage alloc] initWithData:imageData];
        NSLog(@"image: %@", image);
    }
    UITextView *longTextView;
    if (indexPath.row % 2 == 1) {
        circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 120) image:image];
        shortTextView = [[UITextView alloc]initWithFrame:CGRectMake(140, 10, [UIScreen mainScreen].bounds.size.width - 150, 70)];
        longTextView = [[UITextView alloc]initWithFrame:CGRectMake(140, 30, [UIScreen mainScreen].bounds.size.width - 150, 70)];
    } else {
        circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 10, 120, 120) image:image];
        shortTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 150, 70)];
        if([[member objectForKey:@"name"] isEqualToString:@"Konstantinos Angelopoulos"]){
            longTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 50, [UIScreen mainScreen].bounds.size.width - 150, 70)];
        } else {
            longTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width - 150, 70)];
        }
    }
    
    
    shortTextView.editable = NO;
    shortTextView.selectable = NO;
    shortTextView.backgroundColor = [UIColor clearColor];
    shortTextView.text = [member objectForKey:@"name"];
    shortTextView.font = [UIFont systemFontOfSize:14];
    
    shortTextView.scrollEnabled = NO;
    
//    UITextView *longTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 130, [UIScreen mainScreen].bounds.size.width - 10, 120)];
    longTextView.editable = NO;
    longTextView.selectable = NO;
    longTextView.backgroundColor = [UIColor clearColor];
    longTextView.text = [member objectForKey:@"role"];//[self.longAboutArray objectAtIndex:indexPath.row];
    longTextView.font = [UIFont systemFontOfSize:13];
    longTextView.scrollEnabled = NO;

    [cell addSubview:circularImageView];
    [cell addSubview:shortTextView];
    [cell addSubview:longTextView];
//
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor customLightGray];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
}
-(void) requestTeamDataForTeam: (NSString*)team {
    bool isCurrentTeam = [team isEqualToString:@"SS15"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/team/%@",API_ADDRESS, team]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSError *error1;
         NSLog(@"<<isCurrentTeam %d",isCurrentTeam );
         if(isCurrentTeam){
             currentTeam = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
         } else {
             lastTeam = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
         }
         NSLog(@"got team");
         [self.tableView reloadData];
     }];
}


@end
