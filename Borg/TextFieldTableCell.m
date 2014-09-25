
#import "TextFieldTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation TextFieldTableCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (TextFieldTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    TextFieldTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[TextFieldTableCell class]]) {
            customCell = (TextFieldTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (TextFieldTableCell *)cellFromTable:(UITableView *)tableView :(NSString*)value {
    TextFieldTableCell * cell = (TextFieldTableCell *)[TextFieldTableCell cellFromNibNamed:@"TextFieldTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (value!= nil){
        cell.value=value;
        cell.textField.text=cell.value;
    }
    return cell;
}


@end
