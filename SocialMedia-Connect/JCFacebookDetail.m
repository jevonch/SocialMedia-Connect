//
//  JCFacebookDetail.m
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/6/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import "JCFacebookDetail.h"
#import "jcAppDelegate.h"


@interface JCFacebookDetail ()<UITextFieldDelegate>
@property (nonatomic,strong,readwrite) JCMyFeeds *feeds;
@property (nonatomic,strong,readwrite) NSString *date;
@property (nonatomic,strong,readwrite) jcAppDelegate *appDelegate;
@end

@implementation JCFacebookDetail

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField setUserInteractionEnabled:YES];
    [textField resignFirstResponder];
    return YES;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)activeSessionHasPermissions:(NSArray *)permissions
{
    __block BOOL hasPermissions = YES;
    for (NSString *permission in permissions)
    {
        NSInteger index = [[FBSession activeSession].permissions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:permission])
            {
                *stop = YES;
            }
            return *stop;
        }];
        
        if (index == NSNotFound)
        {
            hasPermissions = NO;
        }
    }
    return hasPermissions;
}

- (IBAction)like:(id)sender {
    
    
    jcAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSArray *permission=[[NSArray alloc]initWithObjects:@"publish_actions", nil];
    if([self activeSessionHasPermissions:permission])
    {
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/likes?access_token=%@",self.feeds.feedID,appDelegate.session.accessTokenData.accessToken] parameters:nil HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(error)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error.description] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
            }
            else
            { UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Thank You for Your Love" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];}
        }];
        /*NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/likes?access_token=%@",self.feeds.feedID,appDelegate.session.accessTokenData.accessToken]]];
        
        NSLog(@"%@",[NSString stringWithFormat:@"https://graph.facebook.com/%@/likes?access_token=%@",self.feeds.feedID,appDelegate.session.accessTokenData.accessToken]);*/
    }
    else
    {
        
        [appDelegate.session requestNewPublishPermissions:@[@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session,
                                                            NSError *error) {
                                            // Handle new permissions callback
                                        }];
    }
    
   
}

- (IBAction)comment:(id)sender {
    jcAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSString *message=self.commentField.text;
    NSArray *permission=[[NSArray alloc]initWithObjects:@"publish_actions", nil];
    if([self activeSessionHasPermissions:permission])
    {
        NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
        action[@"message"] = message;
        [FBRequestConnection startForPostWithGraphPath:[NSString stringWithFormat:@"%@/comments?access_token=%@",self.feeds.feedID,appDelegate.session.accessTokenData.accessToken] graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            // internal error 1611231 means that this was already posted
            if (error)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error Code:%@",error.description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            { UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Thank You for Your Comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
         }];
        
        /*NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
         [request setHTTPMethod:@"POST"];
         [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/likes?access_token=%@",self.feeds.feedID,appDelegate.session.accessTokenData.accessToken]]];
         
         NSLog(@"%@",[NSString stringWithFormat:@"https://graph.facebook.com/%@/likes?access_token=%@",self.feeds.feedID,appDelegate.session.accessTokenData.accessToken]);*/
    }
    else
    {
        
        [appDelegate.session requestNewPublishPermissions:@[@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session,
                                                            NSError *error) {
                                            // Handle new permissions callback
                                        }];
    }

}



-(void)configureWithFeeds:(JCMyFeeds *)feeds
{
    self.feeds=feeds;
}

-(void)configureDate:(NSString *)date
{
    self.date=date;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.commentField.delegate=self;
    self.nameLbl.text=self.feeds.name;
    NSString *month=[[self.feeds.createTime substringFromIndex:5]substringToIndex:2];
    NSString *date=[[self.feeds.createTime substringFromIndex:8]substringToIndex:2];
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
            break;
    }
    self.timeLbl.text=[NSString stringWithFormat:@"%@ %@",date,result];
    self.statusLbl.text=self.feeds.status;
    NSString *urlString = [NSString stringWithFormat:@"%@",self.feeds.profPict];
    NSURL *url = [NSURL URLWithString:urlString];
    [self loadImage:url];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadImage:(NSURL *)imageURL
{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(requestRemoteImage:)
                                        object:imageURL];
    [queue addOperation:operation];
}

- (void)requestRemoteImage:(NSURL *)imageURL
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    [self performSelectorOnMainThread:@selector(placeImageInUI:) withObject:image waitUntilDone:YES];
}

- (void)placeImageInUI:(UIImage *)image
{
    [self.imageView setImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
