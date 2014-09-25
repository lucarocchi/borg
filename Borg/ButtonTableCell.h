

#import <UIKit/UIKit.h>

@interface ButtonTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (ButtonTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (ButtonTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
