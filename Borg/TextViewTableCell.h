

#import <UIKit/UIKit.h>

@interface TextViewTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (TextViewTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (TextViewTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSString *value;


@end
