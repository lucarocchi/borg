//
//  MainViewController.m
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "GridCell.h"
#import "SectionDelegate.h"
#import "GridDelegate.h"
#import "AnnotationView.h"
#import "MapItem.h"
#import "Pop/Pop.h"


@interface MainViewController ()<POPAnimationDelegate>{
    bool sizing;
    double frameTimestamp;
    CGRect frameStartRect;
    CGRect frameEndRect;
}
@property (retain, nonatomic) IBOutlet SectionDelegate *sectionDelegate;
@property (retain, nonatomic) IBOutlet GridDelegate *gridDelegate;
@property(nonatomic) UIControl *dragView;
@property(nonatomic, strong) CADisplayLink *displayLink;
- (void)addDragView;
- (void)touchDown:(UIControl *)sender;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    sizing=false;
    UINib *sectionNib = [UINib nibWithNibName:@"SectionCell" bundle:nil];
    [self.sectionCollectionView registerNib:sectionNib forCellWithReuseIdentifier:@"SectionCell"];
    
    UINib *sectionNibMap = [UINib nibWithNibName:@"SectionCellMap" bundle:nil];
    [self.sectionCollectionView registerNib:sectionNibMap forCellWithReuseIdentifier:@"SectionCellMap"];
    
    UINib *cellNib = [UINib nibWithNibName:@"GridCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"GridCell"];
    UINib *cellNib2 = [UINib nibWithNibName:@"GridCell2" bundle:nil];
    [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:@"GridCell2"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float sh=screenRect.size.height;
    float sw=screenRect.size.width;
    CGRect f0=CGRectMake(0,0, sw,sh-SUBSECTION_HEIGHT);
    self.sectionCollectionView.frame=f0;
    CGRect f1=CGRectMake(0,sh-SUBSECTION_HEIGHT, sw,SUBSECTION_HEIGHT);
    self.collectionView.frame=f1;
    CGRect f2=CGRectMake(0,sh-SUBSECTION_HEIGHT-50, sw,50);
    self.pageControl.frame=f2;
    
    //self.view.frame=CGRectMake(0,100,320,568);
    //self.sectionCollectionView.contentSize=bounds.size;
    //NSLog(@"contentSize %@",NSStringFromCGSize(self.sectionCollectionView.contentSize));
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    self.pageControl.currentPage = 0;
    self.sectionDelegate=[SectionDelegate new];
    self.gridDelegate=[GridDelegate new];
    self.sectionDelegate.controller=self;
    self.gridDelegate.controller=self;
    
    self.sectionCollectionView.delegate=self.sectionDelegate;
    self.sectionCollectionView.dataSource=self.sectionDelegate;
    self.collectionView.delegate=self.gridDelegate;
    self.collectionView.dataSource=self.gridDelegate;
    //[self.collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] animated:YES];
    
    NSLog(@"sectionCollectionView %@",NSStringFromCGPoint(self.sectionCollectionView.center)) ;
    NSLog(@"collectionView %@",NSStringFromCGPoint(self.collectionView.center)) ;
    
    
    
    [self.buttonMap addTarget:self action:@selector(touchUpInsideMap:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonPeople addTarget:self action:@selector(touchUpInsidePeople:) forControlEvents:UIControlEventTouchUpInside];
    [self addDragView];
    [self setData];
    //self.collectionView.layer.anchorPoint=CGPointMake(1,0);
    //[self.collectionView addObserver:self forKeyPath:@"frame" options:0 context:nil];
	//[self startMotionDetect];
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.collectionView && [keyPath isEqualToString:@"frame"]) {
        NSLog(@"observeValueForKeyPath");
        [self.collectionView reloadData];
        // do your stuff, or better schedule to run later using performSelector:withObject:afterDuration:
    }
}

- (void)touchUpInsideMap:(UIImageView *)image
{
    [self shakeMap];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
}
- (void)touchUpInsidePeople:(UIImageView *)image
{
    [self shakePeople];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
}

- (void)shakeMap
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @1000;
    positionAnimation.springBounciness = 15;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.buttonMap.userInteractionEnabled = YES;
        
        //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //NSDictionary * location=[app.json objectForKey:@"location"];
        /*if (location!=nil){
            NSString * street=[location objectForKey:@"street"];
            NSString* url = [NSString stringWithFormat: @"maps://?daddr=%@&directionsmode=driving",
                         [street stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }*/

    }];
    [self.buttonMap.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)shakePeople
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @1000;
    positionAnimation.springBounciness = 15;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.buttonPeople.userInteractionEnabled = YES;
    }];
    [self.buttonPeople.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}



