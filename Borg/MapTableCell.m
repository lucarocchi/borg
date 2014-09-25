
#import "MapTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation MapTableCell

@synthesize mapView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (MapTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    MapTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[MapTableCell class]]) {
            customCell = (MapTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (MapTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    MapTableCell * cell = (MapTableCell *)[MapTableCell cellFromNibNamed:@"MapTableCell"];
    return cell;
}


@end
