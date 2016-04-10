//
//  DFImageProcessor.h
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFImageDownloadOperation;

@interface DFImageProcessor : NSObject

+ (instancetype)instance;

- (void)addImageDownloadOperation:(DFImageDownloadOperation *)aOperation;
- (NSInteger)numberOfQueuedOperations;

@end
