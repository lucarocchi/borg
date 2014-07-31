

#import "WebViewController.h"


@implementation WebViewController
@synthesize webView;
@synthesize urlAddress;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        webView=[[UIWebView alloc] init];
    }
    return self;
}*/

- (id)initWithUrlName:(NSString *)url andTitle:title{
    self = [super initWithNibName:@"WebViewController" bundle:[NSBundle mainBundle]];
	urlAddress=url;
    if (self) {
        self.title = title;// NSLocalizedString(@"CallsKey", @"");
        //self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0]autorelease];
        //self.tabBarItem.image = [UIImage imageNamed:@"gear"];
        //self.tabBarItem.title = @"Info";//NSLocalizedString(@"CallsKey", @"");
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"We scrolled! Offset now is %f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-50){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.webView.delegate=self;
    if (urlAddress.length){
        //NSURL *url = [NSURL fileURLWithPath:urlAddress];
        NSURL *url=[NSURL URLWithString:urlAddress];
        NSURLRequest*requestObj=[NSURLRequest requestWithURL:url];
        //[self.webView loadData:MIMEType:@"utf8" :baseURL:url];
        [self.webView loadRequest:requestObj];
        //self.webView.delegate=self;
        [self.webView.scrollView setDelegate:self];
    }
}
-(IBAction) doCancel:(id) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //    return YES;
    //}
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)webViewDidStartLoad:(UIWebView *)webview {
    //NSLog(@"webViewDidStartLoad");
	//NSLog(webView.request.URL.absoluteString);
    //[HUD show:TRUE];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview  {
    //NSLog(@"webViewDidFinishLoad");
}

#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = barButtonItem ;   
    // Add the popover button to the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    //[itemsArray insertObject:barButtonItem atIndex:0];
    //[toolbar setItems:itemsArray animated:NO];
    //[itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = nil ;   
    
    // Remove the popover button from the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    //[itemsArray removeObject:barButtonItem];
    //[toolbar setItems:itemsArray animated:NO];
    //[itemsArray release];
}
- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
