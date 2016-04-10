//
//  DFImagePreviewViewController.m
//  df_ac_test
//
//  Created by Dahiri Farid on 4/11/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "DFImagePreviewViewController.h"

@interface DFImagePreviewViewController ()

@property (nonatomic, strong)               UIImage* image;
@property (nonatomic, strong)   IBOutlet    UIImageView* ibImageView;

@end

@implementation DFImagePreviewViewController

+ (instancetype)vcWithImage:(UIImage *)aImage
{
    DFImagePreviewViewController* vc = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    
    vc.image = aImage;
    
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.ibImageView.image = self.image;
}

@end
