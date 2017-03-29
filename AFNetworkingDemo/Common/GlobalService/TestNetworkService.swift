//
//  TestNetworkService.swift
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/8/31.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

//测试VisionetNetwork类
class TestNetworkService: NSObject {
    
    //登录操作
    static func loginAction(_ name: String, password: String, success: @escaping (String) -> Void, failure: @escaping FailureBlock) {
        var dicBody = Dictionary<String,Any>()
        dicBody["username"] = name
        dicBody["password"] = password
        dicBody["client_flag"] = "ios"
        dicBody["model"] = "iOS Simulator,iPhone OS:9.3"
        
        let network = VisionetNetwork(urlString: "http://vn-functional.chinacloudapp.cn:10080/findest/mobilelogin")
        network.login(dicBody) { (data: Data, error: VNetworkError?) in
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
    static func getUserDetail(_ strID: String, success: @escaping (UserVo) -> Void, failure: @escaping FailureBlock) {
        let urlString = "http://vn-functional.chinacloudapp.cn:10080/findest/mobile/webUser/userDetail/" + strID
        
        let network = VisionetNetwork(urlString: urlString)
        network.request(.get) { (data, error) in
            if let error = error {
                failure(error)
            } else {
                if let userVo = JSONDeserializer<UserVo>.deserializeFrom(json: String(data: data, encoding: .utf8)) {
                    success(userVo)
                } else {
                    failure(VNetworkError(description: ERROR_TO_RESPONSE_DATA))
                }
            }
        }
    }
    
    //登出操作
    static func logoutAction(success: @escaping (Void) -> Void, failure: @escaping FailureBlock) {
        let network = VisionetNetwork(urlString: "http://vn-functional.chinacloudapp.cn:10080/findest/mobilelogout")
        network.request(.get) { (data, error) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    //文件上传
    static func uploadAction(_ aryFilePath: [String],success: @escaping ([Any]) -> Void, failure: @escaping FailureBlock) {
        let network = VisionetNetwork(urlString: "http://vn-functional.chinacloudapp.cn:10080/findest/upload")
        network.uploadFileList(aryFilePath) { (resultList, error) in
            if let error = error {
                failure(error)
            } else {
                if resultList.count > 0 {
                    success(resultList)
                } else {
                    failure(VNetworkError(description: ERROR_TO_RESPONSE_DATA))
                }
            }
        }
    }

}
