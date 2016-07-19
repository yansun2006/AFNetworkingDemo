//
//  VNetworkFramework.m
//  AFNetworkingProj
//
//  Created by 焱 孙 on 15/7/22.
//  Copyright (c) 2015年 焱 孙. All rights reserved.
//

#import "VNetworkFramework.h"

//Chat Session ID
static NSString *strChatSessionID = @"";

//暂存登录参数和URL，用于Session超时，然后重新登录使用
static id loginParameter = nil;
static NSString *loginURL = nil;

@interface VNetworkFramework ()
{
    NSString *strConnectionURL;         //服务器地址
    NSInteger nRecursiveNum;            //控制递归次数，不超过3次
    NSInteger nResponseStatusCode;      //响应状态
}

@end

@implementation VNetworkFramework

- (instancetype)initWithURLString:(NSString*)strURL
{
    self = [super init];
    if (self != nil)
    {
        nRecursiveNum = 0;
        strConnectionURL = strURL;
    }
    
    return self;
}

//发起HTTP的异步请求
//strRequestMethod:POST/GET
//1.1 POST为:JSON格式，GET为查寻参数(Restful风格):url/parameter1/parameter2/...
- (void)startRequestToServer:(NSString*)strRequestMethod parameter:(id)objParameter result:(NetworkResult)networkResult
{
    nRecursiveNum ++;//控制递归次数(每次请求会初始化为0，当遇到302【Session 超时】，最多三次请求机会)
    [self sendPostToServerCommonMethod:strRequestMethod parameter:objParameter sessionId:nil result:^(id responseObject,NSError *error){
        if (nResponseStatusCode == 302 && nRecursiveNum<=3)
        {
            //遇到302，重新请求
            VNetworkFramework *loginNetworkFramework = [[VNetworkFramework alloc]initWithURLString:loginURL];
            [loginNetworkFramework loginToRestServer:loginParameter result:^(id responseObject, NSError *error) {
                if (error == nil)
                {
                    [self startRequestToServer:strRequestMethod parameter:objParameter result:networkResult];
                    [[NSNotificationCenter defaultCenter] postNotificationName:VNETWORK_NOTIFY_LOGINAGAIN object:responseObject];
                }
            }];
        }
        else
        {
            if(networkResult != nil)
            {
                networkResult(responseObject,error);
            }
        }
    }];
}

//1.2 请求聊天服务器数据
- (void)startRequestToChatServer:(NSString*)strRequestMethod parameter:(id)objParameter result:(NetworkResult)networkResult
{
    nRecursiveNum ++;//控制递归次数
    [self sendPostToServerCommonMethod:strRequestMethod parameter:objParameter sessionId:strChatSessionID result:^(id responseObject,NSError *error){
        if (nResponseStatusCode == 302 && nRecursiveNum<=3)
        {
            //遇到302，重新请求
            VNetworkFramework *loginNetworkFramework = [[VNetworkFramework alloc]initWithURLString:loginURL];
            [loginNetworkFramework loginToRestServer:loginParameter result:^(id responseObject, NSError *error) {
                if (error == nil)
                {
                    [self startRequestToServer:strRequestMethod parameter:objParameter result:networkResult];
                    [[NSNotificationCenter defaultCenter] postNotificationName:VNETWORK_NOTIFY_LOGINAGAIN object:responseObject];
                }
            }];
        }
        else
        {
            if(networkResult != nil)
            {
                networkResult(responseObject,error);
            }
        }
    }];
}

