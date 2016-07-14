//
//  ServerReturnInfo.h
//  Sloth
//
//  Created by 焱 孙 on 12-11-16.
//
//

#import <Foundation/Foundation.h>

@interface ServerReturnInfo : NSObject

@property(nonatomic,assign)BOOL bSuccess;           //服务器访问成功与失败
@property(nonatomic,retain)NSString *strErrorMsg;   //失败时的错误信息
@property(nonatomic,retain)id data;                 //返回的数据
@property(nonatomic,retain)id data2;                //返回的数据2
@property(nonatomic,retain)id data3;                //返回的数据3

@end
