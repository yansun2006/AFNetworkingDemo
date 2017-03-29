//
//  TestSwiftViewController.swift
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/6/22.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

import UIKit

class TestSwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        Common.showProgressView("登录中...", view: self.view, modal: false)
        TestNetworkService.loginAction("sunyan", password: "123456", success: { data in
                Common.hideProgressView(self.view)
                Common.tipAlert("版本号：" + data)
            },failure: { error in
                Common.hideProgressView(self.view)
                Common.tipAlert(error._domain)
        })
    }
    
    @IBAction func getUserDetail(_ sender: AnyObject) {
        Common.showProgressView("", view: self.view, modal: false)
        TestNetworkService.getUserDetail("23", success: { data in
                Common.hideProgressView(self.view)
                let userInfo = "account:" + data.loginAccount + ", name:" + data.aliasName
                Common.tipAlert(userInfo)
            }, failure:{ error in
                Common.hideProgressView(self.view)
                Common.tipAlert(error.errorMessage)
        })
    }
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        Common.showProgressView("退出中...", view: self.view, modal: false)
        TestNetworkService.logoutAction(success: {
                Common.hideProgressView(self.view)
            }, failure: { error in
                Common.hideProgressView(self.view)
        })
    }
    
    @IBAction func uploadAction(_ sender: AnyObject) {
        var aryFile = [String]()
        aryFile.append(Bundle.main.path(forResource: "apk_preview", ofType:"png") ?? "")
        aryFile.append(Bundle.main.path(forResource: "app_preview", ofType:"png") ?? "")
        aryFile.append(Bundle.main.path(forResource: "caf_preview", ofType:"png") ?? "")
        
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
