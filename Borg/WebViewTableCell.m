
#import "WebViewTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"  

@implementation WebViewTableCell

@synthesize webView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WebViewTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    WebViewTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[WebViewTableCell class]]) {
            customCell = (WebViewTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (WebViewTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    WebViewTableCell * cell = (WebViewTableCell *)[WebViewTableCell cellFromNibNamed:@"WebViewTableCell"];
    return cell;
}


@end
