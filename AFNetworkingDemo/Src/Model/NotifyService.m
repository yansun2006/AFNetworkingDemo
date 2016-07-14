//
//  NotifyService.m
//  TaoZhiHuiProj
//
//  Created by 焱 孙 on 16/3/21.
//  Copyright © 2016年 visionet. All rights reserved.
//

#import "NotifyService.h"
#import "VNetworkFramework.h"
#import "NotifyTypeVo.h"
#import "NotifyVo.h"
#import "Common.h"

@implementation NotifyService

//通知提醒/////////////////////////////////////////////////////////
//1.所有提醒分类数量
+ (void)getAllNotifyTypeUnreadNum:(ResultBlock)resultBlock
{
    VNetworkFramework *framework = [[VNetworkFramework alloc] initWithURLString:[ServerURL getNoticeNumURL]];
    [framework startRequestToServer:@"GET" parameter:nil result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc] init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
            NSMutableArray *aryNotifyTypeNum = [NSMutableArray array];
            NSDictionary *responseDic = responseObject;
            
            if ([responseDic isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dicNotifyNum = responseDic;
                //0.提醒总数
                NSString *strAllRemindCount = [Common checkStrValue:[dicNotifyNum objectForKey:@"allRemindCount"]];
                if (strAllRemindCount.length == 0)
                {
                    strAllRemindCount = @"0";
                }
                [aryNotifyTypeNum addObject:strAllRemindCount];
                
                //1.通知
                NSString *strTodo = [Common checkStrValue:[dicNotifyNum objectForKey:@"todo"]];
                if (strTodo.length == 0)
                {
                    strTodo = @"0";
                }
                [aryNotifyTypeNum addObject:strTodo];
                
                //2.赞与评论
                NSString *strReply = [Common checkStrValue:[dicNotifyNum objectForKey:@"reply"]];
                if (strReply.length == 0)
                {
                    strReply = @"0";
                }
                [aryNotifyTypeNum addObject:strReply];
                
                //3.打赏
                NSString *strReward = [Common checkStrValue:[dicNotifyNum objectForKey:@"praise"]];
                if (strReward.length == 0)
                {
                    strReward = @"0";
                }
                [aryNotifyTypeNum addObject:strReward];
                
                //4.私信
                NSString *strMessage = [Common checkStrValue:[dicNotifyNum objectForKey:@"message"]];
                if (strMessage.length == 0)
                {
                    strMessage = @"0";
                }
                [aryNotifyTypeNum addObject:strMessage];
            }
            
            retInfo.data = aryNotifyTypeNum;
        }
        resultBlock(retInfo);
    }];
}

