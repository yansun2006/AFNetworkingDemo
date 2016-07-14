//
//  NotifyTypeVo.h
//  SlothSecondProj
//
//  Created by 焱 孙 on 14-3-25.
//  Copyright (c) 2014年 visionet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyTypeVo : NSObject

@property (nonatomic) NSInteger notifyMainType;    //提醒分类ID //通知主类型 11:待办事项 12:回复/评论 13:被@ 14:打赏 15:消息/群组
@property (nonatomic, strong) NSString *strNoticeImage;         //提醒分类icon
@property (nonatomic, strong) NSString *strNotifyTypeName;      //提醒分类名称
@property (nonatomic, strong) NSString *strNotifyNum;           //提醒的数量

@end
