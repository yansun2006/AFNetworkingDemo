//
//  FileVo.h
//  SlothSecondProj
//
//  Created by 焱 孙 on 14-6-17.
//  Copyright (c) 2014年 visionet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileVo : NSObject

@property(nonatomic,strong)NSString *strID;//附件ID	下载时需要
@property(nonatomic,strong)NSString *strFolderID;//文件夹ID
@property(nonatomic,strong)NSString *strName;//附件名称
@property(nonatomic,strong)NSString *strFileURL;//附件地址(上传的时候未本地存储路径)


@property(nonatomic,strong)NSString *strCreateBy;//上传者
@property(nonatomic,strong)NSString *strDateTime;

@property(nonatomic)unsigned long long lFileSize;//文件大小(单位是Byte)

@end