//2.通过分类获取提醒列表
+ (void)getNotifyListByType:(NSInteger)nType page:(NSInteger)nPageNum result:(ResultBlock)resultBlock
{
    NSMutableDictionary *dicBody = [[NSMutableDictionary alloc]init];
    [dicBody setObject:[NSNumber numberWithInteger:nType] forKey:@"type"];
    
    NSMutableDictionary *dicPageInfo = [[NSMutableDictionary alloc] init];
    [dicPageInfo setObject:[NSNumber numberWithInteger:nPageNum] forKey:@"pageNumber"];
    [dicPageInfo setObject:@10 forKey:@"pageSize"];
    [dicBody setObject:dicPageInfo forKey:@"pageInfo"];
    
    VNetworkFramework *networkFramework = [[VNetworkFramework alloc]initWithURLString:[ServerURL getNotifyListByTypeURL]];
    [networkFramework startRequestToServer:@"POST" parameter:dicBody result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc]init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
            
            NSMutableArray *aryNotifyList = [NSMutableArray array];
            NSDictionary *dicResponse = (NSDictionary*)responseObject;
            id content = [dicResponse objectForKey:@"content"];
            if (content != [NSNull null] && content != nil)
            {
                NSArray *aryResponse = (NSArray*)content;
                for (int i=0; i<aryResponse.count; i++)
                {
                    NSDictionary *dicNotify = (NSDictionary*)[aryResponse objectAtIndex:i];
                    NotifyVo *notifyVo = [[NotifyVo alloc]init];
                    notifyVo.strID = [[dicNotify objectForKey:@"id"]stringValue];
                    
                    id sendId = [dicNotify objectForKey:@"sendId"];
                    if (sendId == [NSNull null])
                    {
                        notifyVo.strFromUserID = @"";
                    }
                    else
                    {
                        notifyVo.strFromUserID = [sendId stringValue];
                    }
                    
                    id strRefID = [dicNotify objectForKey:@"refId"];
                    if (strRefID == [NSNull null])
                    {
                        notifyVo.strRefID = @"";
                    }
                    else
                    {
                        notifyVo.strRefID = [strRefID stringValue];
                    }
                    notifyVo.strFromUserName = [Common checkStrValue:[dicNotify objectForKey:@"userNickname"]];// sendName
                    notifyVo.strDescription = [Common checkStrValue:[dicNotify objectForKey:@"description"]];
                    notifyVo.strAssistContent = [Common checkStrValue:[dicNotify objectForKey:@"assistContent"]];
                    notifyVo.strLinkHtml = [Common checkStrValue:[dicNotify objectForKey:@"linkHtml"]];
                    notifyVo.strUserImgUrl = [ServerURL getWholeURL:[Common checkStrValue:[dicNotify objectForKey:@"userImgUrl"]]];
                    notifyVo.strCreateDate = [Common checkStrValue:[dicNotify objectForKey:@"createDate"]];
                    
                    notifyVo.strBlogTitle = [Common checkStrValue:[dicNotify objectForKey:@"blogTitle"]];
                    
                    NSString *strURL = [Common checkStrValue:[dicNotify objectForKey:@"picture"]];
                    NSRange range = [strURL rangeOfString:@"http://" options:NSCaseInsensitiveSearch];
                    if (range.length == 0)
                    {
                        //需要追加前缀
                        notifyVo.strBlogPicture = [ServerURL getWholeURL:strURL];
                    }
                    else
                    {
                        notifyVo.strBlogPicture = strURL;
                    }
                    
                    //类型为消息时,该字段为消息的titleId ； 类型为评论时，该字段为评论id （refId为分享id）
                    id titleId = [dicNotify objectForKey:@"titleId"];
                    if (titleId == [NSNull null])
                    {
                        notifyVo.strTitleID = @"";
                    }
                    else
                    {
                        notifyVo.strTitleID = [titleId stringValue];
                    }
                    
                    id type = [dicNotify objectForKey:@"type"];
                    if (type == [NSNull null])
                    {
                        notifyVo.notifyMainType = -1;
                    }
                    else
                    {
                        notifyVo.notifyMainType = [type intValue];
                    }
                    
                    id subclass = [dicNotify objectForKey:@"subclass"];
                    if (subclass == [NSNull null])
                    {
                        notifyVo.notifySubType = -1;
                    }
                    else
                    {
                        notifyVo.notifySubType = [subclass intValue];
                    }
                    
                    id unread = [dicNotify objectForKey:@"unread"];
                    if (unread == [NSNull null])
                    {
                        notifyVo.nReadState = -1;
                    }
                    else
                    {
                        notifyVo.nReadState = [unread intValue];
                    }
                    
                    [aryNotifyList addObject:notifyVo];
                }
            }
            
            retInfo.data = aryNotifyList;
            
            //获取数据总数（用于停止刷新）
            id totalElements = [dicResponse objectForKey:@"totalElements"];
            if (totalElements != [NSNull null] && totalElements != nil)
            {
                retInfo.data2 = totalElements;
            }
            else
            {
                retInfo.data2 = nil;
            }
        }
        resultBlock(retInfo);
    }];
}

//3.设置某一条的消息为已读或未读,type:[0:设为已读，1:设为未读]
+ (void)setNoticeToReadOrNot:(NSString*)strNoticeID type:(NSInteger)nType result:(ResultBlock)resultBlock
{
    NSString *strURL;
    if (nType == 0)
    {
        //设为已读
        strURL = [NSString stringWithFormat:@"%@/%@",[ServerURL getSetTheNoticeToReadURL],strNoticeID];
    }
    else
    {
        //设为未读
        strURL = [NSString stringWithFormat:@"%@/%@",[ServerURL getSetTheNoticeToReadURL],strNoticeID];
    }
    
    VNetworkFramework *framework = [[VNetworkFramework alloc] initWithURLString:strURL];
    [framework startRequestToServer:@"GET" parameter:nil result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc] init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
        }
        resultBlock(retInfo);
    }];
}

