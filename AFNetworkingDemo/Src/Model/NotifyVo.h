//
//  NotifyVo.h
//  Sloth
//
//  Created by Ann Yao on 12-10-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h> 

//提醒子类别
typedef NS_ENUM(NSInteger,NotifySubType){
    NOTIFY_SUB_RECEIVE_MESSAGE = 1,          //给你发了条消息
    NOTIFY_SUB_REPLY_MESSAGE = 2,           //回复了你的消息
    NOTIFY_SUB_FORWARD_MESSAGE = 4,         //转发了你的消息
    NOTIFY_SUB_VOTE_MESSAGE = 9,           //回应了你发起的投票
    NOTIFY_SUB_SCHEDULE_MESSAGE = 10,        //回应了你发起的约会
    
    NOTIFY_SUB_JOIN_YOUR_GROUP = 12,       //加入了你的群组
    NOTIFY_SUB_EXIT_YOUR_GROUP = 13,          //退出了你的群组
    NOTIFY_SUB_GROUP_MANAGER = 14,         //将您设为群组管理员
    NOTIFY_SUB_INVITE_JOINE_GROUP = 15,          //请你加入了群组
    NOTIFY_SUB_ASK_EXIT_GROUP = 16,           //将你请出了群组
    
    NOTIFY_SUB_COMMENT_SHARE = 30,             //评论了你的分享
    NOTIFY_SUB_COMMENT_COMMENT = 31,         //评论了你的评论
    NOTIFY_SUB_PRAISE_SHARE = 32,          //赞了你的分享
    
    NOTIFY_SUB_ANSWER = 33,                //回答了你的问答
    NOTIFY_SUB_FINISHED_QUESTION = 34,     //答案被原作者标识为已经解决
    NOTIFY_SUB_ADD_ANSWER = 35,          //追加了你的问题答案
    NOTIFY_SUB_PRAISE_QUESTION = 36,          //赞了你的问题
    NOTIFY_SUB_PRAISE_ANSWER = 37,          //赞了你的答案
    NOTIFY_SUB_INVITE_ANSWER_QUESTION = 38,    //邀请你回答问题
    
    NOTIFY_SUB_ATTENTION_ME = 39,             //别人关注我（跳转对方个人中心）
    
    NOTIFY_SUB_ACTIVITY_ATTENTION = 40,             //合理化建议待办
    
    NOTIFY_SUB_MODERATOR_INTEGRAL = 41,            //积分个人打赏
    
    NOTIFY_SUB_AT_SHARE = 42,                   //分享的@功能
    NOTIFY_SUB_AT_COMMENT = 43,                  //评论的@功能
    
    NOTIFY_DRINK_MACHINE_REFUND = 44,          //饮料机退款提醒
    NOTIFY_FOOTBALL_WIN = 45                  //足球竞猜中奖
    
} ;

@interface NotifyVo : NSObject

@property (nonatomic, retain) NSString *strID;              //提醒ID
@property (nonatomic, retain) NSString *strFromUserID;      //发送者ID
@property (nonatomic, retain) NSString *strFromUserName;
@property (nonatomic, retain) NSString *strDescription;     //详情
@property (nonatomic, retain) NSString *strAssistContent;   //提醒辅助内容
@property (nonatomic, retain) NSString *strLinkHtml;        //消息源
@property (nonatomic, retain) NSString *strUserImgUrl;      //发送人头像url
@property (nonatomic) NSInteger nReadState;               //0:已读;1:未读
@property (nonatomic, retain) NSString *strRefID;           //资源ID
@property (nonatomic, retain) NSString *strCreateDate;      //创建日期
@property (nonatomic, retain) NSString *strTitleID;         //类型为消息时,该字段为消息的titleId ；类型为评论时，该字段为评论id （refId为分享id）

@property (nonatomic, retain) NSString *title;      //名称
@property (nonatomic) NSInteger nPush;  //是否推送,1:打开推送；0:关闭推送
@property (nonatomic, assign) int count;

/////////////////////////////////////////////////////////////////////////////
@property (nonatomic, retain) NSString *strBlogTitle;      //分享标题
@property (nonatomic, retain) NSString *strBlogPicture;      //分享第一张图片

@property (nonatomic, assign) NSInteger notifyMainType;      //通知主类型 11:待办事项 12:回复/评论 13:被@ 14:打赏 15:消息/群组
@property (nonatomic, assign) NotifySubType notifySubType;        //通知子类型

@end
