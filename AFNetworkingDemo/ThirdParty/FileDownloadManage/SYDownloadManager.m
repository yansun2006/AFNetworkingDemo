//
//  SYDownloadManager.m
//  AFNetworkingProj
//
//  Created by 焱 孙 on 15/8/7.
//  Copyright (c) 2015年 焱 孙. All rights reserved.
//

#import "SYDownloadManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface SYDownloadManager ()
@property (nonatomic, strong) NSMutableArray *aryHTTPRequest;         //正在下载的任务列表

@end

@implementation SYDownloadManager

//单例对象
+ (SYDownloadManager *)sharedDownloadManager
{
    static SYDownloadManager *_downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _downloadManager = [[SYDownloadManager alloc]init];
        _downloadManager.aryHTTPRequest = [NSMutableArray array];
    });
    
    return _downloadManager;
}

//开始下载文件
- (void)downloadFile:(NSString*)strURL delegate:(id<DownloadManagerDelegate>)delegate
{
    NSParameterAssert(strURL);
    NSParameterAssert(delegate);
    
    if(delegate == nil)
    {
        return;
    }
    
    //1.判断该URL是不是已经在下载
    for (SYHTTPRequestOperation *operation in self.aryHTTPRequest)
    {
        if ([operation.strFileURL isEqualToString:strURL])
        {
            if ([operation isPaused])
            {
                [self.aryHTTPRequest removeObject:operation];
                break;
            }
            else
            {
                operation.delegate = delegate;//重新指向新的delegate
                [operation.delegate startDownload:operation];
                return;
            }
        }
    }
    
    //2.初始化下载操作
    SYHTTPRequestOperation *operation = [[SYHTTPRequestOperation alloc]initWithFileInfo:strURL delegate:delegate];
    [self.aryHTTPRequest addObject:operation];
    [operation downloadFileWithProgressBlock:^(SYHTTPRequestOperation *requestOperation, unsigned long long totalBytesRead, unsigned long long totalBytesExpectedToRead){
        //不能使用operation.delegate,会造成循环引用
        dispatch_async(dispatch_get_main_queue(), ^{
            [requestOperation.delegate updateDownloadProgress:requestOperation total:totalBytesRead current:totalBytesExpectedToRead];
        });
    } successBlock:^(SYHTTPRequestOperation *requestOperation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [requestOperation.delegate finishedDownload:requestOperation error:nil];
        });
        [self.aryHTTPRequest removeObject:requestOperation];
    } failureBlock:^(SYHTTPRequestOperation *requestOperation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [requestOperation.delegate finishedDownload:requestOperation error:error];
        });
        [self.aryHTTPRequest removeObject:requestOperation];
    }];
    
    //回调代理已经开启下载
    [operation.delegate startDownload:operation];
}

//停止下载文件
- (void)stopDownload:(SYHTTPRequestOperation*)operation result:(void(^)(void))resultBlock
{
    [operation stopDownloadOperation:^{
        [self.aryHTTPRequest removeObject:operation];
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock();
        });
    }];
}

//根据URL获取对应MD5值，作为文件名
+ (NSString *)fileNameForURL:(NSString *)strURL
{
    const char *str = [strURL UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    filename = [filename stringByAppendingPathExtension:strURL.pathExtension];
    
    return filename;
}

//检查文件是否存在永久存储器中
+ (BOOL)checkFileExist:(NSString *)strURL
{
    NSString *strFileName = [SYDownloadManager fileNameForURL:strURL];
    NSString *strFilePath = [[SYDownloadManager getCacheDirectory] stringByAppendingPathComponent:strFileName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:strFilePath];
}

//检查临时下载文件是否存在
+ (BOOL)checkTempFileExist:(NSString *)strURL
{
    NSString *strFileName = [SYDownloadManager fileNameForURL:strURL];
    NSString *strFilePath = [[SYDownloadManager getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_resumeData",strFileName]];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:strFilePath];
}

//获取成功文件路径
+ (NSString *)getCacheDirectory
{
    NSString *strDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *strFilePath = [strDocumentPath stringByAppendingPathComponent:SY_DOC_PATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:strFilePath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES))
    {
        [fileManager createDirectoryAtPath:strFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return strFilePath;
}

+ (NSString *)getFilePathByURL:(NSString *)strURL
{
    NSString *strFileName = [SYDownloadManager fileNameForURL:strURL];
    return [[SYDownloadManager getCacheDirectory] stringByAppendingPathComponent:strFileName];
}

+ (void)deleteFileByURL:(NSString *)strURL {
    NSString *strFileName = [SYDownloadManager fileNameForURL:strURL];
    NSString *strFilePath = [[SYDownloadManager getCacheDirectory] stringByAppendingPathComponent:strFileName];
    NSString *strResumeFilePath = [[SYDownloadManager getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_resumeData",strFileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //delete resumeData file
    if([fileManager fileExistsAtPath:strResumeFilePath]) {
        [fileManager removeItemAtPath:strResumeFilePath error:nil];
    }
    
    //delete file
    if([fileManager fileExistsAtPath:strFilePath]) {
        [fileManager removeItemAtPath:strFilePath error:nil];
    }
}

@end
