
#import "HeaderTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation HeaderTableCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HeaderTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    HeaderTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[HeaderTableCell class]]) {
            customCell = (HeaderTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (HeaderTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    HeaderTableCell * cell = (HeaderTableCell *)[HeaderTableCell cellFromNibNamed:@"HeaderTableCell"];
    return cell;
}


@end
