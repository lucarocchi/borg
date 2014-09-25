//
//  AppDelegate.m
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "RootViewController.h"
#import "AFNetworking.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "Accounts/ACAccountStore.h"
#import "Accounts/ACAccountType.h"
#import "Accounts/ACAccount.h"
#import "Accounts/ACAccountCredential.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.json=[NSMutableDictionary dictionary];
    self.alldata=[NSMutableArray array];
    self.data=[NSMutableArray array];
    //self.items=[NSMutableArray array];
    self.opened=false;
    self.fbObjects=[NSMutableDictionary dictionary];
    
    self.rootViewController=[RootViewController new];
    self.mainViewController=[MainViewController new];
    [self.window setRootViewController:self.rootViewController];
    self.baseUrl=@"http://www.mobileborg.com/newapp/";
    //self.title=@"B-eat Digital Kitchen";
    //self.filename=@"beat";
    //self.title=@"Terra e mare";
    //self.filename=@"terraemare";
    self.title=@"Iquii";
    self.filename=@"iquii";
    //self.title=@"Userfarm";
    //self.filename=@"userfarm";
    
    //self.title=@"Userfarm";
    //self.filename=@"ufglobal";
    
    //self.title=@"Freenapsy";
    //self.filename=@"freenapsy";
    //self.title=@"Pages";
    //self.filename=@"pages";
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    self.pageIndex=0;
    self.categories=[NSMutableArray array];
    self.categoryIndex=0;
    //[FBLoginView class];
    
    //NSLog(@"fonts %@",[UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
    
    //NSLog(@"FB logged in - token expiration: %@",[[FBSession activeSession] accessTokenData].expirationDate);

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//helper functions
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (float) getLabelHeight:(NSString*)s withFont:font Size:(int)size andWidth:(int)width{
    //NSDictionary *attributes = @{NSFontAttributeName: font};
    
    float deviceVersion   = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSMutableAttributedString*as= [[NSMutableAttributedString alloc] initWithString:s];
    [as addAttribute:NSFontAttributeName value:[UIFont fontWithName:font size:size] range:NSMakeRange(0,s.length)];

    if (deviceVersion>=7.0){
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        

        CGRect rect = [as boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                      context:nil];
        return rect.size.height;
    }else{
        /*CGSize textSize = [s sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300, 20000) lineBreakMode: NSLineBreakByWordWrapping];
         
         return textSize.height;*/
    }
    return 70;
}

- (CMMotionManager *)motionManager {
    if (!motionManager)
        motionManager = [[CMMotionManager alloc] init];
    return motionManager;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)loginFacebook {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        //NSLog(@"Facebook account not available");
        //[self.rootViewController addFBLoginView];
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            
            // If there's one, just open the session silently, without showing the user the login UI
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                               allowLoginUI:NO
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                              // Handler for session state changes
                                              // This method will be called EACH time the session state changes,
                                              // also for intermediate states and NOT just when the session open
                                              [self sessionStateChanged:session state:state error:error];
                                          }];
            return;
        }
    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ACAccountStore *_accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *fbActType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    #define FB_KEY "204264309603362"
    
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @FB_KEY,(NSString *)ACFacebookAppIdKey,
                             ACFacebookAudienceKey , ACFacebookAudienceFriends,
                             [NSArray arrayWithObject:@"email"],(NSString *)ACFacebookPermissionsKey,
                             nil];
    
    
    [_accountStore requestAccessToAccountsWithType:fbActType options:options completion:^(BOOL granted, NSError *error) {
        if (granted == YES) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *accounts = [_accountStore accountsWithAccountType:fbActType];
                ACAccount*account=[accounts lastObject];
                ACAccountCredential *ac=[account credential];
                app.fbToken=[ac oauthToken];
                //NSLog(@"Facebook Login token %@ ",app.fbToken);
                NSString*fbid=[app.fb objectForKey:@"pageid"];

                [self.rootViewController loadFBId:fbid];
                
            });
            
            
        } else {
            //NSLog(@"Facebook Login not granted ");
            [self.rootViewController addFBLoginView];
        }
    }
     ];
    
    
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        //NSLog(@"Session opened");
        // Show the user the logged-in UI
        //[self userLoggedIn];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //NSLog(@"Access Token %@", [[FBSession.activeSession accessTokenData] accessToken]);
        
        app.fbToken=[[FBSession.activeSession accessTokenData] accessToken];
        //NSLog(@"Facebook Login token %@ ",app.fbToken);
        NSString*fbid=[app.fb objectForKey:@"pageid"];
        
        [self.rootViewController loadFBId:fbid];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        //NSLog(@"Session closed");
        [self.rootViewController addFBLoginView];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}

@end
