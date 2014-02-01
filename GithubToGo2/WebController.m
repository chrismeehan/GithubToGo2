//
//  WebController.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/31/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "WebController.h"

@interface WebController ()

@property(nonatomic) IBOutlet UIWebView* myUIWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;

@end


@implementation WebController


-(void)viewDidLoad{
    NSURL *url = [NSURL URLWithString:self.urlStringToBeSet];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    self.myUIWebView.delegate = self;
    [self.myUIWebView loadRequest:requestURL];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.progressIndicator setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
