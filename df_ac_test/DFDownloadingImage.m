//
//  DFDownloadingImage.m
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "DFDownloadingImage.h"

@interface DFDownloadingImage ()

@property (nonatomic, assign, readwrite)    NSInteger ID;

@end

@implementation DFDownloadingImage

+ (instancetype)downloadingImageWithID:(NSInteger)aID
{
    return [[self alloc] initWithOperationID:aID];
}

- (instancetype)initWithOperationID:(NSInteger)aID
{
    self = [super init];
    if (self)
    {
        self.ID = aID;
    }
    return self;
}

@end
