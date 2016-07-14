//
//  Utils.m
//  OnlineNovel
//
//  Created by Ann Yao on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "Common.h"

@implementation Utils

//获取Document路径
+ (NSString *)documentsDirectory 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//获取cache路径
+ (NSString *)cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

//获取tmp路径
+ (NSString *)tmpDirectory
{
    return  NSTemporaryDirectory();
}

//获取文档管理路径:Documents/Sloth2Document/FileDirectory
+ (NSString *)getSloth2DocumentPath
{
    NSString *strTempPathDir = [[Utils documentsDirectory] stringByAppendingPathComponent:SLOTH2_DOC_PATH];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:strTempPathDir];
    if (!fileExists)
    {
        //not exist,then create
        [fileManager createDirectoryAtPath:strTempPathDir withIntermediateDirectories:YES  attributes:nil error:nil];
    }
    return strTempPathDir;
}

//获取音频管理路径:Documents/Sloth2Document/Audio
+ (NSString *)getSloth2AudioPath
{
    NSString *strTempPathDir = [[Utils documentsDirectory] stringByAppendingPathComponent:SLOTH2_AUDIO_PATH];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:strTempPathDir];
    if (!fileExists)
    {
        //not exist,then create
        [fileManager createDirectoryAtPath:strTempPathDir withIntermediateDirectories:YES  attributes:nil error:nil];
    }
    return strTempPathDir;
}

//"temp/TempFile"
+ (NSString *)getTempPath
{
    NSString *strTempPathDir = [[Utils tmpDirectory] stringByAppendingPathComponent:POST_TEMP_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:strTempPathDir];
    if (!fileExists)
    {
        //not exist,then create
        [fileManager createDirectoryAtPath:strTempPathDir withIntermediateDirectories:YES  attributes:nil error:nil];
    }
    return strTempPathDir;
}
//clear "temp/TempFile"
+ (void)clearTempPath
{
    NSString *strTempPathDir = [[Utils tmpDirectory] stringByAppendingPathComponent:POST_TEMP_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:strTempPathDir];
    if (fileExists)
    {
        //delete director
        [fileManager removeItemAtPath:strTempPathDir error:nil];
    }
}

//获取文件大小
+ (NSString *)getFileSize:(NSString *)filePath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
	if(fileAttributes != nil)
    {
		NSString *fileSize = [fileAttributes objectForKey:NSFileSize];
		
        return fileSize;
	}
    
    return nil;
}

//复制文件操作
+ (BOOL)copyFile:(NSString*)strSource toPath:(NSString*)strDest
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    return [fileManager copyItemAtPath:strSource toPath:strDest error:nil];
}

//获取当前的时间字符串 格式yyyy-MM-dd HH:mm:ss
+ (NSString *)getCurrentDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentDateString;
}

//创建UIBarButtonItem按钮
+ (UIButton *)buttonWithImageName:(UIImage *)imgBtn frame:(CGRect)rect target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = rect;
    [button setImage:imgBtn forState:UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//右导航按钮
+ (UIButton *)buttonWithTitle:(NSString*)strTitle frame:(CGRect)rect target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = rect;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    [button setBackgroundImage:[[UIImage imageNamed:@"nav_right_btn"] stretchableImageWithLeftCapWidth:22 topCapHeight:16] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor clearColor];
    [button setTitle:strTitle forState:UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//获取google地图地址
+ (NSString *)googleMapsURLWithLocation:(NSString *)location
{
    return [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?language=zh-cn&location=%@&radius=150&sensor=false&key=AIzaSyCG1Dgw1X1aTP2ntizQvOsUuJccJsLq-OA", location];
}

+(CGRect)getNavRightBtnFrame:(CGSize)sizeOfFrame
{
    float fLeft = kScreenWidth - NAV_BTN_X_OFFSET - sizeOfFrame.width/2;
    float fTop = kStatusBarHeight + (NAV_BAR_HEIGHT-kStatusBarHeight - sizeOfFrame.height/2)/2;
    CGRect rect = CGRectMake(fLeft,fTop, sizeOfFrame.width/2, sizeOfFrame.height/2);
    return rect;
}

+(CGRect)getNavLeftBtnFrame:(CGSize)sizeOfFrame
{
    float fLeft = NAV_BTN_X_OFFSET;
    float fTop = kStatusBarHeight + (NAV_BAR_HEIGHT - kStatusBarHeight - sizeOfFrame.height/2)/2;
    CGRect rect = CGRectMake(fLeft,fTop, sizeOfFrame.width/2, sizeOfFrame.height/2);
    return rect;
}

+ (UIView*)findFirstResponderBeneathView:(UIView*)view 
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

+ (NSString *)getRandom
{
    long time = (long)[[NSDate date] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%ld", time];
}

+(void)writeLogToFile:(NSString*)strContent
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strLogFileName = [dateFormatter stringFromDate:[NSDate date]];

    NSString *strPath = [[Utils getTempPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"log_%@.txt",strLogFileName]];
    [strContent writeToFile:strPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
