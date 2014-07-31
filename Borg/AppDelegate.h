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
@property (retain, nonatomic) IBOutlet NSMutableDictionary *json;
@property (retain, nonatomic) IBOutlet NSMutableDictionary *fb;
@property (retain, nonatomic) IBOutlet NSMutableArray *data;
@property (retain, nonatomic) IBOutlet NSMutableArray *items;
@property (retain, nonatomic) IBOutlet NSMutableDictionary *fbObjects;
@property (readonly) CMMotionManager *motionManager;

- (UIColor *)colorFromHexString:(NSString *)hexString;
- (float) getLabelHeight:(NSString*)s withFont:font andWidth:width;
- (void)loginFacebook ;


@end