-(void)sendPostToServerCommonMethod:(NSString*)strRequestMethod parameter:(id)objParameter sessionId:(NSString*)strSessionID result:(NetworkResult)networkResult
{
    //1.init server url
    NSString *serverURL = [strConnectionURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (strSessionID != nil)
    {
        //追加SessionID,不对SessionID进行URL编码
        serverURL = [NSString stringWithFormat:@"%@%@",strConnectionURL,strSessionID];
    }
    
    //2.define block
    void (^successBlock)(NSURLSessionDataTask*, id) = ^(NSURLSessionDataTask *task, id responseObject){
        //2.1 success request
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        nResponseStatusCode = response.statusCode;
        id responseData = [self getObjectFromJSONData:responseObject];
        
#ifdef DEBUG
        //打印URL
        NSLog(@"--Request Log-------------------------------------------------------------");
        NSLog(@"Request URL = %@",serverURL);
        
        //打印Request Value
        NSString *strRequest = nil;
        if (objParameter != nil)
        {
            NSData *dataLogRequest = [NSJSONSerialization dataWithJSONObject:objParameter options:NSJSONWritingPrettyPrinted error:nil];
            strRequest = [[NSString alloc]initWithData:dataLogRequest encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Request Value = %@",strRequest?:@"");
        
        //response value（含中文）
        NSString *strResponse = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Response Value = %@ \n",strResponse);
#endif
        
        if(responseData == nil)
        {
            NSError *errorNetwork = [NSError errorWithDomain:VNetworkErrorDomain code:VNetworkResponseNilError userInfo:@{NSLocalizedDescriptionKey:ERROR_TO_SERVER_AF}];
            networkResult(nil,errorNetwork);
        }
        else
        {
            if (response.statusCode != HTTP_STATUS_OK)
            {
                NSString *strErrorMsg = ERROR_TO_SERVER_AF;
                if ([responseData isKindOfClass:[NSDictionary class]])
                {
                    strErrorMsg = [responseData objectForKey:@"msg"];
                    if (strErrorMsg == nil)
                    {
                        strErrorMsg = ERROR_TO_SERVER_AF;
                    }
                }
                
                NSError *errorNetwork = [NSError errorWithDomain:VNetworkErrorDomain code:VNetworkHttpStatusError userInfo:@{NSLocalizedDescriptionKey:strErrorMsg}];
                networkResult(responseData,errorNetwork);
            }
            else
            {
                networkResult(responseData,nil); //success request
            }
        }
    };
    
    void (^failureBlock)(NSURLSessionDataTask*, NSError*) = ^(NSURLSessionDataTask *task, NSError *error){
        //2.2 failure request
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
#ifdef DEBUG
        //打印URL
        NSLog(@"--Request Log-------------------------------------------------------------");
        NSLog(@"Request URL = %@",serverURL);
        
        //打印Request Value
        NSString *strRequest = nil;
        if (objParameter != nil)
        {
            NSData *dataLogRequest = [NSJSONSerialization dataWithJSONObject:objParameter options:NSJSONWritingPrettyPrinted error:nil];
            strRequest = [[NSString alloc]initWithData:dataLogRequest encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Request Value = %@",strRequest?:@"");
        
        //response value（含中文）
        NSLog(@"Request ERROR = %@",error);
#endif
        
        nResponseStatusCode = response.statusCode;
        NSError *errorNetwork = [NSError errorWithDomain:VNetworkErrorDomain code:VNetworkRequestError userInfo:@{NSLocalizedDescriptionKey:ERROR_TO_NETWORK_AF}];
        networkResult(nil,errorNetwork);
    };
    
    //3.start request
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (self.completionGroup != nil)
    {
        manager.completionGroup = self.completionGroup;
    }
    if (self.completionQueue != nil)
    {
        manager.completionQueue = self.completionQueue;
    }
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置响应数据为NSData类型，自己解析为NSDictionary/NSArray
    if ([strRequestMethod isEqualToString:@"GET"])
    {
        [manager GET:serverURL parameters:nil progress:nil success:successBlock failure:failureBlock];
    }
    else
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:serverURL parameters:objParameter progress:nil success:successBlock failure:failureBlock];
    }
    
    //处理发生Session过期，重定向操作
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull redirectResponse, NSURLRequest * _Nonnull request) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)redirectResponse;
        if (httpResponse.statusCode == 302)
        {
            //发生Session过期，禁用重定向操作
            return nil;
        }
        else
        {
            return request;
        }
    }];
}

