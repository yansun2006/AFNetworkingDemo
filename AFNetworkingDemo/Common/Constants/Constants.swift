//
//  Constants.swift
//  MinmetalsMeetingProj
//
//  Created by 焱 孙 on 16/4/15.
//  Copyright © 2016年 visionet. All rights reserved.
//

import UIKit

//UIColor初始化函数
func COLOR_SWIFT(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor{
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
}

//Swift Log方法
func logSwift<T>(_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

@objc class Constants: NSObject {
    
    static let strReceiveNodePush: String = "WS_RECEIVE_MSG"    //收到Node推送消息的注册通知名字
    static let strAppName: String = "知新"            //应用名称
    
    static let colorTheme = COLOR_SWIFT(54,103,177,1.0)         //主题色
    
}
