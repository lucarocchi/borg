//
//  SectionDelegate.m
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import "GridDelegate.h"
#import "AppDelegate.h"
#import "GridCell.h"
#import "GridCell2.h"
#import "MainViewController.h"
#import "WebViewController.h"
#import "ItemViewController.h"
#import "AFCollectionViewFlowLargeLayout.h"
#import "AFCollectionViewFlowSmallLayout.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"


@interface GridDelegate() {
}
@end

@implementation GridDelegate

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //return app.items.count;
    NSArray*items=[[app.data objectAtIndex:app.pageIndex] objectForKey:@"items"];
    return items.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray*items=[[app.data objectAtIndex:app.pageIndex] objectForKey:@"items"];
    NSMutableDictionary*d=[items objectAtIndex:indexPath.item];
    
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

    NSString*type=[d valueForKey:@"type"];
    if ([type isEqual:@"link"]){
        NSString *link=[d objectForKey:@"link"];
        if (link!=nil){
        }
    }
    
    NSString*template=[d objectForKey:@"template"];
    if ([template isEqual:@"2" ]){
        GridCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        //[cell.labelTitle setText:[NSString stringWithFormat:@"cell %d",indexPath.row]];
        
        NSString*title=[d valueForKey:@"caption"];
        if (title!=nil){
            //title=[d valueForKey:@"type"];
            [cell.labelTitle setText:title];
        }
        
        
        [cell.labelDescription setText:[d objectForKey:@"message" ]];
        [cell.labelDescription setNumberOfLines:0];
        [cell.labelDescription sizeThatFits:CGSizeMake(120., 140.)];
        
        NSString *icon=[d objectForKey:@"picture"];
        [cell.imageViewIcon setImage:nil];
        if (icon!=nil){
            [cell.imageViewIcon setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];
        }
        cell.backgroundColor = bgcolor;
        [cell.labelTitle setTextColor:txcolor];
        [cell.labelDescription setTextColor:txcolor];
        cell.layer.cornerRadius = 4;
        cell.clipsToBounds = YES;
        
        return cell;
    }
    if (template==nil){
        GridCell2 *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GridCell2" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        NSString*title=[self getTitle:d];
        CGRect cf=cell.frame;
        CGRect f0=cell.labelTitle.frame;
        CGRect f1=cell.labelDescription.frame;
        float interline=10;
        //float baseline=10;
        float preferredWidth=120;
        float h=[app getLabelHeight:title withFont:@"HelveticaNeue-CondensedBold" Size:16 andWidth:preferredWidth];

        f0.size.height=h;
        
        [cell.labelTitle setText:title];
        [cell.labelTitle setTextColor:txcolor];
        [cell.labelTitle setFrame:f0];
        
        NSString *desc=[d objectForKey:@"message" ];
        [cell.labelDescription setText:desc];
        [cell.labelDescription setNumberOfLines:0];
        [cell.labelDescription setTextColor:txcolor];
        [cell.labelDescription setHidden:YES];
        NSString *icon=[d objectForKey:@"picture"];
        [cell.imageViewIcon setImage:nil];
        if (icon!=nil){
            // The AFNetworking method to call
            NSURLRequest*ur=[NSURLRequest requestWithURL:[NSURL URLWithString:icon]];
            __weak UIImageView *weakImageView = cell.imageViewIcon;
            [weakImageView setImageWithURLRequest:ur placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                float ih=image.size.height;
                float iw=image.size.width;
                float pih=(ih*preferredWidth)/iw;
                //NSLog(@"setImageWithURLRequest %@ %f %f",title, image.size.height,image.size.width);
                //NSLog(@"setImageWithURLRequest %f %f", pih,preferredWidth);
                CGRect f3=weakImageView.frame;
                f3.origin.y=f0.origin.y+f0.size.height+interline;
                f3.size.height=pih;
                weakImageView.frame=f3;
                
                if (desc!=nil){
                    CGRect f1=cell.labelDescription.frame;
                    f1.origin.y=f3.origin.y +f3.size.height+5;
                    if (f1.origin.y<cf.size.height-(interline*2)){
                        float h0=[app getLabelHeight:desc withFont:@"HelveticaNeue-Thin" Size:15 andWidth:preferredWidth];
                        float h1=cf.size.height-f1.origin.y -interline;
                        //float h2=cf.size.height-f1.origin.y -interline;
                        f1.size.height=MIN(h0,h1);
                        [cell.labelDescription setHidden:NO];
                    }
                    [cell.labelDescription setFrame:f1];
                }
                [weakImageView setAlpha:0.0];
                [weakImageView setImage:image];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.9];
                [weakImageView setAlpha:1.0];
                [UIView commitAnimations];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"failure %s", __PRETTY_FUNCTION__);
            }];
            
            //[cell.imageViewIcon setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];
            NSString*iconmode=[d objectForKey:@"iconmode"];
            //cell.imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
            //cell.imageViewIcon.contentMode = UIViewContentModeScaleAspectFill;
            if ([iconmode isEqual:@"fit"]){
                //cell.imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
            }
        }else{
            NSLog(@"no picture %s", __PRETTY_FUNCTION__);
            if (desc!=nil){
                f1.origin.y= f0.origin.y+f0.size.height+interline;
                float h0=[app getLabelHeight:desc withFont:@"HelveticaNeue-Thin" Size:15 andWidth:preferredWidth];
                float h1=cf.size.height-f1.origin.y-interline;
                f1.size.height=MIN(h0,h1);
                cell.labelDescription.frame=f1;
                [cell.labelDescription setHidden:NO];
            }
        }
        
        cell.layer.cornerRadius = 4;
        cell.clipsToBounds = YES;
        cell.backgroundColor = bgcolor;
        return cell;
    }
    return nil;
}

