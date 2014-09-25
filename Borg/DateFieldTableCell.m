
#import "DateFieldTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@interface DateFieldTableCell (){
}
@end

@implementation DateFieldTableCell
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (DateFieldTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    DateFieldTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[DateFieldTableCell class]]) {
            customCell = (DateFieldTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (DateFieldTableCell *)cellFromTable:(UITableView *)tableView :(NSDate*)date {
    DateFieldTableCell * cell = (DateFieldTableCell *)[DateFieldTableCell cellFromNibNamed:@"DateFieldTableCell"];
    cell.datePicker = [[UIDatePicker alloc] init];
    if (date!=nil){
        cell.date=date;
    }else{
        cell.date=[NSDate date];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.datePicker.date=cell.date;
    cell.datePicker.datePickerMode = UIDatePickerModeDate;
    cell.textField.inputView=cell.datePicker;
    cell.textField.text=[cell.date toSqlShort];
    [cell.datePicker addTarget:cell action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    return cell;
}

- (void)datePickerValueChanged:(id)sender{
    UIDatePicker*datePicker=(UIDatePicker*)sender;
    self.date =datePicker.date;
    self.textField.text=[self.date toSqlShort];
    NSLog(@"datePickerValueChanged 1 %@ ",self.date);
}


@end
