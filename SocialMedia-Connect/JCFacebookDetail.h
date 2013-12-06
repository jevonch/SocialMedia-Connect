//
//  JCFacebookDetail.h
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/6/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCMyFeeds.h"

@interface JCFacebookDetail : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITextView *statusLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
-(void)configureWithFeeds:(JCMyFeeds *)feeds;
-(void)configureDate:(NSString *)date;
- (IBAction)comment:(id)sender;
- (IBAction)like:(id)sender;
@end
