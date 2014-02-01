//
//  CAMDetailViewController.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/27/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "CAMDetailViewController.h"

@interface CAMDetailViewController ()
    // UIPopoverControllers are only for ipad. They temporarily dispay info, and grey out the background.
    @property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation CAMDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Split view
// These are implemented because we want are a <UISplitViewControllerDelegate>
// This method tells the delegate that the specified view controller is about to be hidden. I think the only time that will happen is when turn the ipad to portrait.
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController{
        // Set our title to "Master"
        barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
        // Seeing how the tableView is about to DISSAPEAR, lets create a button that slides it into view.
        [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
        self.masterPopoverController = popoverController; // Lets hold on to it, for when we rotate back.
}

// This method tells the delegate that the specified view controller is about to be DISPLAYED. I think the only time that will happen is when we turn the ipad to landscape.
- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
        // Called when the view is shown again in the split view, invalidating the button and popover controller.
        // We dont need that button that says "Master" anymore, because Master will be in view now anyway.
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        self.masterPopoverController = nil; // We in landscape, we dont need popovers anymore.
}

@end
