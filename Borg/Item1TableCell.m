
#import "Item1TableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation Item1TableCell
@synthesize userImage;
@synthesize categoryImage;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Item1TableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    Item1TableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[Item1TableCell class]]) {
            customCell = (Item1TableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (Item1TableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    Item1TableCell * cell = (Item1TableCell *)[Item1TableCell cellFromNibNamed:@"Item1TableCell"];
    return cell;
}


@end
