

#import <UIKit/UIKit.h>

@interface SummaryTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (SummaryTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (SummaryTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
