//
//  GridCell.h
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewIcon;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) NSMutableDictionary *data;

@end
