#import <UIKit/UIKit.h>

@interface DateFieldTableCell : UITableViewCell{
    
}

+ (DateFieldTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (DateFieldTableCell *)cellFromTable:(UITableView *)tableView :(NSDate*)data ;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate* date;


@end
