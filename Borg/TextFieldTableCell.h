

#import <UIKit/UIKit.h>

@interface TextFieldTableCell : UITableViewCell {
}

+ (TextFieldTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (TextFieldTableCell *)cellFromTable:(UITableView *)tableView :(NSString*)value ;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSString *value;


@end
