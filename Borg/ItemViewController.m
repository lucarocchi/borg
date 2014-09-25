//
//  ItemViewController.m
//  Scribbis
//
//  Created by Luca Rocchi on 30/04/14.
//  Copyright (c) 2014 tbtv. All rights reserved.
//

#import "ItemViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "Item1TableCell.h"
#import "DescriptionTableCell.h"
#import "ImageTableCell.h"
#import "TextViewTableCell.h"
#import "CommentTableCell.h"
#import "ButtonTableCell.h"
#import "WebViewTableCell.h"
#import "ODRefreshControl.h" 
#import "SummaryTableCell.h"
#import "WebViewController.h"

//#define OFFSET 6
@interface ItemViewController (){
}
@property int commentsOffset;
@end

@implementation ItemViewController

-(id)initWithData:(NSMutableDictionary*)data{
    self = [super init];
    if (self) {
        // Custom initialization
        self.data=[NSMutableDictionary dictionaryWithDictionary:data];
    }
    return self;
}

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.commentsOffset=7;
    //ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    //[refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self.indicatorView setHidden:YES];
    
    NSString *fbid=[self.data valueForKey:@"id"];
    NSLog(@"self.data id %@",fbid);
    
    
    NSDictionary*comments=[self.data objectForKey:@"comments"];
    NSArray*commentsData=[comments objectForKey:@"data"];
    NSDictionary*likes=[self.data objectForKey:@"likes"];
    NSArray*likesData=[likes objectForKey:@"data"];
    
    int commentsCount=[commentsData count];
    int likesCount=[likesData count];
    if (likesCount>=25 || commentsCount>=25){
        [self loadFBSummary:fbid];
    }
    NSLog(@"counts %d %d",likesCount,commentsCount);

}

