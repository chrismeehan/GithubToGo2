//
//  CAMAppDelegate.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/27/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "CAMAppDelegate.h"

@implementation CAMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Only if we are an ipad....
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Lets take the rootViewController that the app gives us, and give that address to the split view controller.
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        // Any UISplitViewController is just a container class that takes care of the child parent stuff, and has a viewControllers array property that must hold exactly 2 items, item[0] is the master and [1] is the detail.
        //LastObject must me the detail controller. lets assign it to our navigationController we will use to navigate with.
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        // When the splitVC has a question or command, it will tell it to the navController's top viewController, which ever one that is.
        splitViewController.delegate = (id)navigationController.topViewController;
    }
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
