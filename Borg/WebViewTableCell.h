

#import <UIKit/UIKit.h>

@interface WebViewTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (WebViewTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (WebViewTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
