//
//  UserVo.swift
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/9/5.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

import UIKit

class UserVo: NSObject {
    var strUserID = ""             //用户ID
    var strUserNodeID = ""         //Node ID
    var strLoginAccount = ""       //用户登录名(邮箱或电话号码)
    var strUserName = ""           //用户别名
    var strRealName = ""           //真实姓名
    var strPassword = ""           //密码
    var strHeadImageURL = ""       //用户头像地址
    var strMaxHeadImageURL = ""    //用户头像大图地址
    var strCoverImageURL = ""      //用户封面地址
    
    var strPartImageURL = ""       //用户头像部分地址（不包含IP前缀）
    var strCompanyID = ""          //公司id
    var strCompanyName = ""        //公司名称
    var strDepartmentId = ""       //部门id
    var strDepartmentName = ""     //部门名称
    var strSignature = ""          //签名
    var strQQ = ""                 //QQ
    var strPhoneNumber = ""        //电话号码
    
    var gender = 2                  //性别	未知=2 0为女，1为男
    var strBirthday = ""          //出生日期
    var strPosition = ""          //职位
    var strEmail = ""             //邮件
    var strAddress = ""           //个人住址1
    var strRemark = ""           //备注
    
    var strFirstLetter = ""
    var nArticleCount = ""               //消息数量
    var nShareCount = ""               //分享数量
    var nQACount = 0               //问答数量
    var nAttentionCount = 0               //关注人数
    var nFansCount = 0               //粉丝人数
    
    var fIntegrationCount = 0.0                //自有积分
    var fBadgeIntegral = 0.0                   //勋章积分（版主）
    var fIntegralDaily = 0.0               //昨日积分
    var nBadge = 0               //勋章类别（0:普通用户; 1:版主; 2:跑鞋; 3:达人; 4:BOSS; 5:慈善）
    var bViewPhone = false            //是否显示手机号码
    var bViewFavorite = false         //是否显示收藏夹
    
    var strJP = ""             //名称简拼
    var strQP = ""             //名称全拼
    var strReceiveMessage = "" //是否接收推送消息
    var strSecID = ""          //该用户的秘书或领导ID
    
}
