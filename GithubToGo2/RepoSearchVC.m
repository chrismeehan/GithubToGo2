//
//  RepoSearchVC.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/30/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "RepoSearchVC.h"
#import "WebController.h"
#import "Repo.h"
#import "CAMAppDelegate.h"

@interface RepoSearchVC ()

@property(nonatomic) IBOutlet UITableView* uITV;
//@property(nonatomic) NSArray* arrayOfRepos;
@property(nonatomic) IBOutlet UISearchBar* uISBar;
@end

@implementation RepoSearchVC

@synthesize nSFetchedResultsController = _nSFetchedResultsController;

-(void)viewDidLoad{
    [super viewDidLoad];
    //self.arrayOfRepos = [[NSArray alloc]init];
    
    CAMAppDelegate* theAppDelegate = (CAMAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = theAppDelegate.managedObjectContext;
    self.managedObjectModel = theAppDelegate.managedObjectModel;
    self.persistentStoreCoordinator = theAppDelegate.persistentStoreCoordinator;

    
    self.uISBar.delegate=self;
    self.uITV.delegate = self;
    self.uITV.dataSource =self;
}

-(NSFetchedResultsController*)nSFetchedResultsController{
    if(_nSFetchedResultsController != nil){
        return _nSFetchedResultsController;
    }
    else{
     
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entityDescription];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Repos"];
        aFetchedResultsController.delegate = self;
        self.nSFetchedResultsController = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.nSFetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        return self.nSFetchedResultsController;
    }
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder]; // Get rid of the keyboard.
    NSArray* tempArrayOfRepos = [self downloadAllReposWithName:searchBar.text];
    
    for (NSDictionary* dict in tempArrayOfRepos) {
        NSEntityDescription* repoDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
                                                
        Repo* aRepo = [[Repo alloc]initWithEntity:repoDescription insertIntoManagedObjectContext:self.managedObjectContext withJSONDictionary:dict];
        [aRepo.managedObjectContext save:nil];
                                                
    }
}

-(NSArray*)downloadAllReposWithName:(NSString*) theName{
    NSString* stringOfWebsite = [NSString stringWithFormat:(@"https://api.github.com/search/repositories?q=%@"), theName];
    stringOfWebsite = [stringOfWebsite stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* theNSURL = [NSURL URLWithString:stringOfWebsite];
    // This NSData is in NSJson format, which most websites use for parsing. Let's convert to Foundation classes. (e.g. NSString,NSNumber)
    NSError* anError;
    NSData* downloadedNSData = [NSData dataWithContentsOfURL:theNSURL]; // This downloads all the data.
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:downloadedNSData options:NSJSONReadingMutableContainers error:&anError];
    NSArray* arrayOfRepoItems =  searchDictionary[@"items"]; // Give me the object at this key: items. (It's an array of repo items)
    return arrayOfRepoItems;
  //  [self.uITV reloadData]; // Hey, you gotta tell the tableview to ask for it's cells all over again, as if it was just initted.
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.uITV beginUpdates];
}

// We claim to conform to a delegate. So thats why we have this method.
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.uITV insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.uITV deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath{
    UITableView *tableView = self.uITV;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.uITV endUpdates];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//   NSLog(@"count is %d" ,  [self.nSFetchedResultsController.sections[section] numberOfObjects] );
    return [self.nSFetchedResultsController.sections[section] numberOfObjects] ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* uITVCell = [tableView dequeueReusableCellWithIdentifier:@"CellOnStoryboard"]; // Get a cell ready
    [self configureCell:uITVCell atIndexPath:indexPath];
    return  uITVCell;
}

// When they click on a particular repo cell, we will setup a webview for them.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell* senderCell = (UITableViewCell*) sender;
    WebController* theWC = [segue destinationViewController];
    theWC.urlStringToBeSet = [NSString stringWithFormat:(@"https://github.com/search?q=%@"), senderCell.textLabel.text];
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    Repo* aRepo = [self.nSFetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = aRepo.name;
}
@end
