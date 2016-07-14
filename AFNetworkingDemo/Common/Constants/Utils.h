//
//  Utils.h
//  OnlineNovel
//
//  Created by Ann Yao on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//知新2文档模块路径
#define SLOTH2_DOC_PATH @"Sloth2Document/FileDirectory"
#define SLOTH2_DOC_TEMP_PATH @"Sloth2Document/Temp"
#define SLOTH2_AUDIO_PATH @"Sloth2Document/Audio"

@interface Utils : NSObject

//获取Document路径
+ (NSString *) documentsDirectory;

//获取cache路径
+ (NSString *)cacheDirectory;

+ (NSString *)getSloth2DocumentPath;

+ (NSString *)getSloth2AudioPath;

//获取tmp路径
+ (NSString *)tmpDirectory;

+ (NSString *)getTempPath;

+ (void)clearTempPath;

//获取文件大小
+ (NSString *) getFileSize:(NSString *)filePath;

+ (BOOL)copyFile:(NSString*)strSource toPath:(NSString*)strDest;

//获取当前的时间字符串 格式yyyy-MM-dd HH:mm:ss
+ (NSString *)getCurrentDateString;

//创建UIBarButtonItem按钮
+ (UIButton *)buttonWithImageName:(UIImage *)imgBtn frame:(CGRect)rect target:(id)target action:(SEL)action;
+ (UIButton *)buttonWithTitle:(NSString*)strTitle frame:(CGRect)rect target:(id)target action:(SEL)action;
//获取google地图地址 location=[latitude,longitude]
+ (NSString *)googleMapsURLWithLocation:(NSString *)location;

+ (CGRect)getNavRightBtnFrame:(CGSize)sizeOfFrame;

+ (CGRect)getNavLeftBtnFrame:(CGSize)sizeOfFrame;

+ (UIView*)findFirstResponderBeneathView:(UIView*)view ;

+ (NSString *)getRandom;

+(void)writeLogToFile:(NSString*)strContent;

@end
