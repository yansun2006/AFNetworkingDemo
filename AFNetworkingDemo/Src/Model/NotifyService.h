//
//  NotifyService.h
//  TaoZhiHuiProj
//
//  Created by 焱 孙 on 16/3/21.
//  Copyright © 2016年 visionet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerProvider.h"
#import "ServerReturnInfo.h"
#import "ServerURL.h"

@interface NotifyService : NSObject

+ (void)getAllNotifyTypeUnreadNum:(ResultBlock)resultBlock;
+ (void)getNotifyListByType:(NSInteger)nType page:(NSInteger)nPageNum result:(ResultBlock)resultBlock;

+ (void)setAllNotifyToRead:(ResultBlock)resultBlock;
+ (void)setNoticeToReadOrNot:(NSString*)strNoticeID type:(NSInteger)nType result:(ResultBlock)resultBlock;
+ (void)setNoticeToReadByType:(NSInteger)nNotifyType result:(ResultBlock)resultBlock;

+ (void)deleteNoticeByID:(NSString*)strNoticeID result:(ResultBlock)resultBlock;
+ (void)deleteNoticeByType:(NSInteger)nNotifyType result:(ResultBlock)resultBlock;

+ (void)updatePushSwitchSetting:(NSMutableArray *)arySetting result:(ResultBlock)resultBlock;
+ (void)getPushSwitchSettingList:(ResultBlock)resultBlock;

@end
