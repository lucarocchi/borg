
#import "DescriptionTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation DescriptionTableCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (DescriptionTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    DescriptionTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[DescriptionTableCell class]]) {
            customCell = (DescriptionTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (DescriptionTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    DescriptionTableCell * cell = (DescriptionTableCell *)[DescriptionTableCell cellFromNibNamed:@"DescriptionTableCell"];
    return cell;
}


@end
