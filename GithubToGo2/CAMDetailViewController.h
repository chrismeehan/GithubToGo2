//
//  CAMDetailViewController.h
//  GithubToGo2
//
//  Created by Chris Meehan on 1/27/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import <UIKit/UIKit.h>

// You are going to behave like a UISplitViewController. That means the first view controller in your array of controllers will be hidden when the device rotates in to portrait. 

@interface CAMDetailViewController : UIViewController <UISplitViewControllerDelegate>
// This will hold whatever content this controller needs to show
@property (strong, nonatomic) id detailItem;
// This is holding the label in the middle of the view.
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIViewController *currentDetailVC; // I will display different viewControllers.

@end
