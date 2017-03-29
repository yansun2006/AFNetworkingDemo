//
//  UserVo.swift
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/9/5.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

import UIKit
import HandyJSON

class UserVo: NSObject, HandyJSON {
    var id = ""             //用户ID
    var loginAccount = ""       //用户登录名(邮箱或电话号码)
    var aliasName = ""           //用户别名
    var realName = ""           //真实姓名
    var signature = ""          //签名
    var qq = ""                 //QQ
    var phoneNumber = ""        //电话号码
    
    var gender = 2                  //性别	未知=2 0为女，1为男
    var birthday = ""          //出生日期
    var position = ""          //职位
    var email = ""             //邮件
    var address = ""           //个人住址1
    var firstLetter = ""
   
    override required init() { }
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &loginAccount, name: "loginName")
        mapper.specify(property: &birthday, name: "birthdayFormat")
        mapper.specify(property: &realName, name: "trueName")
        mapper.specify(property: &position, name: "title")
    }
}
