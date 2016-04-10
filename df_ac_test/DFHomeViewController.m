//
//  DFHomeViewController.m
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "DFHomeViewController.h"
#import "DFImageCollectionViewCell.h"
#import "DFImageProcessor.h"
#import "DFImageDownloadOperation.h"
#import "DFDownloadingImage.h"
#import "DFImagePreviewViewController.h"

@interface DFHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic, strong)   IBOutlet    UIView* ibSearchBarContentView;
@property (nonatomic, strong)   IBOutlet    UISearchBar* ibSearchBar;

@property (nonatomic, strong)   IBOutlet    UIView* ibCollectionViewContentView;
@property (nonatomic, strong)   IBOutlet    UICollectionView* ibCollectionView;

@property (nonatomic, strong)               NSMutableArray* images;

@property (nonatomic, assign)               NSInteger   increment;

@end

@implementation DFHomeViewController

+ (instancetype)vc
{
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.increment = 0;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Do any additional setup after loading the view from its nib.
    self.images = [NSMutableArray array];
    
    [self.ibCollectionView registerNib:[DFImageCollectionViewCell nib]
            forCellWithReuseIdentifier:[DFImageCollectionViewCell ID]];
    
    [self collectionViewFlowlayout].minimumInteritemSpacing = 0.0f;
    [self collectionViewFlowlayout].minimumLineSpacing = 0.0f;
    
    self.ibSearchBar.placeholder = @"Full image URL";
    self.ibSearchBar.text = @"https://cdn.photographylife.com/wp-content/uploads/2014/06/Nikon-D810-Image-Sample-6.jpg";
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewFlowLayout *)collectionViewFlowlayout
{
    return (UICollectionViewFlowLayout *)self.ibCollectionView.collectionViewLayout;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSParameterAssert(self.ibCollectionView == collectionView);
    
    DFImageCollectionViewCell* cell = [self.ibCollectionView
                                       dequeueReusableCellWithReuseIdentifier:[DFImageCollectionViewCell ID]
                                       forIndexPath:indexPath];
    
    DFDownloadingImage* dlImage = self.images[indexPath.item];
    
    [cell updateWithImage:dlImage.image progress:dlImage.downloadProgress];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DFDownloadingImage* dlImage = self.images[indexPath.item];
    
    if (dlImage.image)
    {
        DFImagePreviewViewController* previewVC = [DFImagePreviewViewController vcWithImage:dlImage.image];
        
        [self.navigationController pushViewController:previewVC animated:YES];
    }
    
    [self.ibCollectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemSideSize = self.view.bounds.size.width / 3.0f;
    return CGSizeMake(itemSideSize, itemSideSize);
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.ibSearchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([searchBar.text length])
    {
        NSURL* URL = [NSURL URLWithString:searchBar.text];
        if (URL)
        {
            __weak typeof (self)weakSelf = self;
            
            DFImageDownloadOperation* dlOperation =
            [DFImageDownloadOperation
             imageDownloadOperationWithID:self.increment
             URL:URL
             completionBlock:^(UIImage *aImage, NSInteger aID)
            {
                DFDownloadingImage* dlImageValue = [weakSelf downloadingImageForID:aID];
                
                NSInteger indexOfDlImageValue = [weakSelf.images indexOfObject:dlImageValue];
                if (aImage)
                {
                    dlImageValue.image = aImage;
                    
                    [weakSelf.ibCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexOfDlImageValue inSection:0]]];
                }
                else
                {
                    [weakSelf.images removeObject:dlImageValue];
                    [weakSelf.ibCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexOfDlImageValue inSection:0]]];
                }
            }
             progressBlock:^(CGFloat aProgress, NSInteger aID)
             {
                 DFDownloadingImage* dlImageValue = [weakSelf downloadingImageForID:aID];
                 dlImageValue.downloadProgress = aProgress;
                 
                 NSInteger indexOfDlImageValue = [weakSelf.images indexOfObject:dlImageValue];
                 
                 [weakSelf.ibCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexOfDlImageValue inSection:0]]];
            }];
            
            [[DFImageProcessor instance] addImageDownloadOperation:dlOperation];
            
            DFDownloadingImage* downloadingImage =
            [DFDownloadingImage downloadingImageWithID:self.increment];
            
            [self.images addObject:downloadingImage];
            
            ++self.increment;
            
            [self.ibCollectionView reloadData];
        }
    }
}

- (DFDownloadingImage *)downloadingImageForID:(NSInteger)ID
{
    for (DFDownloadingImage* dlImage in self.images)
    {
        if (dlImage.ID == ID)
            return dlImage;
    }
    
    return nil;
}

@end
