//
//  RootViewController.m
//  JoinJob
//
//  Created by Luca Rocchi on 18/01/14.
//  Copyright (c) 2014 joinjob. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "AFNetworking.h"


@interface RootViewController ()
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
    NSLog(@"%@",app.json);
    app.fb=[app.json objectForKey:@"facebook"];
    if (app.fb!=nil){
        [self loadFBId];
        return;
    }
    
    app.data=[app.json objectForKey:@"data"];
    if (app.data.count>0){
        NSMutableDictionary*d=[app.data objectAtIndex:0];
        NSMutableArray*items=[d objectForKey:@"items"];
        if (items!=nil){
            app.items=[NSMutableArray arrayWithArray:items];
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
                     app.items=[NSMutableArray arrayWithArray:items];
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



- (void) loadFBId{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSMutableDictionary *params = [NSMutableDictionary new];
    //https://graph.facebook.com/search?q=coffee&type=place&center=37.76,-122.427&distance=1000
    //http://graph.facebook.com/168939929818827?
    
    NSString*pageid=[app.fb objectForKey:@"pageid"];
    
    NSString *url =[[NSString stringWithFormat:@"http://graph.facebook.com/%@",pageid]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //self.data=[[responseObject objectForKey:@"data"]objectForKey:@"contents"];
             app.json=responseObject;
             NSMutableDictionary *facebook=[NSMutableDictionary dictionaryWithDictionary:responseObject];
             app.data=[NSMutableArray arrayWithObject:facebook];
             NSLog(@"facebook %@",facebook);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[self setData];
                 [app loginFacebook];
                 
             });
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}

- (void) loadFBPosts{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSMutableDictionary *params = [NSMutableDictionary new];
    //https://graph.facebook.com/search?q=coffee&type=place&center=37.76,-122.427&distance=1000
    //http://graph.facebook.com/168939929818827?
    
    NSString*pageid=[app.fb objectForKey:@"pageid"];
    NSString *url =[[NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=posts&access_token=%@",pageid,app.fbToken]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //self.data=[[responseObject objectForKey:@"data"]objectForKey:@"contents"];
             //NSLog(@"app.data %@",app.data);
             
             NSDictionary*posts=[responseObject objectForKey:@"posts"];
             NSArray*items=[posts objectForKey:@"data"];
             NSMutableDictionary*first=[app.data objectAtIndex:0];
             [first setObject:items forKey:@"items"];
             app.items=[NSMutableArray arrayWithArray:items];
             
             for (NSDictionary*d in app.items){
                 NSLog(@"object_id %@",[d valueForKey:@"object_id"]);
                 NSString*o=[d valueForKey:@"object_id"];
                 NSString*t=[d valueForKey:@"type"];
                 NSLog(@"type %@",t);
                 if ([t isEqual:@"photo"]){
                     [self loadFBObject:o];
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

- (void) loadFBObject:(NSString*) oid{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //NSString*pageid=[app.fb objectForKey:@"pageid"];
    NSString *url =[[NSString stringWithFormat:@"https://graph.facebook.com/%@",oid]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"loadFBObject %@",oid);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [app.fbObjects setObject:responseObject forKey:oid];
             NSLog(@"fbObjects count %d",[app.fbObjects count]);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"loadFBObjectError %@",oid);
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}


- (void) showNewsFeed{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.mainViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:app.mainViewController animated:YES completion:nil];
}

@end
