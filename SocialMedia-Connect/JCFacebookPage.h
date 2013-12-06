//
//  JCFacebookPage.h
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSocmedRepository.h"
#import "JCCell.h"
#import "JCMyFeeds.h"

@interface JCFacebookPage : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginlogout;
- (IBAction)loginButton:(id)sender;
- (void)configureWithRepository:(JCSocmedRepository *)repository;
@end
