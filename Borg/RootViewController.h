//
//  RootViewController.h
//  JoinJob
//
//  Created by Luca Rocchi on 18/01/14.
//  Copyright (c) 2014 joinjob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface RootViewController : UIViewController<FBLoginViewDelegate>{
    UIImageView *imageView;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
- (void) loadFBId:(NSString*)fbid;
- (void) loadFBPosts:(id)fb;
- (void) loadFBLikes:(NSString*)fbid;
- (void) addFBLoginView;
@end
