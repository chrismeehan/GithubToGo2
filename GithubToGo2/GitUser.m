//
//  GitUser.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/29/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "GitUser.h"

@implementation GitUser

// Every GitUser downloads his own image.
- (void)downloadImage{
    imageIsDownloading = YES;
    // Let's tell his image to download on a background queue.
    [self.nSOpQueue addOperationWithBlock:^{
        // Get the image data.
        NSData *nSD = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.userImageURL]];
        // Convert it into a UIImage and give that to self (this gitUser).
        self.userImage = [UIImage imageWithData:nSD];
        // We're done downloading, let's tell our MAIN queue. It immediatly alerts our collectionView view via NSNotificationCenter.
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DoneDownloadingKeyword"
                                                                object:nil
                                                              userInfo:@{@"user": self}];
        }];
    }];
}

-(BOOL)isImageDownloading{
    return imageIsDownloading;
}

-(void)setIfImageIsDownloading:(BOOL)isIt{
    imageIsDownloading = isIt;
}

@end
