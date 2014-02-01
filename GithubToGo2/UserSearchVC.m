//
//  UserSearchVC.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/28/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "UserSearchVC.h"
#import "CustomCollectionViewCell.h"
#import "GitUser.h"
#import "CustomCollectionViewLayout.h"
#import "WebController.h"


@interface UserSearchVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *aUICollView;
@property (nonatomic) NSOperationQueue* nSOQueue; // For downloading avitars
@property (nonatomic) NSMutableArray* arrayOfUsers;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation UserSearchVC

- (void)viewDidLoad{
    [super viewDidLoad];
    // The Gituser object has a method that notifies defaultCenter about a message named @"DoneDownloadingKeyword",  and this class will hear it.
    // Because theres no use trying to display an image until it is done downloading, and the gitUser should be able to download its own image.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneDownloading:) name:@"DoneDownloadingKeyword" object:nil];
    self.searchBar.delegate = self;
    self.nSOQueue = [[NSOperationQueue alloc]init];
    self.aUICollView.delegate = self;
    self.aUICollView.dataSource = self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayOfUsers.count;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.arrayOfUsers = [NSMutableArray new];
    [searchBar resignFirstResponder];
    [self downloadAllUsersWithName:searchBar.text];
}

-(void)downloadAllUsersWithName:(NSString *)searchString{
    // This is the entire address of those users.
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@",searchString];
    // You cant search anything with spaces in it, but search api's have a key word to represent a space, with a percent sign and such.
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *theNSURL = [NSURL URLWithString:searchString];
    NSError *error;
    NSData *myNSData = [NSData dataWithContentsOfURL:theNSURL];
    NSDictionary *searchDictionary =[NSJSONSerialization JSONObjectWithData:myNSData options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&error];
    // This puts each user the api sent us, into an array
    NSArray *arrayOfItems = searchDictionary[@"items"];
    [self initArrayOfGitUsersFromArray:arrayOfItems];
}

// Get our data source all set up with the users.
-(void)initArrayOfGitUsersFromArray:(NSArray *)searchArray{
    for (NSDictionary *dictionaryOfAUser in searchArray){
        GitUser *gitUser = [[GitUser alloc]init];
        gitUser.userName = dictionaryOfAUser[@"login"]; // Every github's username is stored in "login"
        gitUser.userImageURL = dictionaryOfAUser[@"avatar_url"];// Every github's user pic is stored at "avatar_url"'s address
        gitUser.nSOpQueue = self.nSOQueue; // Give the gutUser the NSOpQueue for him to download his avitar, but we still have control.
        [self.arrayOfUsers addObject:gitUser];
    }
    // There, every user is loaded into our data source.
    // Now we need to reset our collection view, because its been visible and blank for a while.
   [self.aUICollView reloadData]; // This has the collectionView ask for the array.count for rows again.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // The cell it might dequeue, wont be a custom collectionViewCell.
    UICollectionViewCell *dequeuedCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    // Load the user representing this cell into an object.
    GitUser *gitUser = self.arrayOfUsers[indexPath.row];
    CustomCollectionViewCell *customCollViewCell = (CustomCollectionViewCell *)dequeuedCell; // Im making sure it will end up a custom cell.
    customCollViewCell.userUIL.text = gitUser.userName;
    // He already has a UIImage already stored within him. Put that in the cell.
    if (gitUser.userImage) {
        customCollViewCell.userUIIV.image = gitUser.userImage;
    }
    // He might not have an image stored in him yet, we shouldnt let that stop the cell from showing though.
    else {
        // Not only is his image not stored in him yet, he isnt downloading one either, lets tell him to.
        if (![gitUser isImageDownloading]) {
            [gitUser downloadImage]; // Tell him to download his image.
        }
    }
    // There you go, give this to the collectionView trying to display it.
    return customCollViewCell;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    self.view.frame = CGRectMake(0, 0, 1000, 1100); // Keep the content slightly bigger than the screen size, for rotations.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CustomCollectionViewCell* senderCell = (CustomCollectionViewCell*) sender;
    WebController* theWC = [segue destinationViewController];
    theWC.urlStringToBeSet = [NSString stringWithFormat:(@"https://github.com/%@"), senderCell.userUIL.text];
}

// This loads any cell onscreen with its pic, after its done downloading.
- (void)doneDownloading:(NSNotification *)message{
    id sender = [[message userInfo] objectForKey:@"user"];
    if ([sender isKindOfClass:[GitUser class]]) {
        NSIndexPath *userIndexPath = [NSIndexPath indexPathForItem:[self.arrayOfUsers indexOfObject:sender] inSection:0];
        [self.aUICollView reloadItemsAtIndexPaths:@[userIndexPath]];
    }
}


@end
