//
//  AFCollectionViewFlowSmallLayout.m
//  UICollectionViewFlowLayoutExample
//
//  Created by Ash Furrow on 2013-02-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewFlowSmallLayout.h"

@implementation AFCollectionViewFlowSmallLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(SUBSECTION_WIDTH, SUBSECTION_HEIGHT);
    self.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    self.minimumInteritemSpacing = 1.0f;
    self.minimumLineSpacing = 1.0f;
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    return self;
}

@end
