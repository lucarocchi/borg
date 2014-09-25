//
//  CallView.h
//  Userfarm
//
//  Created by luca luca on 06/05/12.
//  Copyright (c) 2012 theblogtv.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (CommentTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (CommentTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UILabel *userLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *userImage;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
