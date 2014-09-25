#import <UIKit/UIKit.h>

@interface SexFieldTableCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>{
    
}

+ (SexFieldTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (SexFieldTableCell *)cellFromTable:(UITableView *)tableView :(NSString*)value ;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) NSString *value;


@end
