//
//  DFImageCollectionViewCell.h
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFImageCollectionViewCell : UICollectionViewCell

+ (UINib *)nib;
+ (NSString *)ID;

- (void)updateWithImage:(UIImage *)aImage progress:(CGFloat)aProgress;

@end
