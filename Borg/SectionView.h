

#import <UIKit/UIKit.h>

@interface SectionView : UIView //<UIGestureRecognizerDelegate>

+ (SectionView *)viewFromNibNamed:(NSString *)nibName;
+ (SectionView *)viewFromData:(NSDictionary*)data ;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelCategory;
@property (nonatomic, retain) NSMutableDictionary *data;


@end
