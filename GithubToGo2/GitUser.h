//
//  GitUser.h
//  GithubToGo2
//
//  Created by Chris Meehan on 1/29/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitUser : NSObject{
    BOOL imageIsDownloading;
}

@property(nonatomic) NSString* userName;
@property(nonatomic) NSString* userImageURL;
@property(nonatomic) UIImage* userImage;
@property(nonatomic) NSOperationQueue* nSOpQueue;

- (void)downloadImage;
-(BOOL)isImageDownloading;
-(void)setIfImageIsDownloading:(BOOL)isIt;
@end