- (void) setData{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.sectionCollectionView reloadData];
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = app.data.count;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return !sizing;

}


#pragma mark - Private Instance methods

- (void)addDragView
{
    //UIGestureRecognizerDelegate gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer: with scrollView's gestureRecognizer got by panGestureRecognizer
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [self.collectionView addGestureRecognizer:recognizer];
    //recognizer.cancelsTouchesInView=NO;
    recognizer.delegate=self;

}

- (void)touchDown:(UIControl *)sender {
}


- (void)updateDuringAnimation {
    //[self.collectionView.collectionViewLayout invalidateLayout];
    //NSLog ([NSThread isMainThread]? @"main":@"not main");
    double duration=.2;
    double factor=duration;
	double currentTime = [self.displayLink timestamp];
	double renderTime = currentTime - frameTimestamp;
	//frameTimestamp = currentTime;
    //NSLog(@"r1 %@",NSStringFromCGRect(frameStartRect));
    //NSLog(@"r2 %@",NSStringFromCGRect(frameEndRect));
    double dy=(frameEndRect.size.height-frameStartRect.size.height);
    double dy0=dy*renderTime/factor;
    //NSLog(@"updateDuringAnimation! %f",renderTime);
    //NSLog(@"dy %f",dy);
    //NSLog(@"dy0 %f %f",dy0,renderTime);
    CGRect f;
    f.origin.y=0;// (frameEndRect.origin.y+frameEndRect.size.height) - (frameStartRect.size.height+dy0);
    f.origin.x=0;
    f.size.width=frameEndRect.size.width;
    f.size.height=frameStartRect.size.height+dy0;
    CGPoint c;
    c.x=frameEndRect.size.width/2;
    c.y=(frameEndRect.origin.y+frameEndRect.size.height)-(f.size.height/2);
    self.collectionView.bounds=f;
    self.collectionView.center=c;
    dispatch_async (dispatch_get_main_queue(), ^{
        [self.collectionView.collectionViewLayout invalidateLayout];
        //[self.collectionView reloadData];
    });
    if (renderTime>duration){
        self.collectionView.frame=frameEndRect;
        [self.displayLink invalidate];
        self.displayLink=nil;
        sizing=false;
        
    }
    //[self.collectionView reloadData];
    //[self.collectionView setNeedsDisplay];
}

//http://stackoverflow.com/questions/13780153/uicollectionview-animate-cell-size-change-on-selection

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //CGPoint center0=CGPointMake(recognizer.view.center.x, recognizer.view.center.y);
    CGPoint translation = [recognizer translationInView:self.view];
    float ah=recognizer.view.frame.size.height;
    float sh=self.view.window.screen.bounds.size.height;
    float sw=self.view.window.screen.bounds.size.width;
    float dy=-translation.y;
    float dx=translation.x;
    float nh=ah +dy;
    if (nh<SUBSECTION_HEIGHT){
        //NSLog(@"nh<SUBSECTION_HEIGHT") ;
        nh=SUBSECTION_HEIGHT;
        //return;
    }
    if (!sizing){
        if (dx==0 && dy!=0 ){
            sizing=true;
        }else{
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            return;
        }
    }
    if (sizing){
        float y0=sh-nh;
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        CGRect frame=recognizer.view.frame;
        frame.origin = CGPointMake(0,y0);
        frame.size = CGSizeMake(sw,nh);
        self.collectionView.frame=frame;
        [self.collectionView.collectionViewLayout invalidateLayout];
        if(recognizer.state == UIGestureRecognizerStateEnded) {
            frameStartRect=self.collectionView.frame;
            CGRect r = [[UIScreen mainScreen] bounds];
            float sh=r.size.height;
            if (dy<0 || frameStartRect.size.height<sh*.66){
                [self gridRestore];
            }else{
                [self gridMaximize];
            }
        }
    }
}

-(void) gridToggle{
    if ([self isGridMaximized]){
        [self gridRestore];
    }else{
        [self gridMaximize];
    }
}

