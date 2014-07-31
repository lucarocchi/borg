//
//  MainViewController.h
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MainViewController : UIViewController<UIGestureRecognizerDelegate,MKMapViewDelegate>  {
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sectionCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *buttonMap;
@property (weak, nonatomic) IBOutlet UIButton *buttonPeople;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
-(void) gridToggle;
-(bool) isGridMaximized;


@end
