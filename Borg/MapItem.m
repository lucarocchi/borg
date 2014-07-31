
#import "MapItem.h"

@implementation MapItem 

@synthesize  title;
@synthesize  data;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self->latitude;
    coordinate.longitude = self->longitude;
    return coordinate; 
}

@end
