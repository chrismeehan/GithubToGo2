//
//  CAMMasterViewController.h
//  GithubToGo2
//
//  Created by Chris Meehan on 1/27/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAMDetailViewController;

@interface CAMMasterViewController : UITableViewController

@property (strong, nonatomic) CAMDetailViewController *detailViewController;

@end
