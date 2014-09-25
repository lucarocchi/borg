
#import "CommentTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation CommentTableCell
@synthesize userImage;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CommentTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    CommentTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[CommentTableCell class]]) {
            customCell = (CommentTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (CommentTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    CommentTableCell * cell = (CommentTableCell *)[CommentTableCell cellFromNibNamed:@"CommentTableCell"];
    return cell;
}


@end
