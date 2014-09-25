//
//  ItemViewController.h
//  Scribbis
//
//  Created by Luca Rocchi on 30/04/14.
//  Copyright (c) 2014 tbtv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

-(id)initWithData:(NSMutableDictionary*)data;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