//登录主业务后台服务器
- (void)loginToRestServer:(id)objParameter result:(NetworkResult)networkResult
{
    //清理Cookie，防止抽奖webView的session同步（切换服务器地址）
    [self deleteCookies];
    
    [self sendPostToServerCommonMethod:@"POST" parameter:objParameter sessionId:nil result:^(id responseObject,NSError *error){
        if (error == nil)
        {
            //暂存登录参数和URL，用于Session超时，然后重新登录使用
            loginParameter = objParameter;
            loginURL = strConnectionURL;
            
            //save 聊天node session ID(获取全局Cookie)
            NSArray *aryCookie = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (int i=0; i<aryCookie.count; i++)
            {
                NSHTTPCookie *httpCookie = [aryCookie objectAtIndex:i];
                if ([httpCookie.name isEqualToString:@"nsid"])
                {
                    //nsid 要进行URL解码(解析%前缀的字符)
                    strChatSessionID = [NSString stringWithFormat:@";nsid=%@",[httpCookie.value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    break;
                }
            }
        }
        
        networkResult(responseObject,error);
    }];
}

//文件批量上传(multipart/form-data方案，缺点是单线程执行完所有文件上传操作)
- (void)uploadBatchFileToServer:(NSArray*)aryFilePath result:(FileUploadResult)fileUploadResult
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (self.completionGroup != nil)
    {
        manager.completionGroup = self.completionGroup;
    }
    if (self.completionQueue != nil)
    {
        manager.completionQueue = self.completionQueue;
    }
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *strFileUploadURL = [strConnectionURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#ifdef DEBUG
    NSLog(@"Upload URL = %@",strFileUploadURL);
#endif
    
    [manager POST:strFileUploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //采用MultipartFormData表单方式，name对应form表单里面的name，可以自定义
        for (NSInteger i=0 ; i<aryFilePath.count ; i++)
        {
            NSString *strFilePath = aryFilePath[i];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:strFilePath] name:[NSString stringWithFormat:@"file%li",(long)i] error:nil];
            #ifdef DEBUG
            NSLog(@"Upload File Path%li = %@",(long)i,strFilePath);
            #endif
        }
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
#ifdef DEBUG
        //打印响应日志（含中文）
        NSString *strResponse = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Response Value = %@",strResponse);
#endif
        
        NSError *errorNetwork = nil;
        NSMutableArray *aryResult = nil;
        
        id responseData = [self getObjectFromJSONData:responseObject];
        if(responseData == nil)
        {
            errorNetwork = [NSError errorWithDomain:VNetworkErrorDomain code:VNetworkResponseNilError userInfo:@{NSLocalizedDescriptionKey:ERROR_TO_SERVER_AF}];
        }
        else
        {
            if (response.statusCode != HTTP_STATUS_OK)
            {
                NSString *strErrorMsg = ERROR_TO_SERVER_AF;
                if ([responseData isKindOfClass:[NSDictionary class]])
                {
                    strErrorMsg = [responseData objectForKey:@"msg"];
                    if (strErrorMsg == nil)
                    {
                        strErrorMsg = ERROR_TO_SERVER_AF;
                    }
                }
                
                errorNetwork = [NSError errorWithDomain:VNetworkErrorDomain code:VNetworkHttpStatusError userInfo:@{NSLocalizedDescriptionKey:strErrorMsg}];
            }
            else
            {
                NSArray *aryResponseData = responseData;
                if([aryResponseData isKindOfClass:[NSArray class]] && aryResponseData.count>0)
                {
                    aryResult = [NSMutableArray array];
                    for (NSDictionary *dicData in aryResponseData)
                    {
                        //成功返回数据
                        UploadFileVo *uplaodFileVo = [[UploadFileVo alloc]init];
                        id fileId = [dicData objectForKey:@"id"];
                        if (fileId == [NSNull null] || fileId == nil)
                        {
                            uplaodFileVo.strID = @"";
                        }
                        else
                        {
                            uplaodFileVo.strID = [fileId stringValue];
                        }
                        
                        uplaodFileVo.strDomain = [self checkStrValue:[dicData objectForKey:@"domain"]]; //??????
                        uplaodFileVo.strFileType = [self checkStrValue:[dicData objectForKey:@"sign"]];
                        if ([uplaodFileVo.strFileType isEqualToString:@"image"])
                        {
                            //上传图片
                            //a:原图
                            uplaodFileVo.strURL = [self checkStrValue:[dicData objectForKey:@"img"]];//包含downloadFile，img-mid、img-min不包含
                            
                            //b:中图
                            uplaodFileVo.strMidURL = [self checkStrValue:[dicData objectForKey:@"img-mid"]];
                            
                            //c:小图
                            uplaodFileVo.strMinURL = [self checkStrValue:[dicData objectForKey:@"img-min"]];
                        }
                        else if ([uplaodFileVo.strFileType isEqualToString:@"document"])
                        {
                            uplaodFileVo.strURL = [self checkStrValue:[dicData objectForKey:@"filePath"]];
                        }
                        else
                        {
                            uplaodFileVo.strURL = [self checkStrValue:[dicData objectForKey:@"img"]];
                        }
                        [aryResult addObject:uplaodFileVo];
                    }
                }
                else
                {
                    errorNetwork = [NSError errorWithDomain:VNetworkErrorDomain code:VNetworkHttpStatusError userInfo:@{NSLocalizedDescriptionKey:ERROR_TO_DATA}];
                }
            }
        }
        fileUploadResult(aryResult,errorNetwork);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Upload Error:%@",error);
        fileUploadResult(nil,error);
    }];
}

