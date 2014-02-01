//
//  CustomCollectionViewCelliPad.h
//  GithubToGo2
//
//  Created by Chris Meehan on 1/30/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

// This custom cell is strictly for the iPad. We could probably share it across devices if we wanted to.
#import <UIKit/UIKit.h>

@interface CustomCollectionViewCelliPad : UICollectionViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *userUIIV;
    @property (weak, nonatomic) IBOutlet UILabel *userUIL;
    @property (readwrite,nonatomic) BOOL isImageDownloading;
@end
