//
//  VisionetNetwork.swift
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/8/31.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

import Foundation
import Alamofire

//相关常量定义
let VNetworkErrorDomain = "com.visionet.VisionetNetwork"       //错误域对象
private let ERROR_TO_SERVER_AF = "访问服务器出错,请稍后再试"
private let ERROR_TO_NETWORK_AF = "网络错误,请稍后再试"
private let ERROR_TO_REQUEST_DATA = "请求数据异常"
let ERROR_TO_RESPONSE_DATA = "响应数据异常"
private let ERROR_TO_UPLOAD_FILE = "文件上传失败,请稍后再试"
private let VNETWORK_NOTIFY_LOGINAGAIN = "VNETWORK_NOTIFY_LOGINAGAIN"    //重新登录的通知
private let HTTP_STATUS_OK = 200
private let SESSION_ID_KEY = "nsid"

enum VNetworkCode :Int {
    case requestError = -1000       //网络请求错误
    case responseNilError           //响应内容为空
    case responseDataError           //响应内容为空
    case requestDataError           //请求数据异常
    case httpStatusError            //HTTP响应状态错误，不为200
    case httpRedirectError          //HTTP响应状态302，session无效
    case unknowError                //未知错误
}

enum VNetworkMethod: String {
    case get, post
}

typealias FailureBlock = (VNetworkError) -> Void

struct VNetworkError: Error {
    let _domain: String
    let _code: Int
    let errorMessage: String
    
    init(domain: String = VNetworkErrorDomain, code: VNetworkCode = .unknowError, description: String) {
        _domain = domain
        _code = code.rawValue
        errorMessage = description
    }
}

class VisionetNetwork: NSObject {
    
    var responseEncoding = String.Encoding.utf8  //响应数据的编码，默认是UTF8,特殊情况可以自定义设置，比如GB18035
    //Chat Session ID
    static var strChatSessionID = ""
    static var cookieSessionID = ""
    
    //暂存登录参数和URL，用于Session超时，然后重新登录使用
    static var loginParameter: [String: Any] = [:]
    static var loginURL: String = ""
    
    var strConnectionURL = ""       //服务器地址
    var nRecursiveNum = 0           //控制递归次数，不超过3次
    var nResponseStatusCode = 200   //响应状态
    
