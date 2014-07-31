//
//  SimpleWebViewController.h
//  Nokiaplay
//
//  Created by luca rocchi on 18/02/11.
//  Copyright 2011 hhhhh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate> {
	 NSString *urlAddress;
}
- (id)initWithUrlName:(NSString *)url andTitle:title;
-(IBAction) doCancel:(id) sender;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *urlAddress;

@end