- (void) loadFBSummary:(NSString*) oid{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *url =[[NSString stringWithFormat:@"https://graph.facebook.com/%@?access_token=%@&fields=comments.limit(1).summary(true),likes.limit(1).summary(true)",oid,app.fbToken]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [app.fbObjects setObject:responseObject forKey:oid];
             NSLog(@"loadFBSummary %@",responseObject);
             [self.data setObject:responseObject forKey:@"summary"];
             [self.tableView reloadData];
             //NSLog(@"fbObjects count %d",[app.fbObjects count]);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"loadFBObjectError %@",oid);
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"We scrolled! Offset now is %f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-50){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary*comments=[self.data objectForKey:@"comments"];
    NSArray*data=[comments objectForKey:@"data"];
    int cc=(int)[data count];
    return self.commentsOffset +cc+1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (UIView *)tableView : (UITableView *)tableView viewForHeaderInSection : (NSInteger) section {
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    long index=indexPath.row;
    //int section=indexPath.section;
    int c= 80;
    //int category_id=[[self.data valueForKey:@"category_id"] intValue];
    if (index==0){
        NSDictionary* from=[self.data objectForKey:@"from"];
        if (from){
            return 70;
        }
        return 0;
    }
    if (index==1){
        NSString * story=[self.data valueForKey:@"story"];
        if (story==nil){
            story=[self.data valueForKey:@"name"];
        }
        if (story!=nil){
            float h=[app getLabelHeight:story withFont:@"HelveticaNeue-CondensedBold" Size:16 andWidth:300];
            return h+20;
        }
        return 0;
    }
    if (index==2){
        NSString *caption=[self.data valueForKey:@"caption"];
        //if (caption==nil){
        //    caption=[self.data valueForKey:@"name"];
        //}
        if (caption!=nil){
            float h=[app getLabelHeight:caption withFont:@"HelveticaNeue-CondensedBold" Size:16 andWidth:300];
            return h+20;
        }
        return 0;
    }
    if (index==3){
        NSString * message=[self.data valueForKey:@"message"];
        if (message!=nil){
            float h=[app getLabelHeight:message withFont:@"HelveticaNeue-Light" Size:14 andWidth:300];
            return h+20;
        }
        return 0;
    }
    if (index==4){
        NSString * photo=[self.data valueForKey:@"picture"];
        NSString *object_id=[self.data objectForKey:@"object_id"];
        if (object_id != nil){
            NSDictionary *o=[app.fbObjects objectForKey:object_id];
            if ( o!=nil){
                NSArray *images=[o objectForKey:@"images"];
                //if (images)
                NSDictionary *image=[images objectAtIndex:0];
                NSLog(@"image %@",image);
                //NSString *source=[image valueForKey:@"source"];
                NSInteger height=[[image valueForKey:@"height"] integerValue];
                NSInteger width=[[image valueForKey:@"width"] integerValue];
                NSLog(@"cell object %@",o);
                float h=height*(300.0f/width);
                return h+10;
            }
        }

        if (!([photo isEqual:[NSNull null]])&&(photo!=nil)){
            return 300;
        }
        return 0;
    }
    /*if (index==3){
        NSString * iframe=[self.data valueForKey:@"external"];
        if (category_id ==4 || category_id==15){
            return 0;
        }
        if (!([iframe isEqual:[NSNull null]])&&(iframe!=nil)){
            return 200;
        }
        return 0;
    }
    if (index==4){
        return 50;
    }*/
    if (index==5){
        return 50;
    }
    if (index==6){
        return 80;
    }
    NSDictionary*comments=[self.data objectForKey:@"comments"];
    NSArray*commentsData=[comments objectForKey:@"data"];
    int cc=(int)[commentsData count];
    if (index==self.commentsOffset +cc){
        return 320;
    }
    
    
    if (index>=self.commentsOffset){
        //NSLog(@"heightForRowAtIndexPath %d",indexPath.row);
        NSDictionary*comment=[commentsData objectAtIndex:index-self.commentsOffset];
        float h=[app getLabelHeight:[comment valueForKey:@"message"] withFont:@"HelveticaNeue-Light" Size:13  andWidth:300];
        return h+80;
    }
   
    return c;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    long index=indexPath.row;
    //int section=indexPath.section;
    
    if (index==0){
        //NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        Item1TableCell *cell=[Item1TableCell cellFromTable:self.tableView :self.data];
        
        NSDictionary* from=[self.data objectForKey:@"from"];
        NSString *fromPicture=[NSString stringWithFormat:@"%@%@/picture?type=large",@FBG,[from valueForKey:@"id"] ];

        
        cell.categoryLabel.text=[self.data valueForKey:@"category_title"];
        cell.userLabel.text=[from valueForKey:@"name"];
        //cell.addressLabel.text=[self.data valueForKey:@"name"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        //2010-12-01T21:35:43+0000
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        NSString *created_time=[self.data valueForKey:@"created_time"];
        NSDate *date = [df dateFromString:created_time];
        [df setDateFormat:@"eee MMM dd, yyyy hh:mm"];
        [df setLocale: [NSLocale currentLocale]];
        NSString *dateStr = [df stringFromDate:date];
        cell.dateLabel.text=dateStr;
        
        //NSString * avatar=[self.data valueForKey:@"user_avatar"];
        //if (!([avatar isEqual:[NSNull null]])&&(avatar!=nil)){
            NSString* encodedurl = [fromPicture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL*url  = [NSURL URLWithString:encodedurl];
            [cell.userImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"] ];
        //}
        
       /* NSString * slug=[self.data valueForKey:@"category_slug"];
        NSString * color=[app.categories valueForKey:slug];
        NSLog(@"scrib %@ %@",slug ,color);
        [cell.headerView setBackgroundColor:[app colorFromHexString:color]];
        NSString *imageName=[NSString stringWithFormat:@"icon-cat-32-%@",slug];
        [cell.categoryImage setImage:[UIImage imageNamed:imageName]];
        */
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [cell.closeButton addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    if (index==1){
        //NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        NSString * story=[self.data valueForKey:@"story"];
        if (story==nil){
            story=[self.data valueForKey:@"name"];
        }
        if (story==nil){
            story=[self.data valueForKey:@"type"];
        }
        DescriptionTableCell *cell=[DescriptionTableCell cellFromTable:self.tableView :self.data];
        cell.descriptionLabel.text=story;
        [cell.descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (index==2){
        //NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        DescriptionTableCell *cell=[DescriptionTableCell cellFromTable:self.tableView :self.data];
        NSString *caption=[self.data valueForKey:@"caption"];
        //if (caption==nil){
        //    caption=[self.data valueForKey:@"name"];
        //}
        cell.descriptionLabel.text=caption;
        [cell.descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    if (index==3){
        //NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        DescriptionTableCell *cell=[DescriptionTableCell cellFromTable:self.tableView :self.data];
        cell.descriptionLabel.text=[self.data valueForKey:@"message"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (index==4){
        //NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        ImageTableCell *cell=[ImageTableCell cellFromTable:self.tableView :self.data];
        NSString * photo=[self.data valueForKey:@"picture"];
        if (!([photo isEqual:[NSNull null]])&&(photo!=nil)){
            //NSString* encodedurl = [photo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL*url  = [NSURL URLWithString:photo];
            [cell.imageView setImageWithURL:url placeholderImage:nil ];
        }
        NSString *object_id=[self.data objectForKey:@"object_id"];
        if (object_id != nil){
            NSDictionary *o=[app.fbObjects objectForKey:object_id];
            if ( o!=nil){
                NSArray *images=[o objectForKey:@"images"];
                //if (images)
                NSDictionary *image=[images objectAtIndex:0];
                NSLog(@"image %@",image);
                NSString*source=[image valueForKey:@"source"];
                [cell.imageView setImageWithURL:[NSURL URLWithString:source] placeholderImage:nil];
                NSLog(@"cell object %@",o);
            }else{
                //[self loadFBObject:object_id withImage:cell.imageView];
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    /*
    if (index==3){
        NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        WebViewTableCell *cell=[WebViewTableCell cellFromTable:self.tableView :self.data];
        NSString * iframe=[self.data valueForKey:@"external"];
        if (!([iframe isEqual:[NSNull null]])&&(iframe!=nil)){
            [cell.webView loadHTMLString:iframe baseURL:nil];
            cell.webView.scrollView.scrollEnabled = NO;
            cell.webView.scrollView.bounces = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (index==4){
        NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        ButtonTableCell *cell=[ButtonTableCell cellFromTable:self.tableView :self.data];
        [cell.button setTitle:@"Share" forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(doShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
     */
    NSDictionary*comments=[self.data objectForKey:@"comments"];
    NSArray*commentsData=[comments objectForKey:@"data"];
    //NSDictionary*likes=[self.data objectForKey:@"likes"];
    //NSArray*likesData=[comments objectForKey:@"data"];
    
    if (index==5){
        SummaryTableCell *cell=[SummaryTableCell cellFromTable:self.tableView :self.data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    if (index==6){
        //NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        TextViewTableCell *cell=[TextViewTableCell cellFromTable:self.tableView :nil];
        //int cc=(int)[commentsData count];
        
        [cell.button setHidden:NO];
        [cell.button setTitle:NSLocalizedString(@"+",nil) forState:UIControlStateNormal];
        cell.label.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Comments",nil)];
        //[cell.button addTarget:self action:@selector(formPost:) forControlEvents:UIControlEventTouchUpInside];
        self.textView=cell.textView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    int cc=(int)[commentsData count];
    if (index>=self.commentsOffset && index<self.commentsOffset +cc){
        //NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
        CommentTableCell *cell=[CommentTableCell cellFromTable:self.tableView :self.data];
        NSDictionary*comment=[commentsData objectAtIndex:index-self.commentsOffset];
        NSDictionary*from=[comment objectForKey:@"from"];
        //NSLog(@"comment %@",comment);
        cell.userLabel.text=[from valueForKey:@"name"];
        
        cell.dateLabel.text=[comment valueForKey:@"created_time"];
        
        cell.descriptionLabel.text=[comment valueForKey:@"message"];
        
        NSString *fromPicture=[NSString stringWithFormat:@"%@%@/picture?type=large",@FBG,[from valueForKey:@"id"] ];
        
        //NSString * avatar=[comment valueForKey:@"user_avatar"];
        //if (!([avatar isEqual:[NSNull null]])&&(avatar!=nil)){
            NSString* encodedurl = [fromPicture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL*url  = [NSURL URLWithString:encodedurl];
            [cell.userImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"] ];
        //}
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    NSString *cellIdentifier = @"defaultCellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    cell.textLabel.text = @"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(IBAction) doCancel:(id) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	int index=(int)indexPath.row ;
    
    if (index>1 && index<=3){
        NSString *link=[self.data objectForKey:@"link"];
        if (link!=nil){
            WebViewController *wv = [[WebViewController alloc] initWithUrlName:link andTitle:nil];
            wv.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:wv animated:YES completion:nil];
        }
    }
}


- (void)doShare:(id)sender {
    float deviceVersion   = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString* url=[NSString stringWithFormat:@"http://www.scribbis.com/en#!/content/%@",[self.data objectForKey:@"content_id"]];
    
    //http://www.scribbis.com/en#!/content/730
    
    NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (deviceVersion>=6.0){
        UIActivityViewController*activityViewController = [[UIActivityViewController alloc]                                       initWithActivityItems:@[eurl] applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
    }else{
    }
}

/*
-(IBAction) formPost:(id) sender{

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *insertUrl =[[NSString stringWithFormat:@"%@content/add-comment",APPURL]
                          stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *uid=[app.session valueForKey:@"id"];
    [params setObject:APPID forKey:@"__api_app_id"];
    [params setObject:APPSECRET forKey:@"__api_app_secret"];
    [params setObject:app.session_id forKey:@"__api_app_session"];
    [params setObject:uid forKey:@"__user_id"];
    [params setObject:uid forKey:@"userId"];
    [params setObject:@"1" forKey:@"__user_api_key"];
    [params setObject: [self.data objectForKey:@"category_id"] forKey:@"category_id"];
    [params setObject: [self.data objectForKey:@"content_id"] forKey:@"content_id"];
    [params setObject: self.textView.text forKey:@"comment"];
    
    
    NSLog(@"params %@",params);
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:insertUrl
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //self.data=[[responseObject objectForKey:@"data"]objectForKey:@"contents"];
              NSLog(@"commentadd %@",responseObject);
              NSString*result=[responseObject objectForKey:@"result"];
              if ([result isEqual:@"ok"]){
                  //[self dismissViewControllerAnimated:YES completion:nil];
                  NSMutableDictionary*comment=[NSMutableDictionary dictionary];
                  [comment setValue:self.textView.text forKey:@"comment" ];
                  [comment setValue:[app.session valueForKey:@"id"]  forKey:@"user_id" ];
                  [comment setValue:[app.session valueForKey:@"avatar"]  forKey:@"user_avatar" ];
                  [comment setValue:@"now"  forKey:@"date_human" ];
                  [comment setValue:[app.session valueForKey:@"user_name"]  forKey:@"user_name" ];
                  
                  
                  NSMutableArray * comments=[NSMutableArray arrayWithArray:[self.data objectForKey:@"comments"] ];
                  [comments insertObject:comment atIndex:0];
                  [self.data setObject:comments forKey:@"comments"];
                  [self.tableView reloadData];

              }else{
                  NSArray*m0=[responseObject objectForKey:@"messages"];
                  NSDictionary*d=[m0 objectAtIndex:0];
                  NSString*error=[d objectForKey:@"message"];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                      [popup show];
                  });
              }
              [self.indicatorView setHidden:YES];
              [self.indicatorView stopAnimating];
              
              //[self dismissViewControllerAnimated:YES completion:nil];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"commentadd Error: %@", error);
              dispatch_async(dispatch_get_main_queue(), ^{
                  UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                  [popup show];
              });
              [self.indicatorView setHidden:YES];
              [self.indicatorView stopAnimating];
              
              
          }];
    
}
*/

- (void) loadFBObject:(NSString*) oid withImage:(UIImageView*) imageView{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //NSString*pageid=[app.fb objectForKey:@"pageid"];
    
    NSString *url =[[NSString stringWithFormat:@"https://graph.facebook.com/%@",oid]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"loadFBObject %@",oid);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [app.fbObjects setObject:responseObject forKey:oid];
             //NSLog(@"fbObjects count %d",[app.fbObjects count]);
             NSArray *images=[responseObject objectForKey:@"images"];
             //if (images)
             NSDictionary *image=[images objectAtIndex:0];
             //NSLog(@"image %@",image);
             NSString*source=[image valueForKey:@"source"];
             [imageView setImageWithURL:[NSURL URLWithString:source] placeholderImage:nil];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"loadFBObjectError %@",oid);
             NSLog(@"loadData Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 //[popup show];
             });
         }];
    
}


@end
