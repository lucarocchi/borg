//
//  SectionDelegate.m
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import "GridDelegate.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "GridCell.h"
#import "GridCell2.h"
#import "MainViewController.h"
#import "WebViewController.h"

@interface GridDelegate() {
}
@end

@implementation GridDelegate

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return app.items.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary*d=[app.items objectAtIndex:indexPath.item];
    
    UIColor *bgcolor= [UIColor whiteColor];
    NSString *backcolor=[d objectForKey:@"background-color" ] ;
    if (backcolor!=nil){
        bgcolor=[app colorFromHexString:backcolor];
    }
    UIColor *txcolor= [UIColor blackColor];
    NSString *textcolor=[d objectForKey:@"text-color" ] ;
    if (textcolor!=nil){
        txcolor=[app colorFromHexString:textcolor];
    }

    
    NSString*template=[d objectForKey:@"template"];
    if ([template isEqual:@"2" ]){
        GridCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        //[cell.labelTitle setText:[NSString stringWithFormat:@"cell %d",indexPath.row]];
        [cell.labelDescription setText:[d objectForKey:@"message" ]];
        [cell.labelDescription setNumberOfLines:0];
        [cell.labelDescription sizeThatFits:CGSizeMake(120., 140.)];
        [cell.labelTitle setText:[d valueForKey:@"name"]];
        NSString *icon=[d objectForKey:@"picture"];
        [cell.imageViewIcon setImage:nil];
        if (icon!=nil){
            [cell.imageViewIcon setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];
        }
        cell.backgroundColor = bgcolor;
        [cell.labelTitle setTextColor:txcolor];
        [cell.labelDescription setTextColor:txcolor];
        
        return cell;
    }
    if (template==nil){
        GridCell2 *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GridCell2" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        //[cell.labelTitle setText:[NSString stringWithFormat:@"cell %d",indexPath.row]];
        [cell.labelDescription setText:[d objectForKey:@"message" ]];
        [cell.labelDescription setNumberOfLines:0];
        //[cell.labelDescription sizeThatFits:CGSizeMake(120., 75.)];
        //[cell.labelDescription sizeToFit];
        [cell.labelTitle setText:[d valueForKey:@"name"]];
        [cell.labelTitle setTextColor:txcolor];
        [cell.labelDescription setTextColor:txcolor];

        
        NSString *icon=[d objectForKey:@"picture"];
        [cell.imageViewIcon setImage:nil];
        if (icon!=nil){
            [cell.imageViewIcon setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];
            NSString*iconmode=[d objectForKey:@"iconmode"];
            //cell.imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
            cell.imageViewIcon.contentMode = UIViewContentModeScaleAspectFill;
            if ([iconmode isEqual:@"fit"]){
                cell.imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
        cell.backgroundColor = bgcolor;
        return cell;
    }
    return nil;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    //- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        previousPage = page;
    }
    NSLog(@"grid scrollViewDidEndDecelerating %d",page);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"grid didSelectItemAtIndexPath %d",indexPath.item);
    [self.controller gridToggle];
    //NSString*fp=[[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html" inDirectory:@"/"];
    /*NSMutableDictionary*d=[app.items objectAtIndex:indexPath.item];
    NSString *link=[d objectForKey:@"link"];
    if (link!=nil){
        WebViewController *wv = [[WebViewController alloc] initWithUrlName:link andTitle:nil];
        wv.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.controller presentViewController:wv animated:YES completion:nil];
    }*/

    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
    //self.searchResults[searchTerm][indexPath.row];
    // 2
    float sh=self.controller.view.window.screen.bounds.size.height;
    float sw=self.controller.view.window.screen.bounds.size.width;
    float h=self.controller.collectionView.frame.size.height;
    float w=(h*SUBSECTION_WIDTH)/SUBSECTION_HEIGHT;
    if (h==SUBSECTION_HEIGHT){
        w=SUBSECTION_WIDTH;
    }
    CGSize retval = false ? CGSizeMake(sw,sh):CGSizeMake(w, h);
    if ([self.controller isGridMaximized]){
        CGRect r=[[UIScreen mainScreen] bounds];
        r.size.width--;
        retval=r.size;
    }
    
    //NSLog(@"collectionView layout %@",NSStringFromCGSize(retval));
    //NSLog(@"layout %@",NSStringFromCGSize(retval));
    //CGSize retval = CGSizeMake(collectionView.frame.size.height, 568);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

@end
