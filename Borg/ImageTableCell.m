
#import "ImageTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation ImageTableCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (ImageTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ImageTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ImageTableCell class]]) {
            customCell = (ImageTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (ImageTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    ImageTableCell * cell = (ImageTableCell *)[ImageTableCell cellFromNibNamed:@"ImageTableCell"];
    return cell;
}


@end
