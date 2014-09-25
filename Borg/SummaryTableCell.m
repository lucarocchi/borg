
#import "SummaryTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Utilities.h"

@implementation SummaryTableCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SummaryTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SummaryTableCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SummaryTableCell class]]) {
            customCell = (SummaryTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

+ (SummaryTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data {
    SummaryTableCell * cell = (SummaryTableCell *)[SummaryTableCell cellFromNibNamed:@"SummaryTableCell"];
    
    
    cell.label1.text=@"";
    cell.label2.text=@"";

    
    
    //NSString *fbid=[data valueForKey:@"id"];
    NSDictionary*comments=[data objectForKey:@"comments"];
    NSArray*commentsData=[comments objectForKey:@"data"];
    NSDictionary*likes=[data objectForKey:@"likes"];
    NSArray*likesData=[likes objectForKey:@"data"];
    
    int commentsCount=[commentsData count];
    int likesCount=[likesData count];

    NSDictionary*summary=[data objectForKey:@"summary"];
    if (summary !=nil){
        comments=[summary objectForKey:@"comments"];
        commentsCount=[[[comments objectForKey:@"summary"] valueForKey:@"total_count"] integerValue];
        likes=[summary objectForKey:@"likes"];
        likesCount=[[[likes objectForKey:@"summary"] valueForKey:@"total_count"] integerValue];
    }

    
    NSString*commentText=nil;
    NSString*likeText=nil;
    if (commentsCount==1){
        commentText=[NSString stringWithFormat:@"%ld %@",(unsigned long)commentsCount,NSLocalizedString(@"Comment",nil)];
    }
    if (commentsCount>1){
        commentText=[NSString stringWithFormat:@"%ld %@",(unsigned long)commentsCount,NSLocalizedString(@"Comments",nil)];
    }
    if (likesCount==1){
        likeText=[NSString stringWithFormat:@"%ld %@",(unsigned long)likesCount,NSLocalizedString(@"Like",nil)];
    }
    if (likesCount>1){
        likeText=[NSString stringWithFormat:@"%ld %@",(unsigned long)likesCount,NSLocalizedString(@"Likes",nil)];
    }
    NSString*text1=@"";
    NSString*text2=@"";
    if (commentText!=nil){
        text1=commentText;
    }
    if (likeText!=nil){
        text1=likeText;
    }
    
    if (likeText!=nil && commentText!=nil){
        text1=[NSString stringWithFormat:@"%@ %@",likeText,commentText];
        text1=likeText;
        text2=commentText;
    }
    
    cell.label1.text=text1;
    cell.label2.text=text2;
    
    return cell;
}


@end
