//
//  SYHTTPRequest.m
//  AFNetworkingProj
//
//  Created by 焱 孙 on 15/8/7.
//  Copyright (c) 2015年 焱 孙. All rights reserved.
//

#import "SYHTTPRequestOperation.h"
#import "SYDownloadManager.h"

@interface SYHTTPRequestOperation ()
{
    NSURLSessionDownloadTask *downloadTask;
}

@property (nonatomic, strong) NSString *strDestPath;//文件存放路径
@property (nonatomic, strong) NSString *strResumeDataPath;//断点配置文件

@end


@implementation SYHTTPRequestOperation

- (instancetype)initWithFileInfo:(NSString *)strFileURL delegate:(id<DownloadManagerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.strFileURL = strFileURL;
        self.delegate = delegate;
        
        //获取文件存放目录
        NSString *strFileName = [SYDownloadManager fileNameForURL:self.strFileURL];
        self.strDestPath = [[SYDownloadManager getCacheDirectory] stringByAppendingPathComponent:strFileName];
        //断点配置文件
        self.strResumeDataPath = [[SYDownloadManager getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_resumeData",strFileName]];
    }
    return self;
}

/**
 *  开始下载文件
 *
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *
 *  @return 下载任务
 */
- (void)downloadFileWithProgressBlock:(DownloadProgress)progressBlock
                         successBlock:(DownloadSuccess)successBlock
                         failureBlock:(DownloadFailure)failureBlock
{
    __weak typeof(self) weakSelf = self;
    [[NSURLCache sharedURLCache] removeAllCachedResponses]; //不使用缓存，避免断点续传出现问题
    
    AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
    
    //文件下载进度block
    void (^downloadProgressBlock)(NSProgress *) = ^(NSProgress * _Nonnull downloadProgress) {
        progressBlock(weakSelf, downloadProgress.totalUnitCount, downloadProgress.completedUnitCount);
    };
    
    //文件路径block
    NSURL * (^destinationBlock)(NSURL *, NSURLResponse *) = ^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:weakSelf.strDestPath];
    };
    
    //完成下载block
    void (^completionBlock)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error) = ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failureBlock(weakSelf, error);
        } else {
            //清理resumeData
            if ([[NSFileManager defaultManager] fileExistsAtPath:weakSelf.strResumeDataPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:weakSelf.strResumeDataPath error:nil];
            }
            
            successBlock(weakSelf, nil);
        }
    };
    
    //判断文件是否已经下载一部分，是则进行断点下载
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.strResumeDataPath]) {
        //断点下载
        NSData *dataResume = [NSData dataWithContentsOfFile:self.strResumeDataPath];
        downloadTask = [manager downloadTaskWithResumeData:dataResume progress:downloadProgressBlock destination:destinationBlock completionHandler:completionBlock];
        
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.strFileURL]];
        downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:destinationBlock completionHandler:completionBlock];
    }
    
    //开启任务
    [downloadTask resume];
}

//停止下载任务
- (void)stopDownloadOperation:(void(^)(void))finished
{
    __weak typeof(self) weakSelf = self;
    [downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        //保存断点配置文件
        [resumeData writeToFile:weakSelf.strResumeDataPath atomically:YES];
        if (finished) {
            finished();
        }
    }];
}

//是否已暂停
- (BOOL)isPaused
{
    if (downloadTask)
    {
        return !(downloadTask.state == NSURLSessionTaskStateRunning);
    }
    else
    {
        return YES;
    }
}

//获取文件大小
- (long long)fileSizeForPath:(NSString *)path
{
    long long fileSize = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:path])
    {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict)
        {
            
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

@end
