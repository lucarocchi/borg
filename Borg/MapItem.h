
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>



@interface MapItem : NSObject <MKAnnotation>
{
    NSDictionary *place;
    NSNumber *low;
    NSNumber *high;
    NSNumber *condition;
    
    CLLocationCoordinate2D coordinate;
@public
    double latitude;
    double longitude;
}

@property (strong,nonatomic,retain) NSDictionary *data;
//@property (nonatomic, retain) NSNumber *low;
//@property (nonatomic, retain) NSNumber *high;
//@property (nonatomic, retain) NSNumber *condition;
//@property (nonatomic, retain) NSString *title;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
