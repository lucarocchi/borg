//
//  AppDelegate.h
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
@class RootViewController;
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CMMotionManager *motionManager;

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) NSString*baseUrl;
@property (strong, nonatomic) NSString*fbToken;
@property (strong, nonatomic) NSString*title;
@property (strong, nonatomic) NSString*filename;
@property  bool opened;
@property  NSInteger pageIndex;
@property  NSInteger categoryIndex;
@property (retain, nonatomic) NSMutableArray *categories;
@property (retain, nonatomic) NSMutableDictionary *json;
@property (retain, nonatomic) NSMutableDictionary *fb;
@property (retain, nonatomic) NSMutableArray *data;
@property (retain, nonatomic) NSMutableArray *alldata;
@property (retain, nonatomic) NSMutableDictionary *fbObjects;
@property (readonly) CMMotionManager *motionManager;

- (UIColor *)colorFromHexString:(NSString *)hexString;
- (float) getLabelHeight:(NSString*)s withFont:font Size:(int)size  andWidth:(int)width;
- (void)loginFacebook ;


@end
