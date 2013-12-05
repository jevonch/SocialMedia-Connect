//
//  jcAppDelegate.m
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import "jcAppDelegate.h"
#import "JCNavDeckController.h"

#import "JCFacebookPage.h"
#import "JCTwitterPage.h"

@implementation jcAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    JCNavDeckController *navDeckController = (JCNavDeckController *)self.window.rootViewController;
    
    UIStoryboard *fbStoryboard = [UIStoryboard storyboardWithName:@"fbStoryboard" bundle:nil];
    UINavigationController *navController1 = [fbStoryboard instantiateInitialViewController];
    
    
    UIStoryboard *twitterStoryboard = [UIStoryboard storyboardWithName:@"twitterStoryboard" bundle:nil];
    UINavigationController *navController2 = [twitterStoryboard instantiateInitialViewController];
    
    //JCFacebookPage *vc1 = [[JCFacebookPage alloc] initWithNibName:nil bundle:nil];
    //UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    //JCTwitterPage *vc2 = [[JCTwitterPage alloc] initWithNibName:nil bundle:nil];
    //UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    navDeckController.viewControllers = @[navController1, navController2];
    
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
