//
//  DFImageDownloadOperation.m
//  df_ac_test
//
//  Created by Dahiri Farid on 4/10/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "DFImageDownloadOperation.h"
#import "UIImage+Resize.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const NSInteger kDownloadStep = 0.1f;

@interface DFImageDownloadOperation () <NSURLSessionDelegate>

@property (nonatomic, readwrite, getter = isExecuting)  BOOL executing;
@property (nonatomic, readwrite, getter = isFinished)   BOOL finished;


@property (nonatomic, assign) NSInteger        operationID;
@property (nonatomic, strong) NSURL*           imageURL;
@property (nonatomic, assign) CGFloat          downloadProgress;
@property (nonatomic, assign) long long        downloadSize;
@property (nonatomic, strong) NSMutableData*   downloadData;
@property (nonatomic, strong) NSURLSession*    downloadSession;
@property (nonatomic, copy) void (^imageDownloadCompletionBlock)(UIImage* aImage, NSInteger aID);
@property (nonatomic, copy) void (^imageDownloadProgressBlock)(CGFloat aProgress, NSInteger aID);

@end

@implementation DFImageDownloadOperation

@synthesize executing = _executing;
@synthesize finished  = _finished;

+ (instancetype)imageDownloadOperationWithID:(NSInteger)aID
                                         URL:(NSURL *)aImageURL
                             completionBlock:(void (^)(UIImage* aImage, NSInteger aID))completion
                               progressBlock:(void (^)(CGFloat aProgress, NSInteger aID))progressBlock
{
    return [[self alloc] initWithID:aID
                                URL:aImageURL
                    completionBlock:completion
                      progressBlock:progressBlock];
}

- (instancetype)initWithID:(NSInteger)aID
                       URL:(NSURL *)aImageURL
           completionBlock:(void (^)(UIImage* aImage, NSInteger aID))completion
             progressBlock:(void (^)(CGFloat aProgress, NSInteger aID))progressBlock
{
    NSParameterAssert(aImageURL);
    
    self = [super init];
    if (self)
    {
        _executing = NO;
        _finished = NO;
        
        self.imageDownloadCompletionBlock = completion;
        self.imageDownloadProgressBlock = progressBlock;
        
        self.operationID = aID;
        self.imageURL = aImageURL;
        self.downloadProgress = 0.0f;
    }
    return self;
}

- (void)start
{
    if (self.isCancelled)
    {
        [self completeOperation];
        return;
    }
    self.executing = YES;
    
    [self startDownloadRequest];
}

- (void)startDownloadRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
    
    NSString* strID = [NSString stringWithFormat:@"%ld", self.ID];
    
    NSURLSessionConfiguration* sessionConfiguration =
    [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:strID];
    
    self.downloadSession =
    [NSURLSession sessionWithConfiguration:sessionConfiguration
                                  delegate:self
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task =
    [self.downloadSession dataTaskWithRequest:request
                            completionHandler:nil];
    
    [task resume];
}

- (void)completeOperation
{
    self.executing = NO;
    self.finished = YES;
}

- (void)setFinished:(BOOL)finished
{
    if (finished != _finished)
    {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (void)setExecuting:(BOOL)executing
{
    if (executing != _executing)
    {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (NSInteger)ID
{
    return self.operationID;
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    self.downloadSize = [response expectedContentLength];
    self.downloadData = [[NSMutableData alloc]init];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.downloadData appendData:data];
    CGFloat nextDownloadProgress = (CGFloat)[self.downloadData length] / (CGFloat)self.downloadSize;
    
    if (nextDownloadProgress - self.downloadProgress > kDownloadStep ||
        nextDownloadProgress >= 1.0f)
    {
        self.downloadProgress = nextDownloadProgress;
        
        if (self.imageDownloadProgressBlock)
            self.imageDownloadProgressBlock(self.downloadProgress, self.ID);
        
        if (self.downloadSize == self.downloadData.length)
        {
            [self.downloadSession invalidateAndCancel];
            [self completeOperation];
            
            UIImage* image = [UIImage imageWithData:self.downloadData];
            
            if (image)
            {
                UIImage* resizedImage = [image imageScaledToSize:CGSizeMake(320.0f, 480.0f)];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImageWriteToSavedPhotosAlbum(resizedImage, nil, nil, nil);
                });
                
                if (self.imageDownloadCompletionBlock)
                    self.imageDownloadCompletionBlock(resizedImage, self.ID);
            }
            else
            {
                if (self.imageDownloadCompletionBlock)
                    self.imageDownloadCompletionBlock(nil, self.ID);
            }
        }
    }
    else
    {
        NSLog(@"SKIPPED DOWNLOAD PROGRESS");
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    
}

- (void)dealloc
{
    self.downloadSession = nil;
}

@end
