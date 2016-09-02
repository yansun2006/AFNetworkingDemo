//
//  VisionetNetwork.swift
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/8/31.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

import Foundation
import Alamofire

enum VNetworkCode :Int {
    case RequestError = -1000       //网络请求错误
    case ResponseNilError           //响应内容为空
    case ResponseDataError           //响应内容为空
    case RequestDataError           //请求数据异常
    case HttpStatusError            //HTTP响应状态错误，不为200
    case HttpRedirectError          //HTTP响应状态302，session无效
    case UnknowError                //未知错误
}

enum VNetworkMethod: String {
    case GET, POST
}

class VisionetNetwork: NSObject {
    
    var responseEncoding = NSUTF8StringEncoding  //响应数据的编码，默认是UTF8,特殊情况可以自定义设置，比如GB18035
    //Chat Session ID
    static var strChatSessionID = ""
    //暂存登录参数和URL，用于Session超时，然后重新登录使用
    static var loginParameter: [String: AnyObject] = [:]
    static var loginURL: String = ""
    
    var strConnectionURL = ""       //服务器地址
    var nRecursiveNum = 0           //控制递归次数，不超过3次
    var nResponseStatusCode = 200   //响应状态
    
    //相关常量定义
    static let VNetworkErrorDomain = "com.visionet.VisionetNetwork"       //错误域对象
    static let ERROR_TO_SERVER_AF = "访问服务器出错,请稍后再试"
    static let ERROR_TO_NETWORK_AF = "网络错误,请稍后再试"
    static let ERROR_TO_REQUEST_DATA = "请求数据异常"
    static let ERROR_TO_RESPONSE_DATA = "响应数据异常"
    static let ERROR_TO_UPLOAD_FILE = "文件上传失败,请稍后再试"
    static let VNETWORK_NOTIFY_LOGINAGAIN = "VNETWORK_NOTIFY_LOGINAGAIN"    //重新登录的通知
    static let HTTP_STATUS_OK = 200
    
    init(strURL: String) {
        strConnectionURL = strURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? ""
    }
    
