
#import "SexFieldTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@interface SexFieldTableCell (){
}
@end

@implementation SexFieldTableCell
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SexFieldTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SexFieldTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SexFieldTableCell class]]) {
            customCell = (SexFieldTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (SexFieldTableCell *)cellFromTable:(UITableView *)tableView :(NSString*)value {
    SexFieldTableCell * cell = (SexFieldTableCell *)[SexFieldTableCell cellFromNibNamed:@"SexFieldTableCell"];
    cell.picker = [[UIPickerView alloc] init];
    cell.picker.delegate=cell;
    cell.textField.inputView=cell.picker;
    cell.label.text=NSLocalizedString(@"Sex", nil);
    cell.textField.placeholder=@"M/F";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (value!= nil){
        if ([value isEqual:@"M"]){
            cell.textField.text=NSLocalizedString(@"Male", nil);
        }
        if ([value isEqual:@"F"]){
            cell.textField.text=NSLocalizedString(@"Female", nil);
        }
        cell.value=value;
    }

    return cell;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row==0)
        return NSLocalizedString(@"Male", nil);
    return NSLocalizedString(@"Female", nil);;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row==0){
        self.textField.text= NSLocalizedString(@"Male", nil);
        self.value=@"M";
    }else{
        self.textField.text=NSLocalizedString(@"Female", nil);
        self.value=@"F";
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

@end
