//
//  VNetworkFramework.h
//  AFNetworkingProj
//
//  Created by 焱 孙 on 15/7/22.
//  Copyright (c) 2015年 焱 孙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UploadFileVo.h"

#define HTTP_STATUS_OK  200

#define ERROR_TO_SERVER_AF      @"访问服务器出错,请稍后再试"
#define ERROR_TO_NETWORK_AF     @"网络错误,请稍后再试"
#define ERROR_TO_DATA           @"数据异常,请稍后再试"
#define ERROR_TO_UPLOAD_FILE    @"文件上传失败,请稍后再试"

typedef void (^NetworkResult)(id responseObject,NSError *error);

typedef void (^FileUploadResult)(NSArray *aryResult,NSError *error);

typedef void (^SingleFileUploadResult)(UploadFileVo *uploadFileVo,NSError *error);

//错误域对象
#define VNetworkErrorDomain @"com.visionet.VNetworkFramework"

typedef enum {
    VNetworkRequestError = -1000,          //网络请求错误
    VNetworkResponseNilError,              //响应内容为空
    VNetworkHttpStatusError,               //HTTP响应状态错误，不为200
    VNetworkHttpRedirectError,             //HTTP响应状态302，session无效
    VNetworkUnknowError                    //未知错误
}VNetworkErrorCode;

@interface VNetworkFramework : NSObject

@property (nonatomic, strong) dispatch_queue_t completionQueue;
@property (nonatomic, strong) dispatch_group_t completionGroup;

- (instancetype)initWithURLString:(NSString*)strURL;

//登录主业务后台服务器
- (void)loginToRestServer:(id)objParameter result:(NetworkResult)networkResult;

//请求主业务后台服务器
- (void)startRequestToServer:(NSString*)strRequestMethod parameter:(id)objParameter result:(NetworkResult)networkResult;

//请求聊天服务器
- (void)startRequestToChatServer:(NSString*)strRequestMethod parameter:(id)objParameter result:(NetworkResult)networkResult;

//上传文件（表单方式批量上传文件）
- (void)uploadBatchFileToServer:(NSArray*)aryFilePath result:(FileUploadResult)fileUploadResult;

//上传文件（二进制文件方式，单个）
- (void)uploadSingleFileWithBinary:(NSString *)strPath result:(NetworkResult)networkResult;

@end
