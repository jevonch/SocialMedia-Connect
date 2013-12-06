//
//  JCFacebookPage.m
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import "JCFacebookPage.h"
#import "JCNavDeckController.h"
#import "jcAppDelegate.h"
#import "AsyncImageView.h"
#import "JCFacebookDetail.h"

@interface JCFacebookPage ()<JCSocmedRepositoryDelegate>
@property (nonatomic,strong) JCSocmedRepository *repository;
@property (nonatomic,strong,readwrite) NSArray *feeds;
@property (nonatomic,strong) JCFacebookDetail *fbDetail;
@end

@implementation JCFacebookPage


- (void)configureWithRepository:(JCSocmedRepository *)repository
{
    self.repository = repository;
    self.repository.delegate=self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OPTION" style:UIBarButtonItemStyleBordered target:self.navDeckController action:@selector(toggle)];
    
    [self updateView];
    //force to Login
    jcAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                [self updateView];
            }];
        }
    }
}


- (void)updateView {
    // get the app delegate, so that we can reference the session property
    jcAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        [self.loginlogout setTitle:@"Logout"];
        [self.repository requestFeeds:appDelegate.session.accessTokenData.accessToken];
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.loginlogout setTitle:@"Login"];
    }
}

- (IBAction)loginButton:(id)sender {
    jcAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.session.isOpen) {
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        
       

        // other way
       
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            
            
            [self updateView];
            
        }];
        
        
        /*[appDelegate.session requestNewPublishPermissions:@[@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session,
                                                            NSError *error) {
                                            // Handle new permissions callback
                                        }];*/
        
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    JCCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    JCMyFeeds *feed=self.feeds[indexPath.row];
    
    cell.nameLbl.text=feed.name;
    cell.statusView.text=feed.status;
    cell.timeLbl.text=[self dateConversion:feed.createTime];
    
    //get image view
    AsyncImageView *imageView = (AsyncImageView *)cell.imageView;
    
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    //load the image
    imageView.imageURL=[NSURL URLWithString:feed.profPict];
    
    
    return cell;
}

-(NSString *)dateConversion:(NSString *)time
{
    NSString *month=[[time substringFromIndex:5]substringToIndex:2];
    NSString *date=[[time substringFromIndex:8]substringToIndex:2];
    NSString *result;
    switch ([month intValue]) {
        case 1:result=@"Jan";break;
        case 2:result=@"Feb";break;
        case 3:result=@"Mar";break;
        case 4:result=@"Apr";break;
        case 5:result=@"May";break;
        case 6:result=@"Jun";break;
        case 7:result=@"Jul";break;
        case 8:result=@"Aug";break;
        case 9:result=@"Sep";break;
        case 10:result=@"Oct";break;
        case 11:result=@"Nov";break;
        case 12:result=@"Dec";break;
            break;    }
    
    return [NSString stringWithFormat:@"%@ %@",date,result];
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self shouldPerformSegueWithIdentifier:@"detailSegue" sender:indexPath];
    JCMyFeeds *feed=self.feeds[indexPath.row];
    [self.fbDetail configureWithFeeds:feed];
    [self.fbDetail configureDate:[self dateConversion:feed.createTime]];
}

#pragma mark socmed repository delegate

- (void)repository:(JCSocmedRepository *)repository didLoadFeeds:(NSArray *)feeds
{
    self.feeds=feeds;
    [self.tableView reloadData];
}

- (void)repository:(JCSocmedRepository *)repository didFailToLoadFeedsWithTerm:(NSString *)term
{
    UIAlertView *alert=[[UIAlertView alloc]
                        initWithTitle:@"Failed"
                        message:term
                        delegate:nil
                        cancelButtonTitle:nil
                        otherButtonTitles:@"OK", nil];
    [alert show];
    [self.tableView reloadData];
}

#pragma mark segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        //Configure the next view controller
        JCFacebookDetail *controller = (JCFacebookDetail *)segue.destinationViewController;
        self.fbDetail=controller;
    }
}


@end