    //登录主业务后台服务器
    func login(parameters: [String: AnyObject], completionHandler: (AnyObject?, NSError?) -> Void) {
        //清理Cookie，防止抽奖webView的session同步（切换服务器地址）
        clearCookies()
        
        requestAction(.POST, parameters: parameters, sessionId: nil) { (data, error) in
            if error == nil {
                //暂存登录参数和URL，用于Session超时，然后重新登录使用
                VisionetNetwork.loginParameter = parameters
                VisionetNetwork.loginURL = self.strConnectionURL
                
                //保存聊天node session ID(获取全局Cookie)
                if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
                    for cookie in cookies {
                        if cookie.name == "nsid" {
                            //nsid 要进行URL解码(解析%前缀的字符)
                            VisionetNetwork.strChatSessionID = ";nsid=" + (cookie.value.stringByRemovingPercentEncoding ?? "")
                            break
                        }
                    }
                }
            }
            
            completionHandler(data, error)
        }
    }
    
    //请求主业务后台服务器
    func request(method: VNetworkMethod, parameters: [String: AnyObject]? = nil, completionHandler: (AnyObject?, NSError?) -> Void) {
        nRecursiveNum += 1 //控制递归次数(每次请求会初始化为0，当遇到302【Session 超时】，最多三次请求机会)
        requestAction(method, parameters: parameters, sessionId: nil) { (data, error) in
            if self.nResponseStatusCode == 302 && self.nRecursiveNum <= 3 && !VisionetNetwork.loginURL.isEmpty {
                //遇到302，重新请求
                let network = VisionetNetwork(strURL: VisionetNetwork.loginURL)
                network.login(VisionetNetwork.loginParameter, completionHandler: { (data, error) in
                    if error == nil {
                        self.request(method, parameters: parameters, completionHandler: completionHandler)
                        NSNotificationCenter.defaultCenter().postNotificationName(VisionetNetwork.VNETWORK_NOTIFY_LOGINAGAIN, object: data)
                    }
                })
                
            } else {
                completionHandler(data, error)
            }
        }
    }
    
    //请求聊天服务器
    func requestChat(method: VNetworkMethod, parameters: [String: AnyObject]? = nil, completionHandler: (AnyObject?, NSError?) -> Void) {
        nRecursiveNum += 1 //控制递归次数
        requestAction(method, parameters: parameters, sessionId: nil) { (data, error) in
            if self.nResponseStatusCode == 302 && self.nRecursiveNum <= 3  && !VisionetNetwork.loginURL.isEmpty {
                //遇到302，重新请求
                let network = VisionetNetwork(strURL: VisionetNetwork.loginURL)
                network.login(VisionetNetwork.loginParameter, completionHandler: { (data, error) in
                    if error == nil {
                        self.requestChat(method, parameters: parameters, completionHandler: completionHandler)
                        NSNotificationCenter.defaultCenter().postNotificationName(VisionetNetwork.VNETWORK_NOTIFY_LOGINAGAIN, object: data)
                    }
                })
                
            } else {
                completionHandler(data, error)
            }
        }
    }
    
    //上传文件,通过文件路径方式（表单方式批量上传文件）
    func uploadFileList(aryFilePath: [String], completionHandler: ([AnyObject]?, NSError?) -> Void) {
        //打印URL
        #if DEBUG
            print("--Upload Log-------------------------------------------------------------")
            print("Upload URL = " + strConnectionURL)
        #endif
        
        //发起上传请求
        Alamofire.upload(.POST, strConnectionURL, multipartFormData: { multipartFormData in
                //采用MultipartFormData表单方式，name对应form表单里面的name，可以自定义
                for (index, strFilePath) in aryFilePath.enumerate() {
                    multipartFormData.appendBodyPart(fileURL: NSURL.fileURLWithPath(strFilePath), name: "file\(index)")
                    #if DEBUG
                        print("Upload File Path\(index) = " + strFilePath)
                    #endif
                }
            },encodingCompletion: { encodingResult in
                var resultData: [AnyObject]?
                var errorNetwork: NSError?
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseData { response in
                        //打印日志
                        #if DEBUG
                            //Response value（含中文）
                            var strResponse = ""
                            if let responseObject = response.data {
                                strResponse = String(data: responseObject, encoding: NSUTF8StringEncoding) ?? ""
                            }
                            print("Upload Result = " + strResponse)
                        #endif
                        
                        //处理结果
                        self.nResponseStatusCode = response.response?.statusCode ?? 202
                        if let responseData = self.getJsonObjectFormData(response.data) {
                            //错误处理
                            if self.nResponseStatusCode != VisionetNetwork.HTTP_STATUS_OK {
                                var strErrorMsg = VisionetNetwork.ERROR_TO_SERVER_AF
                                if let dicResponse = responseData as? [String: AnyObject] {
                                    strErrorMsg = (dicResponse["msg"] as? String) ?? VisionetNetwork.ERROR_TO_SERVER_AF
                                }
                                errorNetwork = NSError(domain: VisionetNetwork.VNetworkErrorDomain, code: VNetworkCode.HttpStatusError.rawValue, userInfo: [NSLocalizedDescriptionKey : strErrorMsg])
                            } else {
                                //将数据转换成数组
                                switch responseData {
                                case let array as [AnyObject]:
                                    resultData = array
                                case let dictionary as [String : AnyObject]:
                                    resultData = [dictionary]
                                default:
                                    errorNetwork = NSError(domain: VisionetNetwork.VNetworkErrorDomain, code: VNetworkCode.ResponseDataError.rawValue, userInfo: [NSLocalizedDescriptionKey : VisionetNetwork.ERROR_TO_RESPONSE_DATA])
                                }
                            }
                        } else {
                            errorNetwork = NSError(domain: VisionetNetwork.VNetworkErrorDomain, code: VNetworkCode.ResponseNilError.rawValue, userInfo: [NSLocalizedDescriptionKey : VisionetNetwork.ERROR_TO_SERVER_AF])
                        }
                    }
                case .Failure(let encodingError):
                    errorNetwork = NSError(domain: VisionetNetwork.VNetworkErrorDomain, code: VNetworkCode.RequestDataError.rawValue, userInfo: [NSLocalizedDescriptionKey : VisionetNetwork.ERROR_TO_REQUEST_DATA])
                    #if DEBUG
                        print("Upload Result = \(encodingError)")
                    #endif
                }
                
                completionHandler(resultData, errorNetwork)
        })
    }
    
    //////////////////////////////////////////////////////////////////////////////
    //通用的内部方法
    private func requestAction(method: VNetworkMethod, parameters: [String: AnyObject]? = nil, sessionId: String?, completionHandler: (AnyObject?, NSError?) -> Void) {
        //1.init server url、追加SessionID(不对SessionID进行URL编码)
        let serverURL = strConnectionURL + (sessionId ?? "")
        
        //2.start request
        let methodAlamofire = (method == .GET) ? Method.GET : Method.POST
        Alamofire.request(methodAlamofire, serverURL, parameters: parameters, encoding: .JSON)
            .responseData { response in
                //打印日志
                #if DEBUG
                    //打印URL
                    print("--Request Log-------------------------------------------------------------")
                    print("Request URL = " + serverURL)
                    
                    //打印Request Value
                    var strRequest = ""
                    if let parameters = parameters {
                        if let dataLogRequest = try? NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted) {
                            strRequest = String(data: dataLogRequest, encoding: NSUTF8StringEncoding) ?? ""
                        }
                    }
                    print("Request Value = " + strRequest)
                    
                    //Response value（含中文）
                    var strResponse = ""
                    if let responseObject = response.data {
                        strResponse = String(data: responseObject, encoding: NSUTF8StringEncoding) ?? ""
                    }
                    print("Response Value = " + strResponse)
                #endif
                
                //处理结果
                self.nResponseStatusCode = response.response?.statusCode ?? 202
                var resultData: AnyObject?
                var errorNetwork: NSError?
                if let responseData = self.getJsonObjectFormData(response.data) {
                    resultData = responseData
                    //错误处理
                    if self.nResponseStatusCode != VisionetNetwork.HTTP_STATUS_OK {
                        var strErrorMsg = VisionetNetwork.ERROR_TO_SERVER_AF
                        if let dicResponse = responseData as? [String: AnyObject] {
                            strErrorMsg = (dicResponse["msg"] as? String) ?? VisionetNetwork.ERROR_TO_SERVER_AF
                        }
                        errorNetwork = NSError(domain: VisionetNetwork.VNetworkErrorDomain, code: VNetworkCode.HttpStatusError.rawValue, userInfo: [NSLocalizedDescriptionKey : strErrorMsg])
                    }
                    
                } else {
                    errorNetwork = NSError(domain: VisionetNetwork.VNetworkErrorDomain, code: VNetworkCode.ResponseNilError.rawValue, userInfo: [NSLocalizedDescriptionKey : VisionetNetwork.ERROR_TO_SERVER_AF])
                }
                completionHandler(resultData, errorNetwork)
        }
        
        //3.处理发生Session过期，禁用重定向操作
        let sessionDelegate = Alamofire.Manager.sharedInstance.delegate
        sessionDelegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            if response.statusCode == 302 {
                return nil
            } else {
                return request
            }
        }
    }
    
    //清理Cookie
    private func clearCookies() {
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies  {
            for cookie in cookies {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
    }
    
    //从JSON的NSData中获得object对象（NSArray、NSDictionary）
    private func getJsonObjectFormData(data: NSData?) -> AnyObject? {
        //如果其中一个字符错误，都会导致整个JSON解析失败
        var jsonObject: AnyObject?
        if let data = data {
            do {
                try jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                //当解析失败去掉可能的非法字符
                if let strJSON = String(data:data, encoding: responseEncoding) {
                    var json = strJSON.stringByReplacingOccurrencesOfString("\r", withString: "", options:.CaseInsensitiveSearch, range: nil)
                    json = strJSON.stringByReplacingOccurrencesOfString("\n", withString: "", options:.CaseInsensitiveSearch, range: nil)
                    json = strJSON.stringByReplacingOccurrencesOfString("\t", withString: "", options:.CaseInsensitiveSearch, range: nil)
                    
                    if let data1 = json.dataUsingEncoding(NSUTF8StringEncoding) {
                        jsonObject = try? NSJSONSerialization.JSONObjectWithData(data1, options: .AllowFragments)
                    }
                }
            }
        }
        
        return jsonObject
    }
    
}
