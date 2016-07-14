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
        
        let struct1 = Struct1()
        logSwift(struct1.str1)
        logSwift(struct1.str1)
        
        
        let ary: NSMutableArray = ["st1"]
        //let ary1: [String] = ary
        //        let ary1: [String] = ary as! [String]
//        let ary1: [String] = ary as AnyObject as! [String]
//        let ary1: [String] = ary as [AnyObject] as! [String]
        let ary1: [String]? = ary as NSArray as? [String]
        logSwift(ary1!)
        
//        let stringNSArray: NSArray = ["10", "20","30","40","50"]
//        var stringArray:[String] = stringNSArray as! [String]
//        stringArray.append("60")
//        print(stringNSArray,stringArray)
        
        
//        let stringNSArray: NSMutableArray = ["10", "20","30","40","50"]
//        var stringArray:[String] = stringNSArray as! [String]
//        stringArray.append("60")
//        print(stringNSArray,stringArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
