//
//  WebController.h
//  GithubToGo2
//
//  Created by Chris Meehan on 1/31/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebController : UIViewController<UIWebViewDelegate>
@property(nonatomic) NSString* urlStringToBeSet;
@end
