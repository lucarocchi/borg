
#import "SwitchTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation SwitchTableCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SwitchTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SwitchTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SwitchTableCell class]]) {
            customCell = (SwitchTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (SwitchTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    SwitchTableCell * cell = (SwitchTableCell *)[SwitchTableCell cellFromNibNamed:@"SwitchTableCell"];
    return cell;
}


@end
