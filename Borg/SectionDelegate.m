//
//  SectionDelegate.m
//  Borg
//
//  Created by Luca Rocchi on 19/07/14.
//  Copyright (c) 2014 mobileborg. All rights reserved.
//

#import "SectionDelegate.h"
#import "UIImageView+WebCache.h"
#import "SectionCell.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface SectionDelegate(){
}


@property (retain, nonatomic)  NSMutableArray *cellArray;
@end

@implementation SectionDelegate

#pragma mark - UICollectionView Datasource
// 1

-(void) initCells{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.cellArray=[NSMutableArray array];
    int i=0;
    for (NSDictionary* d in app.data){
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:i++ inSection:0];
        SectionCell *cell = [self.controller.sectionCollectionView dequeueReusableCellWithReuseIdentifier:@"SectionCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        
        NSDictionary *cover=[d objectForKey:@"cover" ] ;
        [cell.imageView setImage:nil];
        if (cover!=nil){
            NSString *source=[cover objectForKey:@"source"];
            [cell.imageView setImageWithURL:[NSURL URLWithString:source] placeholderImage:nil];
        }
        [cell.labelCategory setText:[d objectForKey:@"category" ]];
        [cell.labelTitle setText:[d valueForKey:@"name"]];
        [self.cellArray addObject:cell];
    }
}
- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return app.data.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //SectionCell *cell=[self.cellArray objectAtIndex:indexPath.item];
    //return cell;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float sh=screenRect.size.height;
    float sw=screenRect.size.width;
    CGRect bounds=CGRectMake(0,0, sw,sh-SUBSECTION_HEIGHT);
    
    
    NSMutableDictionary*d=[app.data objectAtIndex:indexPath.item];
    
    bool themeLight=false;
    NSString *theme=[d objectForKey:@"theme" ] ;
    if ([theme isEqual:@"light"]){
        themeLight=true;
    }
    
    
    UIColor *bgcolor= themeLight ? [UIColor whiteColor]:[UIColor blackColor];
    UIColor *textcolor= themeLight ? [UIColor blackColor]:[UIColor whiteColor];
    NSString *backcolor=[d objectForKey:@"background-color" ] ;
    if (backcolor!=nil){
        bgcolor=[app colorFromHexString:backcolor];
    }
    NSString*template=[d objectForKey:@"template"];
    if (template==nil){
        
        SectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SectionCell" forIndexPath:indexPath];
        cell.backgroundColor = bgcolor;
        //cell.bounds=bounds;
        [cell.labelDescription setText:@""];
        [cell.labelTitle setText:[d valueForKey:@"name"]];
        cell.viewPicture.layer.cornerRadius=5;
        cell.viewPicture.layer.borderWidth=1;
        
        
        NSString *category=[d objectForKey:@"category" ];
        NSArray*categorylist=[d objectForKey:@"category_list"];
        if (categorylist!=nil && [categorylist count]){
            category=[[categorylist objectAtIndex:0] objectForKey:@"name"];
        }
        [cell.labelCategory setText:category];
        //[cell.labelDescription setText:[d objectForKey:@"description"]];
        //[cell.labelDescription sizeToFit];
        
        [cell.labelTitle setTextColor:textcolor];
        [cell.labelCategory setTextColor:textcolor];
        //[cell.labelDescription setTextColor:textcolor];
        
        NSString *pict=[NSString stringWithFormat:@"%@%@/picture?type=large",@FBG,[d valueForKey:@"id"] ];
        [cell.imageViewPicture setImageWithURL:[NSURL URLWithString:pict] placeholderImage:nil];
        
        
        NSDictionary *cover=[d objectForKey:@"cover" ] ;
        [cell.imageView setImage:nil];
        if (cover!=nil){
            NSString *source=[cover objectForKey:@"source"];
            [cell.imageView setImageWithURL:[NSURL URLWithString:source] placeholderImage:nil];
            CGRect f0=CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height);
            cell.imageView.frame=f0;
            NSNumber *offset_y=[cover valueForKey:@"offset_y"];
            if ([offset_y intValue]>0){
                CGRect f=cell.imageView.frame;
                f.origin.y=[offset_y intValue];
                f.size.height=f0.size.height-[offset_y intValue];
                cell.imageView.frame=f;
            }
        }
        
        NSString *logo=[d objectForKey:@"logo"];
        [cell.imageViewLogo setImage:nil];
        if (logo!=nil){
            [cell.imageViewLogo setImageWithURL:[NSURL URLWithString:logo] placeholderImage:nil];
        }
        
        return cell;
    }
    if ([template isEqual:@"map" ]){
        SectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SectionCellMap" forIndexPath:indexPath];
        cell.backgroundColor = bgcolor;
        //cell.bounds=bounds;
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


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectItemAtIndexPath %@",indexPath);
    //[app..collectionView reloadData];
    /*AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary*d=[app.data objectAtIndex:indexPath.item];
    NSMutableArray*items=[d objectForKey:@"items"];
    if (items!=nil){
        app.items=[NSMutableArray arrayWithArray:items];;
    }else{
        [app.items removeAllObjects];
    }
    [self.controller.collectionView reloadData];
     */
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"shouldHighlightItemAtIndexPath %@",indexPath);
    return YES;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary*d=[app.data objectAtIndex:page];
        NSMutableArray*items=[d objectForKey:@"items"];
        if (items!=nil){
            app.items=[NSMutableArray arrayWithArray:items];;
        }else{
            [app.items removeAllObjects];
        }
        [self.controller.collectionView reloadData];
        self.controller.pageControl.currentPage=page;
        previousPage = page;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"shouldSelectItemAtIndexPath %@",NSStringFromCGRect(collectionView.frame));
    return YES;

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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float sh=screenRect.size.height;
    float sw=screenRect.size.width;
    //CGRect bounds=CGRectMake(0,0, sw,sh-SUBSECTION_HEIGHT);
    CGSize retval = CGSizeMake(sw,sh-SUBSECTION_HEIGHT);
    
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

@end

