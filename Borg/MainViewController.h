//
//  MainViewController.h
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class SmallLayout,AFCollectionViewFlowLargeLayout,AFCollectionViewFlowSmallLayout;
@interface MainViewController : UIViewController<UIGestureRecognizerDelegate,MKMapViewDelegate,UICollectionViewDelegateFlowLayout,UIPickerViewDataSource, UIPickerViewDelegate>  {
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sectionCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//@property (nonatomic, nonatomic) IBOutlet SmallLayout *smallLayout;
@property (nonatomic, nonatomic) IBOutlet AFCollectionViewFlowSmallLayout *smallLayout;
@property (nonatomic, nonatomic) IBOutlet AFCollectionViewFlowLargeLayout *largeLayout;
@property (nonatomic, nonatomic) IBOutlet UICollectionViewTransitionLayout *transitionLayout;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;



@property (weak, nonatomic) IBOutlet UIButton *buttonMap;
@property (weak, nonatomic) IBOutlet UIButton *buttonPeople;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
-(void) gridToggle;
-(void) gridMaximize;
-(void) gridRestore;
-(bool) isGridMaximized;


@end
