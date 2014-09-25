

#import <UIKit/UIKit.h>

@interface HeaderTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (HeaderTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (HeaderTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