-(bool) isGridMaximized{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect gridRect=self.collectionView.bounds;
    return gridRect.size.height==screenRect.size.height;
}

-(void) gridMaximize{
    frameStartRect=self.collectionView.frame;
    frameEndRect = [[UIScreen mainScreen] bounds];
    self.collectionView.pagingEnabled=true;
    [self startDisplay];
}

-(void) gridRestore{
    frameStartRect=self.collectionView.frame;
    CGRect r = [[UIScreen mainScreen] bounds];
    float sh=r.size.height;
    r.origin.y=sh-SUBSECTION_HEIGHT;
    r.size.height=SUBSECTION_HEIGHT;
    frameEndRect=r;
    self.collectionView.pagingEnabled=false;
    [self startDisplay];
}

-(void) startDisplay{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDuringAnimation)];
    frameTimestamp =  CACurrentMediaTime();//[self.displayLink timestamp];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

/*[UIView animateWithDuration:.5
 delay:0
 options: UIViewAnimationOptionCurveEaseInOut
 animations:^{
 NSLog(@"final origin y %f",y0) ;
 self.collectionView.center =CGPointMake(sw/2, y0);
 //[self.collectionView.collectionViewLayout invalidateLayout];
 
 //self.collectionView.contentMode=UIViewKeyframeAnimationOptionLayoutSubviews;
 //self.collectionView.transform = CGAffineTransformRotate(self.collectionView.transform, M_PI);
 
 }
 completion:^(BOOL finished){
 NSLog(@"1center.y y %f",self.collectionView.center.y) ;
 NSLog(@"1origin y %f",self.collectionView.frame.size.height) ;
 self.collectionView.frame =f;
 [self.collectionView.collectionViewLayout invalidateLayout];
 NSLog(@"2center.y y %f",self.collectionView.center.y) ;
 NSLog(@"2origin y %f",self.collectionView.frame.size.height) ;
 [self.displayLink invalidate];
 self.displayLink = nil;
 
 NSLog(@"Done1!");
 }];
 */




- (IBAction)loginEvent:(UIButton *)sender {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app loginFacebook];

}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //Here
    //[self.mapView selectAnnotation:[[self.mapView annotations] lastObject] animated:YES];
}





- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    //NSLog(@"viewForAnnotation");
    if (annotation == self.mapView.userLocation){
        return nil; //default to blue dot
    }
    
    /*MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DETAILPIN_ID"];
     [pinView setAnimatesDrop:YES];
     [pinView setCanShowCallout:YES];
     UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     button.frame = CGRectMake(0, 0, 23, 23);
     pinView.rightCalloutAccessoryView = button;
     
     return pinView;
     */
    /*
     if ([annotation isKindOfClass:[MKUserLocation class]]){
     return nil;
     }
     */
    AnnotationView *annotationView =
    (AnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    annotationView.canShowCallout = YES;
    annotationView.annotation = annotation;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CGRectMake(0, 0, 23, 23);
    annotationView.rightCalloutAccessoryView = button;
    
    
    return annotationView;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped %@",view.annotation.title);
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
        return ;
    }
    MapItem *mitem = (MapItem *)view.annotation;
    
    //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    /*ItemViewController*vc=[[ItemViewController alloc]init];
    vc.data=[NSMutableDictionary dictionaryWithDictionary:scribbItem.data];
    
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];*/
    
}

- (void)startMotionDetect
{
    __block float stepMoveFactor = 15;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [app.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                             withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            
                            
                            CGRect rect = self.sectionCollectionView.frame;
                            
                            float movetoX = rect.origin.x + (data.acceleration.x * stepMoveFactor);
                            float maxX = self.view.frame.size.width - rect.size.width;
                            
                            float movetoY = (rect.origin.y + rect.size.height) - (data.acceleration.y * stepMoveFactor);
                            float maxY = self.view.frame.size.height;
                            
                            if ( movetoX > 0 && movetoX < maxX ) {rect.origin.x += (data.acceleration.x * stepMoveFactor);};
                            if ( movetoY > 0 && movetoY < maxY ) {rect.origin.y -= (data.acceleration.y * stepMoveFactor);};
                            
                            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                 self.sectionCollectionView.frame = rect;
                             } completion:nil];
                            
                        });
     }
     ];
    
    
}

@end
