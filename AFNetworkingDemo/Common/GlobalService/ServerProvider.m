//
//  ServerProvider.m
//  Sloth
//
//  Created by Ann Yao on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServerProvider.h"
#import "VNetworkFramework.h"
#import "ServerURL.h"
#import "Common.h"

@implementation ServerProvider
//登录到REST server(获取程序版本信息)
+ (void)loginToRestServer:(NSString*)strLoginPhone andPwd:(NSString*)strPwd result:(ResultBlock)resultBlock
{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:strLoginPhone forKey:@"username"];
    [bodyDic setObject:strPwd forKey:@"password"];
    [bodyDic setObject:@"ios" forKey:@"client_flag"];
    
    VNetworkFramework *networkFramework = [[VNetworkFramework alloc]initWithURLString:[ServerURL getLoginToRESTServerURL]];
    [networkFramework loginToRestServer:bodyDic result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc]init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
            
            NSDictionary *responseDic = responseObject;
            //版本号
            retInfo.data = [Common checkStrValue:[responseDic objectForKey:@"version"]];
            [Common setServerAppVersion:retInfo.data];
            
            //登录用户ID
            retInfo.data2 = [Common checkStrValue:[responseDic objectForKey:@"id"]];
            
            //app update url
            NSString *strAppUpdateURL = [Common checkStrValue:[responseDic objectForKey:@"iospath"]];
            [ServerURL setVersionUpdateURL:strAppUpdateURL];
            
            //登录密码
            [Common setUserPwd:strPwd];
            //真实姓名和部门是否填写整(true:完整；false:不完整)
            NSString *strTrueNameCheck = [Common checkStrValue:[responseDic objectForKey:@"trueNameCheck"]];
            if ([strTrueNameCheck isEqualToString:@"false"])
            {
                [Common setInfoCompleteState:NO];
            }
            else
            {
                [Common setInfoCompleteState:YES];
            }
        }
        resultBlock(retInfo);
    }];
}

@end
