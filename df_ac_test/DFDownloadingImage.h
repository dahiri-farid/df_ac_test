//
//  DFDownloadingImage.h
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DFDownloadingImage : NSObject

@property (nonatomic, assign, readonly)   NSInteger ID;
@property (nonatomic, strong)           UIImage* image;
@property (nonatomic, assign)           CGFloat downloadProgress;

+ (instancetype)downloadingImageWithID:(NSInteger)aID;

@end