//上传文件（二进制文件方式，单个）
- (void)uploadSingleFileWithBinary:(NSString *)strPath result:(NetworkResult)networkResult
{
    //以流的方式上传文件
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *strFileUploadURL = [strConnectionURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#ifdef DEBUG
    NSLog(@"Upload URL = %@",strFileUploadURL);
#endif

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strFileUploadURL]];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"image/%@",[[strPath pathExtension] lowercaseString]] forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:strPath] progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            networkResult(nil,error);
        }
        else
        {
#ifdef DEBUG
            //打印响应日志（含中文）
            NSString *strResponse = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response Value = %@",strResponse);
#endif
            
            id responseData = [self getObjectFromJSONData:responseObject];
            if(responseData == nil)
            {
                NSError *errorNetwork = [NSError errorWithDomain:VNetworkErrorDomain code:VNetworkResponseNilError userInfo:@{NSLocalizedDescriptionKey:ERROR_TO_SERVER_AF}];
                networkResult(nil,errorNetwork);
            }
            else
            {
                
                networkResult(responseData,nil); //success request
            }
        }
    }];
    
    [uploadTask resume];
}

//清理Cookie
- (void)deleteCookies
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

//从JSON的NSData中获得object对象（NSArray、NSDictionary）
- (id)getObjectFromJSONData:(NSData *)data
{
    //如果其中一个字符错误，都会导致整个JSON解析失败
    id jsonObject = nil;
    if (data != nil)
    {
        NSError *error = nil;
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!jsonObject)
        {
            //当解析失败去掉可能的非法字符
            NSString *strJSON = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
#ifdef DEBUG
            NSLog(@"-JSONValue failed. Error trace is: %@,\n JSON:%@", error,strJSON);
#endif
            
            NSString *string = [strJSON stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
            string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            string = [string stringByReplacingOccurrencesOfString:@"" withString:@"_"];
            data = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }
    }
    
    return jsonObject;
}

- (NSString*)checkStrValue:(NSString*)strValue
{
    if (strValue == nil || (id) strValue == [NSNull null])
    {
        strValue = @"";
    }
    return strValue;
}

@end
