//
//  CAMMenuViewController.h
//  GithubToGo2
//
//  Created by Chris Meehan on 1/27/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAMDetailViewController;

@interface CAMMenuViewController : UITableViewController<UIGestureRecognizerDelegate>{
    float pageDoesntEntirelyCoverBy; // This keeps any pages floating on top, slightly offset by this much so we can see behind it.
}

// We need a details class to show off the stuff of the cell that will get selected.
@property (strong, nonatomic) CAMDetailViewController *detailViewController;

@end
