
#import "TextViewTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation TextViewTableCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (TextViewTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    TextViewTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[TextViewTableCell class]]) {
            customCell = (TextViewTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (TextViewTableCell *)cellFromTable:(UITableView *)tableView :(NSString*)value {
    TextViewTableCell * cell = (TextViewTableCell *)[TextViewTableCell cellFromNibNamed:@"TextViewTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (value!= nil){
        cell.value=value;
        cell.textView.text=cell.value;
    }

    return cell;
}


@end
