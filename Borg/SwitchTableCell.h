

#import <UIKit/UIKit.h>

@interface SwitchTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (SwitchTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (SwitchTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UISwitch *switch0;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
