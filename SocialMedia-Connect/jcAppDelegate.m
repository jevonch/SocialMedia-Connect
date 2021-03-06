//
//  jcAppDelegate.m
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import "jcAppDelegate.h"
#import "JCNavDeckController.h"
#import "JCSocmedRepository.h"

#import "JCFacebookPage.h"
#import "JCTwitterPage.h"

@interface jcAppDelegate ()
@property (nonatomic, strong) UINavigationController *navController1;
@property (nonatomic, strong) UINavigationController *navController2;
@property (nonatomic, strong) JCFacebookPage *fbPage;
@property (nonatomic, strong) JCTwitterPage *twitterPage;
@end

@implementation jcAppDelegate
@synthesize session = _session;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //do nothing
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    JCNavDeckController *navDeckController = (JCNavDeckController *)self.window.rootViewController;
    JCSocmedRepository *repo = [[JCSocmedRepository alloc]init];
    
    //declare storyboard
    UIStoryboard *fbStoryboard = [UIStoryboard storyboardWithName:@"fbStoryboard" bundle:nil];
    UIStoryboard *twitterStoryboard = [UIStoryboard storyboardWithName:@"twitterStoryboard" bundle:nil];
    
    //declare fbView
    self.fbPage=(JCFacebookPage *)[fbStoryboard instantiateViewControllerWithIdentifier:@"facebook"];
    [self.fbPage configureWithRepository:repo];
    
    self.navController1 = [fbStoryboard instantiateViewControllerWithIdentifier:@"fbNavBar"];
    self.navController1.viewControllers=[NSArray arrayWithObject:self.fbPage];
    
    //declare twitterView
    self.twitterPage=(JCTwitterPage *)[twitterStoryboard instantiateViewControllerWithIdentifier:@"twitter"];
    [self.twitterPage configureWithRepository:repo];
    
    self.navController2 = [twitterStoryboard instantiateViewControllerWithIdentifier:@"twitterNavBar"];
    self.navController2.viewControllers=[NSArray arrayWithObject:self.twitterPage];
    
   navDeckController.viewControllers = @[self.navController1, self.navController2];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


@end
