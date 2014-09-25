

#import <UIKit/UIKit.h>

@interface DescriptionTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (DescriptionTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (DescriptionTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
