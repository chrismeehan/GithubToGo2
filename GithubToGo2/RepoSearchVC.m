//
//  RepoSearchVC.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/30/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "RepoSearchVC.h"
#import "WebController.h"


@interface RepoSearchVC ()

@property(nonatomic) IBOutlet UITableView* uITV;
@property(nonatomic) NSArray* arrayOfRepos;
@property(nonatomic) IBOutlet UISearchBar* uISBar;
@end

@implementation RepoSearchVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.arrayOfRepos = [[NSArray alloc]init];
    self.uISBar.delegate=self;
    self.uITV.delegate = self;
    self.uITV.dataSource =self;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder]; // Get rid of the keyboard.
    [self downloadAllReposWithName:searchBar.text];
}

-(void)downloadAllReposWithName:(NSString*) theName{
    NSString* stringOfWebsite = [NSString stringWithFormat:(@"https://api.github.com/search/repositories?q=%@"), theName];
    stringOfWebsite = [stringOfWebsite stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* theNSURL = [NSURL URLWithString:stringOfWebsite];
    // This NSData is in NSJson format, which most websites use for parsing. Let's convert to Foundation classes. (e.g. NSString,NSNumber)
    NSError* anError;
    NSData* downloadedNSData = [NSData dataWithContentsOfURL:theNSURL]; // This downloads all the data.
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:downloadedNSData options:NSJSONReadingMutableContainers error:&anError];
    NSArray* arrayOfRepoItems =  searchDictionary[@"items"]; // Give me the object at this key: items. (It's an array of repo items)
    self.arrayOfRepos = arrayOfRepoItems;
    [self.uITV reloadData]; // Hey, you gotta tell the tableview to ask for it's cells all over again, as if it was just initted.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfRepos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* uITVCell = [tableView dequeueReusableCellWithIdentifier:@"CellOnStoryboard"]; // Get a cell ready
    NSDictionary* dictRepresentingOneRepo = [self.arrayOfRepos objectAtIndex:indexPath.row]; // Get the dict representing one repo.
    NSString* stringName = [dictRepresentingOneRepo objectForKey:@"name"]; // Get object from key "name",    which will be a repo name string.
    uITVCell.textLabel.text = stringName;
    return  uITVCell;
}

// When they click on a particular repo cell, we will setup a webview for them.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell* senderCell = (UITableViewCell*) sender;
    WebController* theWC = [segue destinationViewController];
    theWC.urlStringToBeSet = [NSString stringWithFormat:(@"https://github.com/search?q=%@"), senderCell.textLabel.text];
}
@end
