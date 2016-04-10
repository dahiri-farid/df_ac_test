//
//  DFImageProcessor.m
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "DFImageProcessor.h"
#import "DFImageDownloadOperation.h"

@interface DFImageProcessor ()

@property (nonatomic, strong)   NSOperationQueue* operationQueue;

@end

@implementation DFImageProcessor

+ (instancetype)instance
{
    static DFImageProcessor *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)addImageDownloadOperation:(DFImageDownloadOperation *)aOperation
{
    [self.operationQueue addOperation:aOperation];
}

- (NSInteger)numberOfQueuedOperations
{
    return self.operationQueue.operationCount;
}

@end