//4.设置所有的消息为已读
+ (void)setAllNotifyToRead:(ResultBlock)resultBlock
{
    VNetworkFramework *framework = [[VNetworkFramework alloc] initWithURLString:[ServerURL getSetAllNotifyToReadURL]];
    [framework startRequestToServer:@"GET" parameter:nil result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc] init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
        }
        resultBlock(retInfo);
    }];
}

//设置某一类的消息为已读
+ (void)setNoticeToReadByType:(NSInteger)nNotifyType result:(ResultBlock)resultBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@/%li",[ServerURL getSetNoticeToReadByTypeURL],(unsigned long)nNotifyType];
    
    VNetworkFramework *framework = [[VNetworkFramework alloc] initWithURLString:strURL];
    [framework startRequestToServer:@"GET" parameter:nil result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc] init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
        }
        resultBlock(retInfo);
    }];
}

+ (void)deleteNoticeByID:(NSString*)strNoticeID result:(ResultBlock)resultBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",[ServerURL getDeleteNoticeByIDURL],strNoticeID];
    
    VNetworkFramework *framework = [[VNetworkFramework alloc] initWithURLString:strURL];
    [framework startRequestToServer:@"GET" parameter:nil result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc] init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
        }
        resultBlock(retInfo);
    }];
}

+ (void)deleteNoticeByType:(NSInteger)nNotifyType result:(ResultBlock)resultBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@/%li",[ServerURL getDeleteNoticeByTypeURL],(unsigned long)nNotifyType];
    
    VNetworkFramework *framework = [[VNetworkFramework alloc] initWithURLString:strURL];
    [framework startRequestToServer:@"GET" parameter:nil result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc] init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
        }
        resultBlock(retInfo);
    }];
}

//更新推送开关接口
+ (void)updatePushSwitchSetting:(NSMutableArray *)arySetting result:(ResultBlock)resultBlock
{
    VNetworkFramework *framework = [[VNetworkFramework alloc] initWithURLString:[ServerURL getUpdatePushSwitchSettingURL]];
    [framework startRequestToServer:@"POST" parameter:arySetting result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc] init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
        }
        resultBlock(retInfo);
    }];
}

//获取推送设置开关列表
+ (void)getPushSwitchSettingList:(ResultBlock)resultBlock
{
    VNetworkFramework *framework = [[VNetworkFramework alloc] initWithURLString:[ServerURL getPushSwitchSettingListURL]];
    [framework startRequestToServer:@"GET" parameter:nil result:^(id responseObject, NSError *error) {
        ServerReturnInfo *retInfo = [[ServerReturnInfo alloc] init];
        if (error)
        {
            retInfo.bSuccess = NO;
            retInfo.strErrorMsg = error.localizedDescription;
        }
        else
        {
            retInfo.bSuccess = YES;
            NSMutableArray *aryNotifyPush = [NSMutableArray array];
            NSArray *aryPushJSON = responseObject;
            
            if ([responseObject isKindOfClass:[NSArray class]] && aryPushJSON.count > 0)
            {
                for (NSArray *arySectionJSON in aryPushJSON)
                {
                    NSMutableArray *arySection = [NSMutableArray array];
                    for (NSDictionary *dicPushJSON in arySectionJSON)
                    {
                        NotifyVo *notifyVo = [[NotifyVo alloc]init];
                        
                        id subclassId = [dicPushJSON objectForKey:@"subclassId"];
                        if (subclassId == [NSNull null]|| subclassId == nil)
                        {
                            notifyVo.notifySubType = 1;
                        }
                        else
                        {
                             notifyVo.notifySubType = [subclassId integerValue];
                        }
                        
                        notifyVo.title = [Common checkStrValue:dicPushJSON[@"subClassName"]];
                        
                        id checked = [dicPushJSON objectForKey:@"checked"];
                        if (checked == [NSNull null]|| checked == nil)
                        {
                            notifyVo.nPush = 1;
                        }
                        else
                        {
                            notifyVo.nPush = [checked integerValue];
                        }
                        [arySection addObject:notifyVo];
                    }
                    
                    if (arySection.count > 0)
                    {
                        [aryNotifyPush addObject:arySection];
                    }
                }
            }
            
            retInfo.data = aryNotifyPush;
        }
        resultBlock(retInfo);
    }];
}

@end
