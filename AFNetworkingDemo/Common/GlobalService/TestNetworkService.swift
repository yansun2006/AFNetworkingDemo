//
//  TestNetworkService.swift
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/8/31.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

import UIKit
import SwiftyJSON

//测试VisionetNetwork类
class TestNetworkService: NSObject {
    
    //登录操作
    static func loginAction(name: String, password: String, success: (String) -> Void, failure:FailureBlock) {
        var dicBody = Dictionary<String,AnyObject>()
        dicBody["username"] = name
        dicBody["password"] = password
        dicBody["client_flag"] = "ios"
        dicBody["model"] = "iOS Simulator,iPhone OS:9.3"
        
        let network = VisionetNetwork(strURL: "http://vn-functional.chinacloudapp.cn/findest/mobilelogin")
        network.login(dicBody) { (data: AnyObject, error: VNetworkError?) in
            if let error = error {
                failure(error)
            } else {
                let json = JSON(data)
                let version = json["version"].stringValue
                success(version)
            }
        }
    }
    
    //获取用户详情接口
    static func getUserDetail(strID: String, success: (UserVo) -> Void, failure:FailureBlock) {
        let strURL = "http://vn-functional.chinacloudapp.cn/findest/mobile/webUser/userDetail/" + strID
        
        let network = VisionetNetwork(strURL: strURL)
        network.request(.GET) { (data, error) in
            if let error = error {
                failure(error)
            } else {
                let json = JSON(data)
                
                let userVo = UserVo()
                userVo.strUserID = json["id"].stringValue
                userVo.strLoginAccount = json["loginName"].stringValue
                userVo.strSignature = json["signature"].stringValue
                userVo.strQQ = json["qq"].stringValue
                userVo.strPhoneNumber = json["phoneNumber"].stringValue
                
                userVo.gender = json["gender"].intValue
                userVo.strBirthday = json["birthdayFormat"].stringValue
                userVo.strUserName = json["aliasName"].stringValue
                userVo.strRealName = json["trueName"].stringValue
                userVo.strPosition = json["title"].stringValue
                
                userVo.strEmail = json["email"].stringValue
                userVo.strAddress = json["address"].stringValue
                userVo.strFirstLetter = json["firstLetter"].stringValue
                
                success(userVo)
            }
        }
    }
    
    //登出操作
    static func logoutAction(success: (Void) -> Void, failure:FailureBlock) {
        let network = VisionetNetwork(strURL: "http://vn-functional.chinacloudapp.cn/findest/mobilelogout")
        network.request(.GET) { (data, error) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    //文件上传
    static func uploadAction(aryFile: [String],success: (String) -> Void, failure:FailureBlock) {
        let network = VisionetNetwork(strURL: "http://vn-functional.chinacloudapp.cn/findest/upload")
        network.uploadFileList(aryFile) { (data, error) in
            if let error = error {
                failure(error)
            } else {
                print("data:\(data)")
                success("data:\(data)")
            }
        }
    }

}
