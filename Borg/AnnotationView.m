

#import "AnnotationView.h"
#import "MapItem.h"


@implementation AnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(30.0, 30.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(15, 15);
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}

/*- (void)drawRect:(CGRect)rect
{
    JobMapItem *jobItem = (JobMapItem *)self.annotation;
    if (jobItem != nil)
    {

        //NSInteger high = [jobItem.high integerValue];
        //NSInteger low = [jobItem.low integerValue];

        // draw the temperature string and weather graphic
        //NSString *temperature = [NSString stringWithFormat:@"%@\n%d / %d", jobItem.place, high, low];
        //[[UIColor blackColor] set];
        //[temperature drawInRect:CGRectMake(15.0, 5.0, 50.0, 40.0) withFont:[UIFont systemFontOfSize:11.0]];
        
        NSString *imageName = @"icon58";

        [[UIImage imageNamed:imageName] drawInRect:CGRectMake(0,0, 30, 30)];
         
    }
}*/

@end
