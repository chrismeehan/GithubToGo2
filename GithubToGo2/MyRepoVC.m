//
//  MyRepoVC.m
//  GithubToGo2
//
//  Created by Nicholas Barnard on 2/12/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "MyRepoVC.h"
#import "Repo.h"

@interface MyRepoVC ()

@end

@implementation MyRepoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* tempArrayOfRepos = [self downloadAllRepos];

    for (NSDictionary* dict in tempArrayOfRepos) {
        NSEntityDescription* repoDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];

        Repo* aRepo = [[Repo alloc]initWithEntity:repoDescription insertIntoManagedObjectContext:self.managedObjectContext withJSONDictionary:dict];
        [aRepo.managedObjectContext save:nil];
    }
//    [self.uITV reloadData];
}

-(NSArray*)downloadAllRepos{
    NSLog(@"HI!");
    NSString* stringOfWebsite = [NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"gittoken"]];
    stringOfWebsite = [stringOfWebsite stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* theNSURL = [NSURL URLWithString:stringOfWebsite];
    // This NSData is in NSJson format, which most websites use for parsing. Let's convert to Foundation classes. (e.g. NSString,NSNumber)
    NSError* anError;
    NSData* downloadedNSData = [NSData dataWithContentsOfURL:theNSURL]; // This downloads all the data.
    NSArray *searchDictionary = [NSJSONSerialization JSONObjectWithData:downloadedNSData options:NSJSONReadingMutableContainers error:&anError];
    return searchDictionary;
    //  [self.uITV reloadData]; // Hey, you gotta tell the tableview to ask for its cells all over again, as if it was just initted.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
