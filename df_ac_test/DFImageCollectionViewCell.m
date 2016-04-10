//
//  DFImageCollectionViewCell.m
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "DFImageCollectionViewCell.h"

@interface DFImageCollectionViewCell ()

@property (nonatomic, strong)   IBOutlet    UIView* ibContentView;
@property (nonatomic, strong)   IBOutlet    UIImageView* ibImageView;
@property (nonatomic, strong)   IBOutlet    UIProgressView* ibProgressView;

@end

@implementation DFImageCollectionViewCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *)ID
{
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateWithImage:(UIImage *)aImage progress:(CGFloat)aProgress
{
    NSParameterAssert(aProgress >= 0.0f);
    self.ibImageView.image = aImage;
    self.ibProgressView.progress = aProgress;
    
    if (aProgress >= 1.0f)
        self.ibProgressView.hidden = YES;
    else
        self.ibProgressView.hidden = NO;
}

@end
