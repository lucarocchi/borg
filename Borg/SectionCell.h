//
//  GridCell.h
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCell : UICollectionViewCell
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewLogo;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelCategory;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPicture;
@property (weak, nonatomic) IBOutlet UIView *viewPicture;

@end
