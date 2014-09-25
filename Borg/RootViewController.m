//
//  RootViewController.m
//  Borg
//
//  Created by Luca Rocchi on 18/01/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "AFNetworking.h"

@interface RootViewController ()
@property (strong, nonatomic) FBLoginView *loginView;
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.labelTitle setText:[app.title capitalizedString]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChangeCategory:)
                                                 name:@"onChangeCategory"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChangePage:)
                                                 name:@"onChangePage"
                                               object:nil];

    UIImage *image = [UIImage imageNamed:@"splash.png"];
    imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    dispatch_async (dispatch_get_main_queue(), ^{
        [self loadData];
        //[self.collectionView reloadData];
    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) loadData{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:app.filename ofType:@"json"] ;
    //app.json = [[NSMutableDictionary alloc ] initWithContentsOfFile:dataPath ];
    NSError *error;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error: &error];
    app.json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    //NSLog(@"%@",app.json);
    app.fb=[app.json objectForKey:@"facebook"];
    if (app.fb!=nil){
        [app loginFacebook];
        return;
    }
    
    app.data=[app.json objectForKey:@"data"];
    if (app.data.count>0){
        NSMutableDictionary*d=[app.data objectAtIndex:0];
        NSMutableArray*items=[d objectForKey:@"items"];
        if (items!=nil){
            [d setObject:[NSMutableArray arrayWithArray:items] forKey:@"items"];
        }
        [self showNewsFeed];
        return;
    }
    
    
    
    
    
    //NSMutableDictionary *params = [NSMutableDictionary new];
    //https://graph.facebook.com/search?q=coffee&type=place&center=37.76,-122.427&distance=1000
    NSString *url =[[NSString stringWithFormat:@"%@%@.json",app.baseUrl,app.filename]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //self.data=[[responseObject objectForKey:@"data"]objectForKey:@"contents"];
             app.json=responseObject;
             app.data=[app.json objectForKey:@"data"];
             //NSLog(@"loadData %@",app.data);
             if (app.data.count>0){
                 NSMutableDictionary*d=[app.data objectAtIndex:0];
                 NSMutableArray*items=[d objectForKey:@"items"];
                 if (items!=nil){
                     [d setObject:[NSMutableArray arrayWithArray:items] forKey:@"items"];
                     //app.items=[NSMutableArray arrayWithArray:items];
                 }
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showNewsFeed];
                 //[self setData];
             });
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}

-(void) onChangeCategory: (NSNotification *)aNotification {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loadCategory:[app.categories objectAtIndex:app.categoryIndex]];
}

- (void) loadCategory:(NSString*)cat0{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.data removeAllObjects];
    app.pageIndex=0;
    //NSString *cat0=[app.categories objectAtIndex:app.pageIndex];
    //NSString *cat0=@"Musician/band";
    //NSString *cat0=@"Restaurant/cafe";
    for (NSMutableDictionary *d in app.alldata){
        
        NSDictionary *cover=[d objectForKey:@"cover"];
        if (cover==nil){
            continue;
        }
        NSString *cat=[d valueForKey:@"category"];
        if ([cat0 isEqual:cat]){
            NSLog(@"item %@",d);
            [app.data addObject:d];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onCategoriesLoaded"
                                                        object:self
                                                      userInfo:nil];
}

-(void) onChangePage: (NSNotification *)aNotification {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"onChangePage %d", app.pageIndex);
    if ([app.data count]){
        NSMutableDictionary*d=[app.data objectAtIndex:app.pageIndex];
        [self loadFBPosts:d];
    }else{
        //NSLog(@"onChangePage empty %d", app.pageIndex);
    }
}

- (void) loadFBId:(NSString*)fbid{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSMutableDictionary *params = [NSMutableDictionary new];
    //https://graph.facebook.com/search?q=coffee&type=place&center=37.76,-122.427&distance=1000
    //http://graph.facebook.com/168939929818827?
    
    
    NSString *url =[[NSString stringWithFormat:@"https://graph.facebook.com/%@?access_token=%@",fbid,app.fbToken]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //self.data=[[responseObject objectForKey:@"data"]objectForKey:@"contents"];
             app.json=responseObject;
             NSMutableDictionary *facebook=[NSMutableDictionary dictionaryWithDictionary:responseObject];
             app.data=[NSMutableArray arrayWithObject:facebook];
             //NSLog(@"facebook %@",facebook);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[app loginFacebook];
                 if ([fbid isEqual:@"me"]){
                     [self loadFBLikes:@"me"];
                 }else{
                     [self loadFBPosts:facebook];
                 }
             });
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}

