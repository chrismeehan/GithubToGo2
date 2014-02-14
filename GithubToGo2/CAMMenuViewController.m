//
//  CAMMasterViewController.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/27/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//
// This class is just a menu. For ipad or iphone.

#import "CAMMenuViewController.h"
#import "CAMDetailViewController.h"
#import "RepoSearchVC.h"
#import "UserSearchVC.h"


@interface CAMMenuViewController ()
@property(nonatomic) RepoSearchVC* gitRepoController; // We will swap these out as the "Master" when user selects.
@property(nonatomic) UserSearchVC* gitUserController;
@property(nonatomic) UIPanGestureRecognizer *uIPGR;
@property(nonatomic) UIViewController* currentDetailVC; // Whatever detail view is on screen.

@end

@implementation CAMMenuViewController

// I think this gets automatically called, only after all objects have been alloced, and initted. It's like final cleanup.
- (void)awakeFromNib{
    // If this is an iPad.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // All splitVC's have a preferredContentSize property that states what size it wants its master to always be.
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib]; // Now set the table view up, whether it's for ipad or iphone.
}

// I think this gets called after awakeFromNib
- (void)viewDidLoad{
    [super viewDidLoad];
    pageDoesntEntirelyCoverBy = 5; //The child screen won't totally cover its parent, by this much.
    self.uIPGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userSlid:)];
    // Its not enought to tell the uIPGR what its target is (self), we also need to set its delegate to (self).
    self.uIPGR.delegate = self;
    self.uIPGR.minimumNumberOfTouches = 1;
    self.uIPGR.maximumNumberOfTouches = 1;
    // This line connects the detailViewController property this class starts off with, with the real one in the storyboard.
    self.detailViewController = (CAMDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	[self checkDisableLogInButton];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(checkDisableLogInButton) name:@"tokenReceived" object:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Then this is an ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if(indexPath.row == 0){        // ANd the top cell was selected, so let's show the git repo controller.
            self.gitRepoController = [self.storyboard  instantiateViewControllerWithIdentifier:@"RepoSearchVCiPad"];
            // Set our new controller's frame to match it's parent's (self).
            self.gitRepoController.view.frame = CGRectMake(0 ,0, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
            [self.detailViewController addChildViewController:self.gitRepoController];
            [self.detailViewController.view addSubview:self.gitRepoController.view];
            [self.gitUserController.view setBackgroundColor:[UIColor blueColor]];
            [self.gitRepoController didMoveToParentViewController:self.detailViewController];
        }
        else if(indexPath.row == 1){ // Lets get the git user view up, for ipad.
            self.gitUserController = [self.storyboard  instantiateViewControllerWithIdentifier:@"UserSearchVCiPad"];
            // Set our new controller's frame to match it's parent's (self).
            self.gitUserController.view.frame = CGRectMake(0 ,0, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
            [self.detailViewController addChildViewController:self.gitUserController];
            [self.detailViewController.view addSubview:self.gitUserController.view];
            [self.gitUserController.view setBackgroundColor:[UIColor redColor]];
            [self.gitUserController didMoveToParentViewController:self.detailViewController];
        }
		else if(indexPath.row == 2)
		{
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gittoken"] == nil)
			{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Not Logged In"
                                                                message: @"You are not Logged In, Tap Login"
                                                               delegate: nil
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
			else
			{
                self.gitRepoController = [self.storyboard  instantiateViewControllerWithIdentifier:@"MyRepoSearchVCiPad"];
                // Set our new controller's frame to match it's parent's (self).
                self.gitRepoController.view.frame = CGRectMake(0 ,0, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
                [self.detailViewController addChildViewController:self.gitRepoController];
                [self.detailViewController.view addSubview:self.gitRepoController.view];
                [self.gitUserController.view setBackgroundColor:[UIColor blueColor]];
                [self.gitRepoController didMoveToParentViewController:self.detailViewController];
            }
        }
		else if (indexPath.row == 3)
		{
			
		}
    }
    // Then this is not an ipad
    else {
        if(self.currentDetailVC != nil) {
            [self hideContentController:self.currentDetailVC];
            [self.currentDetailVC dismissViewControllerAnimated:NO completion:nil];
        }
        if(indexPath.row == 0){ // Then we want git user view for iphoones.
            self.gitRepoController = [self.storyboard instantiateViewControllerWithIdentifier:@"RepoSearchVC"];
            //shadowing
            self.gitRepoController.view.layer.shadowOpacity = 0.7;
            self.gitRepoController.view.layer.shadowOffset = CGSizeMake(-17, 18);
            self.gitRepoController.view.layer.cornerRadius = 2; // if you like rounded corners
            self.gitRepoController.view.layer.shadowRadius = 7;
            // Lets create it almost all the way offscreen to the right, then bring it back left 40 points.
            self.gitRepoController.view.frame = CGRectMake(self.view.frame.size.width-40 ,0, self.view.frame.size.width-pageDoesntEntirelyCoverBy, self.view.frame.size.height);
            // Then have it instantly slide left, covering up the master.
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.gitRepoController.view.frame;
                frame.origin.x = pageDoesntEntirelyCoverBy; // Push the left side off the left edge a bit.
                self.gitRepoController.view.frame = frame;
            }
             completion:^(BOOL finished){
                 // whatever you need to do when animations are complete
             }];
            [self addChildViewController:self.gitRepoController];
            [self.view addSubview:self.gitRepoController.view];
            [self.gitRepoController didMoveToParentViewController:self];
            self.currentDetailVC = self.gitRepoController;// So we know what detail view is currently on screen.
            [self.view addGestureRecognizer:self.uIPGR];
        }
        else if(indexPath.row == 1){ // Then we want git repos view for iphoones.
            self.gitUserController = [self.storyboard  instantiateViewControllerWithIdentifier:@"UserSearchVC"];
            //shadowing
            self.gitUserController.view.layer.shadowOpacity = 0.7;
            self.gitUserController.view.layer.shadowOffset = CGSizeMake(-17, 18);
            self.gitUserController.view.layer.cornerRadius = 2; // if you like rounded corners
            self.gitUserController.view.layer.shadowRadius = 7;
            // Lets create it almost all the way offscreen to the right, then bring it back left 40 points.
            self.gitUserController.view.frame = CGRectMake(self.view.frame.size.width-40 ,0, self.view.frame.size.width-pageDoesntEntirelyCoverBy, self.view.frame.size.height);
            // Then have it instantly slide left, covering up the master.
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.gitUserController.view.frame;
                frame.origin.x = pageDoesntEntirelyCoverBy;
                self.gitUserController.view.frame = frame;
            }
            completion:^(BOOL finished){
                 // whatever you need to do when animations are complete
            }];
            [self addChildViewController:self.gitUserController];
            [self.view addSubview:self.gitUserController.view];
            [self.gitUserController didMoveToParentViewController:self];
             self.currentDetailVC = self.gitUserController; // So we know what detail view is currently on screen.
            [self.view addGestureRecognizer:self.uIPGR];
        }
		else if(indexPath.row == 2) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gittoken"] == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Not Logged In"
                                                                message: @"You are not Logged In, Tap Login"
                                                               delegate: nil
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            } else  {
                self.gitRepoController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRepoSearchVCiPhone"];
                //shadowing
                self.gitRepoController.view.layer.shadowOpacity = 0.7;
                self.gitRepoController.view.layer.shadowOffset = CGSizeMake(-17, 18);
                self.gitRepoController.view.layer.cornerRadius = 2; // if you like rounded corners
                self.gitRepoController.view.layer.shadowRadius = 7;
                // Lets create it almost all the way offscreen to the right, then bring it back left 40 points.
                self.gitRepoController.view.frame = CGRectMake(self.view.frame.size.width-40 ,0, self.view.frame.size.width-pageDoesntEntirelyCoverBy, self.view.frame.size.height);
                // Then have it instantly slide left, covering up the master.
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect frame = self.gitRepoController.view.frame;
                    frame.origin.x = pageDoesntEntirelyCoverBy; // Push the left side off the left edge a bit.
                    self.gitRepoController.view.frame = frame;
                }
                                 completion:^(BOOL finished){
                                     // whatever you need to do when animations are complete
                                 }];
                [self addChildViewController:self.gitRepoController];
                [self.view addSubview:self.gitRepoController.view];
                [self.gitRepoController didMoveToParentViewController:self];
                self.currentDetailVC = self.gitRepoController;// So we know what detail view is currently on screen.
                [self.view addGestureRecognizer:self.uIPGR];

            }
        }
		else if (indexPath.row == 3)
		{
			if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gittoken"] == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Not Logged In"
                                                                message: @"You are not Logged In, Tap Login"
                                                               delegate: nil
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
			else
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Repo Name" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Create Repo", nil];
				alert.alertViewStyle = UIAlertViewStylePlainTextInput;
				[alert show];
			}
		}
    }
}

