//
//  jcAppDelegate.h
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCFacebookPage.h"
#import "JCTwitterPage.h"
#import <FacebookSDK/FacebookSDK.h>

@interface jcAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;
@end