- (NSString*) getTitle:(id)d{
    NSString*title=[d valueForKey:@"story"];
    if (title==nil){
        title=[d valueForKey:@"name"];
    }
    if (title==nil){
        title=[d valueForKey:@"caption"];
    }
    if (title==nil){
        title=[d valueForKey:@"type"];
    }
    if (title==nil){
        title=@"";
    }
    return title;
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
    //NSLog(@"grid scrollViewDidEndDecelerating %d",page);
    [self.controller.categoryPicker setHidden:YES];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"grid didSelectItemAtIndexPath %ld",indexPath.item);
    NSArray*items=[[app.data objectAtIndex:app.pageIndex] objectForKey:@"items"];
    NSMutableDictionary*d=[items objectAtIndex:indexPath.item];
    NSString*type=[d valueForKey:@"type"];
    if (0 && ( [type isEqual:@"link"]||[type isEqual:@"video"])){
        NSString *link=[d objectForKey:@"link"];
        if (link!=nil){
            WebViewController *wv = [[WebViewController alloc] initWithUrlName:link andTitle:nil];
            wv.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.controller presentViewController:wv animated:YES completion:nil];
        }
    }else{
        ItemViewController*vc=[[ItemViewController alloc]initWithData:d];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.controller presentViewController:vc animated:YES completion:nil];
    }
    
    return;
    if ([self.controller isGridMaximized]){
        
        NSString *link=[d objectForKey:@"link"];
        if (link!=nil){
            WebViewController *wv = [[WebViewController alloc] initWithUrlName:link andTitle:nil];
            wv.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.controller presentViewController:wv animated:YES completion:nil];
        }

        
        /*[self.controller gridRestore];
        [self.controller.collectionView setCollectionViewLayout:self.controller.smallLayout animated:YES completion:(void (^)(BOOL finished))^{
            
        }] ;*/
        
    }else{
        //[self.controller.largeLayout invalidateLayout];
        [self.controller.collectionView setCollectionViewLayout:self.controller.largeLayout animated:YES completion:(void (^)(BOOL finished))^{
            [self.controller gridMaximize];
        }];
    }
    
    return;
    
    // TODO: Select Item
    
    
    /*UICollectionViewFlowLayout* grid = [[UICollectionViewFlowLayout alloc] init];
    grid.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    grid.itemSize = CGSizeMake(320, 568);
    
    [collectionView setCollectionViewLayout:grid animated:NO];
    */
    //[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //[self.controller gridToggle];
    
    /*CGFloat collectionViewHeight = CGRectGetHeight(collectionView.frame);
    [collectionView setContentInset:UIEdgeInsetsMake(collectionViewHeight / 2, 0, collectionViewHeight / 2, 0)];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGPoint offset = CGPointMake(0,  cell.center.y - collectionViewHeight / 2);
    [collectionView setContentOffset:offset animated:YES];
     */
}
    //NSString*fp=[[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html" inDirectory:@"/"];

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"grid shouldSelectItemAtIndexPath %@",NSStringFromCGRect(collectionView.frame));
    return YES;
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

// 1
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
    //self.searchResults[searchTerm][indexPath.row];
    // 2
    CGRect r=[[UIScreen mainScreen] bounds];
    float sh=r.size.height;
    float sw=r.size.width;
    float h=self.controller.collectionView.frame.size.height;
    float w=(h*SUBSECTION_WIDTH)/SUBSECTION_HEIGHT;
    if (h==SUBSECTION_HEIGHT){
        w=SUBSECTION_WIDTH;
    }
    CGSize retval = false ? CGSizeMake(sw,sh):CGSizeMake(w, h);
    if ([self.controller isGridMaximized]){
        r.size.width--;
        retval=r.size;
    }
    
    //NSLog(@"collectionView layout %@",NSStringFromCGSize(retval));
    //NSLog(@"layout %@",NSStringFromCGSize(retval));
    //CGSize retval = CGSizeMake(collectionView.frame.size.height, 568);
    return retval;
}
*/
// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

@end
