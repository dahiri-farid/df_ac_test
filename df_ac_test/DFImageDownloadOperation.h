//
//  DFImageDownloadOperation.h
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DFImageDownloadOperation : NSOperation

+ (instancetype)imageDownloadOperationWithID:(NSInteger)aID
                                         URL:(NSURL *)aImageURL
                             completionBlock:(void (^)(UIImage* aImage, NSInteger aID))completion
                               progressBlock:(void (^)(CGFloat aProgress, NSInteger aID))progressBlock;

- (NSInteger)ID;

@end
