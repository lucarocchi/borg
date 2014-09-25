
#import "ButtonTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation ButtonTableCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (ButtonTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ButtonTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ButtonTableCell class]]) {
            customCell = (ButtonTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (ButtonTableCell *)cellFromTable:(UITableView *)tableView :(NSString*)value {
    ButtonTableCell * cell = (ButtonTableCell *)[ButtonTableCell cellFromNibNamed:@"ButtonTableCell"];
    
    cell.button.layer.cornerRadius = 5;
    //[cell.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIColor *c1=[UIColor colorWithRed:248/255.0 green:149/255.0 blue:10/255.0 alpha:1.0];
    UIColor *c2=[UIColor colorWithRed:250/255.0 green:177/255.0 blue:73/255.0 alpha:1.0];
    
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)c2.CGColor,
                       (id)c1.CGColor,
                       nil];
    [layer setColors:colors];
    [layer setFrame:cell.button.bounds];
    //[cell.button.layer insertSublayer:layer atIndex:0];
    cell.button.clipsToBounds = YES;
    
    
    
    return cell;
}


@end
