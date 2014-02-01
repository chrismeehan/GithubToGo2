//
//  CustomCollectionViewLayout.m
//  GithubToGo2
//
//  Created by Chris Meehan on 1/28/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//
// The collectionView will use this as its layout, for we told it in the storyboard.

#import "CustomCollectionViewLayout.h"

@implementation CustomCollectionViewLayout

// This gets called once at uicollectionview load time, and i think when something changes also.
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    self.itemSize = CGSizeMake(95, 111); // Make the cells a bit taller than wide, so the name can fit in the bottom.
    NSArray* arrayOfAttributes = [super layoutAttributesForElementsInRect:rect];
    return arrayOfAttributes;
}

@end
