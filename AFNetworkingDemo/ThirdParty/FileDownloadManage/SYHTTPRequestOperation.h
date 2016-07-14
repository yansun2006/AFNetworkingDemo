//
//  SYHTTPRequest.h
//  AFNetworkingProj
//
//  Created by 焱 孙 on 15/8/7.
//  Copyright (c) 2015年 焱 孙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//文档存放路径（临时文件后面追加_temp）
#define SY_DOC_PATH @"SYDownloadDoc/FileDirectory"

@class SYHTTPRequestOperation;
@protocol DownloadManagerDelegate;

//声明 下载block 类型
typedef void(^DownloadProgress)(SYHTTPRequestOperation *request, unsigned long long totalBytes, unsigned long long currentDownloadBytes);
typedef void(^DownloadSuccess)(SYHTTPRequestOperation *request, id responseObject);
typedef void(^DownloadFailure)(SYHTTPRequestOperation *request, NSError *error);

@interface SYHTTPRequestOperation : NSObject

@property (nonatomic, weak) id<DownloadManagerDelegate> delegate;
@property (nonatomic, strong) NSString *strFileURL;                            //文件远程下载URL

@property (nonatomic,strong)DownloadProgress progressBlock;

- (instancetype)initWithFileInfo:(NSString *)strFileURL delegate:(id<DownloadManagerDelegate>)delegate;

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
                         failureBlock:(DownloadFailure)failureBlock;

//停止下载任务
- (void)stopDownloadOperation:(void(^)(void))finished;

//是否已暂停
- (BOOL)isPaused;

//获取文件大小
- (long long)fileSizeForPath:(NSString *)path;

@end
