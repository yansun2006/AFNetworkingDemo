//
//  TestSwiftViewController.swift
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/6/22.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://example.com"
    static let perPage = 50
    
    case Search(query: String, page: Int)
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, parameters: [String: AnyObject]) = {
            switch self {
            case .Search(let query, let page) where page > 0:
                return ("/search", ["q": query, "offset": Router.perPage * page])
            case .Search(let query, _):
                return ("/search", ["q": query])
            }
        }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }

    static let str1: String = "123"
    
    static var str2: String = "123"
//    lazy var string: String = {
//        return "123"
//    } ()
}

//Alamofire.request(Router.Search(query: "foo bar", page: 1)) // ?q=foo%20bar&offset=50

struct Struct1 {
    var str1: String = {
        logSwift("call str1 property")
        return "123"
    }()
}


class TestSwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        
//        let struct1 = Struct1()
//        logSwift(struct1.str1)
//        logSwift(struct1.str1)
//        
//        
//        let ary: NSMutableArray = ["st1"]
//        //let ary1: [String] = ary
//        //        let ary1: [String] = ary as! [String]
////        let ary1: [String] = ary as AnyObject as! [String]
////        let ary1: [String] = ary as [AnyObject] as! [String]
//        let ary1: [String]? = ary as NSArray as? [String]
//        logSwift(ary1!)
//        
//        let stringNSArray: NSArray = ["10", "20","30","40","50"]
//        var stringArray:[String] = stringNSArray as! [String]
//        stringArray.append("60")
//        print(stringNSArray,stringArray)
        
        
//        let stringNSArray: NSMutableArray = ["10", "20","30","40","50"]
//        var stringArray:[String] = stringNSArray as! [String]
//        stringArray.append("60")
//        print(stringNSArray,stringArray)
        
//        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
//        
//        func backwards(s1: String, s2: String) -> Bool {
//            return s1 > s2
//        }
//        var reversed = names.sort(backwards)
//        reversed = names.sort() { (s1: String, s2: String) in
//            return s1 > s2
//        }
//        print(reversed)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        Common.showProgressView("登录中...", view: self.view, modal: false)
        TestNetworkService.loginAction("sunyan", password: "123456", success: { data in
                Common.hideProgressView(self.view)
                Common.tipAlert("版本号：" + data)
            },failure: { error in
                Common.hideProgressView(self.view)
                Common.tipAlert(error._domain)
        })
    }
    
    @IBAction func getUserDetail(sender: AnyObject) {
        Common.showProgressView("", view: self.view, modal: false)
        TestNetworkService.getUserDetail("23", success: { data in
                Common.hideProgressView(self.view)
                let userInfo = "account:" + data.strLoginAccount + ", name:" + data.strUserName
                Common.tipAlert(userInfo)
            }, failure:{ error in
                Common.hideProgressView(self.view)
                Common.tipAlert(error.errorMessage)
        })
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        Common.showProgressView("退出中...", view: self.view, modal: false)
        TestNetworkService.logoutAction({
                Common.hideProgressView(self.view)
            }, failure: { error in
                Common.hideProgressView(self.view)
        })
    }
    
    @IBAction func uploadAction(sender: AnyObject) {
        var aryFile = [String]()
        aryFile.append(NSBundle.mainBundle().pathForResource("apk_preview", ofType:"png") ?? "")
        aryFile.append(NSBundle.mainBundle().pathForResource("app_preview", ofType:"png") ?? "")
        aryFile.append(NSBundle.mainBundle().pathForResource("caf_preview", ofType:"png") ?? "")
        
        Common.showProgressView("上传中...", view: self.view, modal: false)
        TestNetworkService.uploadAction(aryFile, success: { data in
                Common.hideProgressView(self.view)
                print("\(data)")
            }, failure: { error in
                Common.hideProgressView(self.view)
                Common.tipAlert(error.errorMessage)
        })
    }

}
