//
//  RootViewController.h
//  JoinJob
//
//  Created by Luca Rocchi on 18/01/14.
//  Copyright (c) 2014 joinjob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController{
    UIImageView *imageView;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
- (void) loadFBPosts;
@end
