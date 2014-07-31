//
//  SectionDelegate.h
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MainViewController;
@interface GridDelegate : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet MainViewController *controller;

@end
