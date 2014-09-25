

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>

@interface MapTableCell : UITableViewCell //<UIGestureRecognizerDelegate>

+ (MapTableCell *)cellFromNibNamed:(NSString *)nibName;
+ (MapTableCell *)cellFromTable:(UITableView *)tableView :(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