    init(urlString: String) {
        strConnectionURL = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    //登录主业务后台服务器
    func login(_ parameters: [String: Any], completionHandler: @escaping (Data, VNetworkError?) -> Void) {
        //清理Cookie，防止抽奖webView的session同步（切换服务器地址）
        clearCookies()
        
        requestAction(.post, parameters: parameters, sessionId: nil) { (data, error) in
            if error == nil {
                //暂存登录参数和URL，用于Session超时，然后重新登录使用
                VisionetNetwork.loginParameter = parameters
                VisionetNetwork.loginURL = self.strConnectionURL
                
                //保存聊天node session ID(获取全局Cookie)
                if let cookies = HTTPCookieStorage.shared.cookies {
                    for cookie in cookies {
                        if cookie.name == SESSION_ID_KEY {
                            //nsid 要进行URL解码(解析%前缀的字符)
                            VisionetNetwork.strChatSessionID = ";nsid=" + (cookie.value.removingPercentEncoding ?? "")
                            break
                        }
                    }
                }
            }
            
            completionHandler(data, error)
        }
    }
    
    //请求主业务后台服务器
    func request(_ method: VNetworkMethod, parameters: [String: Any]? = nil, completionHandler: @escaping (Data, VNetworkError?) -> Void) {
        nRecursiveNum += 1 //控制递归次数(每次请求会初始化为0，当遇到302【Session 超时】，最多三次请求机会)
        requestAction(method, parameters: parameters, sessionId: nil) { (data, error) in
            if self.nResponseStatusCode == 302 && self.nRecursiveNum <= 3 && !VisionetNetwork.loginURL.isEmpty {
                //遇到302，重新登录获取新session，然后再请求该接口
                let network = VisionetNetwork(urlString: VisionetNetwork.loginURL)
                network.login(VisionetNetwork.loginParameter) { (data, error) in
                    if error == nil {
                        self.request(method, parameters: parameters, completionHandler: completionHandler)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: VNETWORK_NOTIFY_LOGINAGAIN), object: data)
                    }
                }
            } else {
                completionHandler(data, error)
            }
        }
    }
    
    //请求聊天服务器
    func requestChat(_ method: VNetworkMethod, parameters: [String: Any]? = nil, completionHandler: @escaping (Data, VNetworkError?) -> Void) {
        nRecursiveNum += 1 //控制递归次数
        requestAction(method, parameters: parameters, sessionId: nil) { (data, error) in
            if self.nResponseStatusCode == 302 && self.nRecursiveNum <= 3  && !VisionetNetwork.loginURL.isEmpty {
                //遇到302，重新登录获取新session，然后再请求该接口
                let network = VisionetNetwork(urlString: VisionetNetwork.loginURL)
                network.login(VisionetNetwork.loginParameter) { (data, error) in
                    if error == nil {
                        self.requestChat(method, parameters: parameters, completionHandler: completionHandler)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: VNETWORK_NOTIFY_LOGINAGAIN), object: data)
                    }
                }
                
            } else {
                completionHandler(data, error)
            }
        }
    }
    
    //上传文件,通过文件路径方式（表单方式批量上传文件）
    func uploadFileList(_ aryFilePath: [String], completionHandler: @escaping ([Any], VNetworkError?) -> Void) {
        //打印URL
        #if DEBUG
            print("--Upload Log-------------------------------------------------------------")
            print("Upload URL = " + strConnectionURL)
        #endif
        
        //发起上传请求
        Alamofire.upload(multipartFormData: { multipartFormData in
            //采用MultipartFormData表单方式，name对应form表单里面的name，可以自定义
            for (index, strFilePath) in aryFilePath.enumerated() {
                multipartFormData.append(URL(fileURLWithPath: strFilePath), withName: "file\(index)")
                #if DEBUG
                    print("Upload File Path\(index) = " + strFilePath)
                #endif
            }
        },to: strConnectionURL, encodingCompletion: { encodingResult in
            var resultData: [Any] = [[:]]
            var errorNetwork: VNetworkError?
            
            //编码结果回调，不是请求结果
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseData { response in
                    //打印日志
                    #if DEBUG
                        //Response value（含中文）
                        var strResponse = ""
                        if let responseObject = response.data {
                            strResponse = String(data: responseObject, encoding: .utf8) ?? ""
                        }
                        print("Upload Result = " + strResponse + "\n")
                    #endif
                    
                    //处理结果
                    self.nResponseStatusCode = response.response?.statusCode ?? 202
                    if let responseData = VisionetNetwork.getJsonObjectFromData(response.data, encoding: self.responseEncoding) {
                        if self.nResponseStatusCode != HTTP_STATUS_OK {
                            //错误处理
                            var strErrorMsg = ERROR_TO_SERVER_AF
                            if let dicResponse = responseData as? [String: Any] {
                                strErrorMsg = (dicResponse["msg"] as? String) ?? ERROR_TO_SERVER_AF
                            }
                            errorNetwork = VNetworkError(code: .httpStatusError, description: strErrorMsg)
                        } else {
                            //将数据转换成数组
                            switch responseData {
                            case let array as [Any]:
                                resultData = array
                            case let dictionary as [String : Any]:
                                resultData = [dictionary]
                            default:
                                errorNetwork = VNetworkError(code: .responseDataError, description: ERROR_TO_RESPONSE_DATA)
                            }
                        }
                    } else {
                        errorNetwork = VNetworkError(code: .responseNilError, description: ERROR_TO_SERVER_AF)
                    }
                    completionHandler(resultData, errorNetwork)
                }
            case .failure(let encodingError):
                #if DEBUG
                    print("Upload Result = \(encodingError)" + "\n")
                #endif
                
                errorNetwork = VNetworkError(code: .requestDataError, description: ERROR_TO_REQUEST_DATA)
                completionHandler(resultData, errorNetwork)
            }
        })
        
        //禁用重定向操作（处理发生Session过期）
        let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        let sessionDelegate = sessionManager.delegate
        sessionDelegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            if response.statusCode == 302 {
                return nil
            } else {
                return request
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////
    //通用的内部方法
    fileprivate func requestAction(_ method: VNetworkMethod, parameters: [String: Any]? = nil, sessionId: String?, completionHandler: @escaping (Data, VNetworkError?) -> Void) {
        //1.init server url、追加SessionID(不对SessionID进行URL编码)
        let serverURL = strConnectionURL
        
        //2.start request
        let methodAlamofire = (method == .get) ? HTTPMethod.get : HTTPMethod.post
        
        //3.禁用重定向操作（处理发生Session过期）
        let sessionManager = SessionManager.default
        sessionManager.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            if response.statusCode == 302 {
                return nil
            } else {
                return request
            }
        }
        
        //4.发起请求操作
        sessionManager.request(serverURL, method: methodAlamofire, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            let data = response.data ?? Data()  //如果为空，则初始化一个空Data
            //打印日志
            #if DEBUG
                //打印URL
                print("--HTTP Log-------------------------------------------------------------")
                print("Request URL = " + serverURL)
                
                //打印Request Value
                var strRequest = ""
                if let parameters = parameters {
                    if let dataLogRequest = try? JSONSerialization.data(withJSONObject: parameters) {
                        strRequest = String(data: dataLogRequest, encoding: .utf8) ?? ""
                    }
                }
                print("Request Value = " + strRequest)
                
                //Response value（含中文）
                let strResponse = String(data: data, encoding: self.responseEncoding) ?? ""
                print("Response Value = " + strResponse + "\n")
            #endif
            
            //处理结果
            var errorNetwork: VNetworkError?
            self.nResponseStatusCode = response.response?.statusCode ?? 202
            
            if self.nResponseStatusCode != HTTP_STATUS_OK {
                //非200异常
                var strErrorMsg = ERROR_TO_SERVER_AF
                let responseData = VisionetNetwork.getJsonObjectFromData(data, encoding: self.responseEncoding) //只有异常才解析JOSN,否则直接返回字符串，在Service层处理
                
                if let dicResponse = responseData as? [String: Any], let errorMassage = dicResponse["msg"] as? String, !errorMassage.isEmpty {
                    strErrorMsg = errorMassage
                } else if case let .failure(error) = response.result {
                    strErrorMsg = error.localizedDescription
                } else {
                    strErrorMsg = ERROR_TO_SERVER_AF
                }

                errorNetwork = VNetworkError(code: .httpStatusError, description: strErrorMsg)
            }
            
            completionHandler(data, errorNetwork)
        }
    }
    
    //清理Cookie fileprivate
    func clearCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies  {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    //从JSON的NSData中获得object对象（NSArray、NSDictionary）
    static func getJsonObjectFromData(_ data: Data?, encoding: String.Encoding) -> Any? {
        //如果其中一个字符错误，都会导致整个JSON解析失败
        var jsonObject: Any?
        if let data = data {
            do {
                try jsonObject = JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                //当解析失败去掉可能的非法字符
                if let strJSON = String(data:data, encoding: encoding) {
                    var json = strJSON.replacingOccurrences(of: "\r", with: "", options:.caseInsensitive, range: nil)
                    json = strJSON.replacingOccurrences(of: "\n", with: "", options:.caseInsensitive, range: nil)
                    json = strJSON.replacingOccurrences(of: "\t", with: "", options:.caseInsensitive, range: nil)
                    
                    if let data1 = json.data(using: String.Encoding.utf8) {
                        jsonObject = try? JSONSerialization.jsonObject(with: data1, options: .allowFragments)
                    }
                }
            }
        }
        
        return jsonObject
    }
    
}
