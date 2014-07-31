
#import "SectionView.h"
#import "UIImageView+WebCache.h"

@implementation SectionView

@synthesize imageView;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SectionView *)viewFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SectionView *customView = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SectionView class]]) {
            customView = (SectionView *)nibItem;
            break; // we have a winner
        }
    }
    return customView;
}

+ (SectionView *)viewFromData:(NSDictionary*)data {
    SectionView * view = (SectionView *)[SectionView viewFromNibNamed:@"SectionView"];
    
    NSDictionary *cover=[data objectForKey:@"cover" ] ;
    if (cover!=nil){
        NSString *source=[cover objectForKey:@"source"];
        [view.imageView setImageWithURL:[NSURL URLWithString:source] placeholderImage:nil];
        [view.labelTitle setText:[data objectForKey:@"name" ]];
        [view.labelCategory setText:[data objectForKey:@"category" ]];
    }
    
    
    return view;
}


@end