- (void) loadFBLikes:(NSString*)fbid{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //fql?q=SELECT page_id,type, description FROM page WHERE page_id IN (SELECT uid, page_id, type FROM page_fan WHERE uid=me()) AND type='musician/band'
    //NSString*pageid=[app.fb objectForKey:@"pageid"];
    NSString *url =[[NSString stringWithFormat:@"https://graph.facebook.com/%@/likes?fields=id,name,category,cover&limit=1000&access_token=%@",fbid,app.fbToken]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //self.data=[[responseObject objectForKey:@"data"]objectForKey:@"contents"];
             
             NSArray*a=[responseObject objectForKey:@"data"];
             for (NSDictionary *d in a){
                 NSMutableDictionary*md=[NSMutableDictionary dictionaryWithDictionary:d];
                 [app.alldata addObject:md];
             }
             //app.data=[NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
             //NSLog(@"likes %@",responseObject);
             for (NSMutableDictionary *d in app.alldata){
                 NSString *cat=[d valueForKey:@"category"];
                 NSDictionary *cover=[d objectForKey:@"cover"];
                 if (cover==nil){
                     continue;
                 }

                 BOOL found = [app.categories containsObject: cat];
                 if (!found){
                     [app.categories addObject:cat];
                 }
             }
             [app.categories sortUsingSelector:@selector(caseInsensitiveCompare:)];
             //NSLog(@"app.categories %@",app.categories);
             if ([app.categories count]){
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"onChangeCategory"
                                                                     object:self userInfo:nil];
             }else{
                 //app.data=app.alldata;
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 //NSLog(@"app.data %@",app.data);
                 [self showNewsFeed];
             });
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}

- (void) loadFBPosts:(id)fb{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *fbid=[fb valueForKey:@"id"];
    if ([fb objectForKey:@"items"]!=nil){
        //NSLog(@"posts already found %@",fbid);
        return;
    }
        
    //NSMutableDictionary *params = [NSMutableDictionary new];
    //https://graph.facebook.com/search?q=coffee&type=place&center=37.76,-122.427&distance=1000
    //http://graph.facebook.com/168939929818827?
    
    //NSString*pageid=[app.fb objectForKey:@"pageid"];
    NSString *url =[[NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=posts&limit=50&access_token=%@",fbid,app.fbToken]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //self.data=[[responseObject objectForKey:@"data"]objectForKey:@"contents"];
             //NSLog(@"app.data %@",app.data);
             
             NSMutableDictionary*posts=[responseObject objectForKey:@"posts"];
             NSArray*items=[posts objectForKey:@"data"];
             if ([app.data count]){
                 //NSMutableDictionary*first=[app.data objectAtIndex:0];
                 if (items!=nil){
                     [fb setObject:items forKey:@"items"];
                     //app.items=[NSMutableArray arrayWithArray:items];
                     
                     for (NSDictionary*d in items){
                         NSString*o=[d valueForKey:@"object_id"];
                         
                         NSString*t=[d valueForKey:@"type"];
                         //NSLog(@"item %@",d);
                         if (o !=nil){
                             //NSLog(@"object_id %@",o);
                             if ([t isEqual:@"photo"]){
                                 [self loadFBObject:o];
                             }
                         }else{
                             //NSLog(@"object_id nil");
                         }
                     }
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"onPostsLoaded"
                                                                         object:self
                                                                       userInfo:nil];

                 }else{
                     NSLog(@"nopost %@",responseObject);
                     NSLog(@"nopost %@",fb);

                 }
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 //NSLog(@"app.data %@",app.data);
                 [self showNewsFeed];
             });
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}

- (void) addFBLoginView{
    self.loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    
    int dy=self.view.frame.size.height/2 +100;
    self.loginView.frame = CGRectOffset(self.loginView.frame, (self.view.center.x - (self.loginView.frame.size.width / 2)), dy);
    [self.view addSubview:self.loginView];
    self.loginView.delegate=self;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //NSLog(@"You're logged in as");
    [self.loginView setHidden:YES];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"Access Token %@", [[FBSession.activeSession accessTokenData] accessToken]);
    
    app.fbToken=[[FBSession.activeSession accessTokenData] accessToken];
    //NSLog(@"Facebook Login token %@ ",app.fbToken);
    NSString*fbid=[app.fb objectForKey:@"pageid"];
    
    [self loadFBId:fbid];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    //NSLog(@"You're not logged in!");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    //NSLog(@"loginViewFetchedUserInfo  found %@",user);
    [self.loginView setHidden:YES];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void) loadFBObject:(NSString*) oid{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSString*pageid=[app.fb objectForKey:@"pageid"];
    if ([app.fbObjects objectForKey:oid]){
        //NSLog(@"loadFBObject already found %@",oid);
        return;
    }
    
    NSString *url =[[NSString stringWithFormat:@"https://graph.facebook.com/%@",oid]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [app.fbObjects setObject:responseObject forKey:oid];
             //NSLog(@"loadFBObject %@",responseObject);
             //NSLog(@"fbObjects count %d",[app.fbObjects count]);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //NSLog(@"loadFBObjectError %@",oid);
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}


- (void) showNewsFeed{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!app.opened){
        app.opened=true;
        app.mainViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:app.mainViewController animated:YES completion:nil];
    }
}

@end
