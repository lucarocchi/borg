

#import <UIKit/UIKit.h>

@interface ImageTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (ImageTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (ImageTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
