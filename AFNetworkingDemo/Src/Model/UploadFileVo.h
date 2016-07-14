//
//  UploadFileVo.h
//  SlothSecondProj
//
//  Created by 焱 孙 on 14-3-29.
//  Copyright (c) 2014年 visionet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadFileVo : NSObject

@property(nonatomic,strong)NSString *strID;
@property(nonatomic,strong)NSString *strPrefix;
@property(nonatomic,strong)NSString *strFileType;

@property(nonatomic,strong)NSString *strDomain;     //域名前缀
@property(nonatomic,strong)NSString *strURL;
@property(nonatomic,strong)NSString *strMidURL;
@property(nonatomic,strong)NSString *strMinURL;

@end