// To get rid of our current child view.
- (void) hideContentController: (UIViewController*) content{
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}




-(void)userSlid:(UIPanGestureRecognizer*) uIPanGR{
    // If the user lifted his finger off the screen.
    if(uIPanGR.state == UIGestureRecognizerStateEnded){
        if(self.currentDetailVC.view.frame.origin.x < self.view.frame.size.width/2.0){ // If we're on the left half.
            [UIView animateWithDuration:0.4 animations:^{
                self.currentDetailVC.view.center = CGPointMake(self.view.center.x+pageDoesntEntirelyCoverBy, self.view.center.y);
            }];
        }
        else{ // Then we're on the right half
            [UIView animateWithDuration:0.4 animations:^{
                self.currentDetailVC.view.center = CGPointMake(self.view.center.x + self.view.frame.size.width - 40, self.view.center.y);
            }];
        }
    }
    // Otherwise, we still are still sliding or just started sliding.
    else{
        CGPoint slideDelta = [uIPanGR translationInView:self.view];
        if (uIPanGR.state == UIGestureRecognizerStateChanged){
            if (self.currentDetailVC.view.frame.origin.x+ slideDelta.x > 0) {
                self.currentDetailVC.view.center = CGPointMake(self.currentDetailVC.view.center.x +slideDelta.x, self.currentDetailVC.view.center.y);
               [uIPanGR setTranslation:CGPointMake(0,0) inView:self.view];
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		NSString *repoName = [[alertView textFieldAtIndex:0] text];
		NSDictionary *newRepo = [[NSDictionary alloc] initWithObjects:@[repoName] forKeys:@[@"name"]];
		
		NSData *jsonForRepo = [NSJSONSerialization dataWithJSONObject:newRepo
														   options:NSJSONWritingPrettyPrinted
															 error:nil];
		
		NSMutableURLRequest *postRequest = [NSMutableURLRequest new];
		
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonForRepo length]];
		
		NSString *postURL = [NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"gittoken"]];
		
		[postRequest setURL:[NSURL URLWithString:postURL]];
		[postRequest setHTTPMethod:@"POST"];
		[postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[postRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
		[postRequest setHTTPBody:jsonForRepo];
		
		NSURLResponse *postResponse;
		NSError *postError;
		
		NSData *returnedPostData =  [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&postResponse error:&postError];
		
		NSString *repoResponse = [[NSString alloc] initWithData:returnedPostData encoding:NSASCIIStringEncoding];
		
		NSLog(@"%@", repoResponse);
	}
}

-(IBAction)logInButtonTapped:(id)sender {

    NSString *requestURL = @"https://github.com/login/oauth/authorize?client_id=b57dca483196bdd4e791&scope=user,repo";

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestURL]];
}

-(void)checkDisableLogInButton
{
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gittoken"] != nil)
	{
        _logInButton.enabled = NO;
        _logInButton.title = @"Logged In";
    }
}

@end
