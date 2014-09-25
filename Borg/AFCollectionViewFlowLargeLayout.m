//
//  AFCollectionViewFlowLargeLayout.m
//  UICollectionViewFlowLayoutExample
//
//  Created by Ash Furrow on 2013-02-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewFlowLargeLayout.h"

@implementation AFCollectionViewFlowLargeLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    CGRect r=[[UIScreen mainScreen] bounds];
    float sh=r.size.height;
    float sw=r.size.width;
    float dy=SUBSECTION_HEIGHT/2;
    self.itemSize = CGSizeMake(sw, (sh-dy)*2);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = 0.0f;
    self.minimumLineSpacing = 0.0f;
    //self.scrollDirection=
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
   
    
    return self;
}

@end
