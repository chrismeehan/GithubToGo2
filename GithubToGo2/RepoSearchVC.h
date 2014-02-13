//
//  RepoSearchVC.h
//  GithubToGo2
//
//  Created by Chris Meehan on 1/30/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RepoSearchVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic) NSFetchedResultsController* nSFetchedResultsController;


@end
