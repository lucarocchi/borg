//
//  CallView.h
//  Userfarm
//
//  Created by luca luca on 06/05/12.
//  Copyright (c) 2012 theblogtv.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Item1TableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (Item1TableCell *)cellFromNibNamed:(NSString *)nibName;
+ (Item1TableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic, retain) IBOutlet UILabel *userLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UIImageView *userImage;
@property (nonatomic, retain) IBOutlet UIImageView *categoryImage;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
