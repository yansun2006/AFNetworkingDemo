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
    static func loginAction(name: String, password: String, result: (Bool, String?, String?) -> Void) {
        var dicBody = Dictionary<String,AnyObject>()
        dicBody["username"] = name
        dicBody["password"] = password
        dicBody["client_flag"] = "ios"
        dicBody["model"] = "iOS Simulator,iPhone OS:9.3"
        
        let network = VisionetNetwork(strURL: "http://vn-functional.chinacloudapp.cn/findest/mobilelogin")
        network.login(dicBody) { (data, error) in
            if let error = error {
                result(false, error.localizedDescription,nil)
            } else {
                let json = JSON(data!)
                let version = json["version"].stringValue
                
                result(true, nil ,version)
            }
        }
        
    }
    
    //获取用户详情接口
    static func getUserDetail(strID: String) {
        let strURL = "http://vn-functional.chinacloudapp.cn/findest/mobile/webUser/userDetail/" + strID
        
        let network = VisionetNetwork(strURL: strURL)
        network.request(.GET) { (data, error) in
            if let error = error {
                
            } else {
//                print("data:\(data)")
            }
        }
    }
    
    //登出操作
    static func logoutAction() {
        let network = VisionetNetwork(strURL: "http://vn-functional.chinacloudapp.cn/findest/mobilelogout")
        network.request(.GET) { (data, error) in
            if let error = error {
                
            } else {
//                print("data:\(data)")
            }
        }
    }
    
    //文件上传
    static func uploadAction(aryFile: [String]) {
        let network = VisionetNetwork(strURL: "http://vn-functional.chinacloudapp.cn/findest/upload")
        network.uploadFileList(aryFile) { (data, error) in
            if let error = error {
                
            } else {
//                print("data:\(data)")
            }
        }
    }

}
