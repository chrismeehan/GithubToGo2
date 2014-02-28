//
//  CAMAppDelegate.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/27/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "CAMAppDelegate.h"
#import "CAMMenuViewController.h"

@interface CAMAppDelegate()

@end

@implementation CAMAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
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

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// This gets called when the phone starts shutting down.
- (void)applicationWillTerminate:(UIApplication *)application{
    [self saveContext];
}

//override the getters for the 3 properties


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Github_To_Go" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Github_To_Go.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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


-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"%@", url);

    NSString *query = [url query];
    NSArray *queryComponents = [query componentsSeparatedByString:@"="];
    NSString *code = [queryComponents objectAtIndex:1];

    NSLog(@"%@", code);

    NSData *postData = [code dataUsingEncoding:NSASCIIStringEncoding];

    NSMutableURLRequest *postRequest = [NSMutableURLRequest new];

    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

    NSString *postURL = [NSString stringWithFormat:@"https://github.com/login/oauth/access_token?client_id=b57dca483196bdd4e791&client_secret=e2129a1f39e13f4a47250ec93ebedbc929338b8f&code=%@",code];

    [postRequest setURL:[NSURL URLWithString:postURL]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];

    NSURLResponse *postResponse;
    NSError *postError;

    NSData *returnedPostData =  [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&postResponse error:&postError];

    NSString *tokenResponse = [[NSString alloc] initWithData:returnedPostData encoding:NSASCIIStringEncoding];

    NSLog(@"%@", tokenResponse);

    NSString *accessToken = [[tokenResponse componentsSeparatedByString:@"&"][0] componentsSeparatedByString:@"="][1];

    NSLog(@"%@", accessToken);

    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"gittoken"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"tokenReceived" object:nil];

    return YES;
}


@end
