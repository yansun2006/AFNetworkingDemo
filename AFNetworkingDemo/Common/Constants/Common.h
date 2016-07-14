//
//  Common.h
//  CorpKnowlGroup
//
//  Created by yuson on 11-4-28.
//  Copyright 2011 DNE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerProvider.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define PAGE_ITEM_COUNT			500
#define POST_TEMP_DIRECTORY @"TempFile"
#define CHAT_TEMP_DIRECTORY @"ChatFile"

//Navigation Bar height,left
#define NAV_BTN_Y_OFFSET    5.5
#define NAV_BTN_X_OFFSET    5

extern int iOSPlatform;
extern CGFloat kScreenWidth;
extern CGFloat kScreenHeight;
extern CGFloat kStatusBarHeight;
extern CGFloat kTabBarHeight;
extern CGFloat NAV_BAR_HEIGHT;
extern NSString *NAV_BG_IMAGE;

extern double g_fFontScale;

double TextH(double fHeight);
BOOL isBigFont();

@interface Common : NSObject 

+ (void) warningAlert:(NSString *)str;
+ (void) tipAlert:(NSString *) str;
+ (void) tipAlert:(NSString *)strContent andTitle:(NSString *)strTitle;

+ (NSString *) getKey:(int)index;
+ (BOOL) IsSubString:(NSString *)srcString subString:(NSString *)destString;

//信息提示
+ (NSString *) ask: (NSString *) question withTextPrompt: (NSString *) prompt;
+ (NSUInteger) ask: (NSString *) question withCancel: (NSString *) cancelButtonTitle withButtons: (NSArray *) buttons;
+ (void) say: (id)formatstring,...;
+ (BOOL) ask: (id)formatstring,...;
+ (BOOL) confirm: (id)formatstring,...;
+ (BOOL) alert: (id)formatstring,...;

+ (NSString *) getMD5Value:(NSString *)str;
+ (NSString *)getStringByKey:(NSString *)key;
+ (void) saveString:(NSString *)object withKey:(NSString *)key;
+ (void) removeStringByKey:(NSString *)key;
+ (void) saveImage:(UIImage *)image ToDocumentFile:(NSString *)file;
+ (NSMutableDictionary *) getFileInfo:(NSString *)fileName;
+ (NSString *) getFilePathFromName:(NSString *)fileName;

+ (void)setUserAccount:(NSString *)strPwd;
+ (NSString *)getUserAccount;

+ (void)setUserPwd:(NSString *)strPwd;
+ (NSString *)getUserPwd;

//获取服务器App版本号
+ (void)setServerAppVersion:(NSString *)strVersion;
+ (NSString *)getServerAppVersion;

//真实姓名和部门是否填写整
+ (void)setInfoCompleteState:(BOOL)bInfoComplete;
+ (BOOL)getInfoCompleteState;

+ (void)setFirstEnterAppState:(BOOL)bFirstEnterApp;
+ (BOOL)getFirstEnterAppState;

+(UIImage*)getImageWithColor: (UIColor *) color;
+(NSString*)getFileIconImageByName:(NSString*)strFileName;
+(NSString*)createImageNameByDateTime;
+(NSString*)createVideoNameByDateTime;
+(UIImage*)getThumbnailFromVideo:(NSURL*)strVideoUrl;
+(float)getTextViewHeight:(int)nWidth andText:(NSString*)strText andViewController:(UIViewController*)tempViewController;
+(NSString *)doSimpleHtmlText:(NSString*)strHtmlText;
+(NSString*)replaceLineBreak:(NSString*)strText;
+(UIImage *)rotateImage:(UIImage *)aImage;
+(NSString*)dataToHexString:(NSData*)data;
+(NSString*)getCurrentDateTime;
+(UIImage *)getImageFromView:(UIView *)orgView;
+(NSString*)getDateStrFromDateTimeStr:(NSString*)strDateTime;
+(NSDate*)getDateFromDateStr:(NSString*)strDateTime;
+(NSString*)getChatTimeStr:(NSString*)strDateTime;
+(NSString*)getChatDateTime:(NSDate*)dateTime;
+(NSString*)getChatTimeStr2:(NSString*)strDateTime;
+(NSString*)getDateTimeStrByDate:(NSDate*)dateTime;
+(NSString*)getDateTimeStrStyle1:(NSString*)strDateTime;
+(NSString*)getDateTimeStrStyle2:(NSString*)strDateTime andFormatStr:(NSString*)strFormat;
+(NSString*)getDateTimeStringFromString:(NSString*)strDateTime format:(NSString*)strFormat;
+(NSDate*)getDateFromString:(NSString*)strDateTime format:(NSString*)strFormat;
+(NSString*)getDateTimeStrFromDate:(NSDate*)date format:(NSString*)strFormat;
+(NSString *)minAndSec:(int)seconds;
+(UITableView*)getTableViewByCell:(UITableViewCell*)tableViewCell;
+(CGFloat)measureHeight:(UITextView*)textView;
+(void)initGlobalValue;
+(NSString*)getDateTimeAndNoSecond:(NSString*)strDateTime;

+(void)setSessionID:(NSString *)strSessionID;
+(NSString *)getSessionID;
+(void)setChatSessionID:(NSString *)strSessionID;
+(NSString *)getChatSessionID;

+(NSString*)checkStrValue:(NSString*)strValue;
+(BOOL)checkIsImageOrNot:(NSString*)strFileName;
+(NSString *)getFileNameFromPath:(NSString *)path;
+(NSString *)getAppVersion;

+(NSString*)createImageNameByDateTimeAndPara:(NSInteger)nPara;
+(NSString*)getDevicePlatform;
+(BOOL)isImageValid:(UIImage*)image;

+ (NSString *)localStr:(NSString *)strKey value:(NSString*)strValue;

+ (NSString*)getFileSizeFormatString:(unsigned long long)lFileSize;
+ (BOOL)checkDoSupportByWebView:(NSString*)strFileName;
+ (CGSize)getStringSize:(NSString*)strContent andFont:(UIFont*)font andBound:(CGSize)size;
+ (CGSize)getStringSize:(NSString*)strContent font:(UIFont*)font bound:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (void)bubbleTip:(NSString*)strText andView:(UIView*)viewParent;
+ (NSString*)createFileNameByDateTime:(NSString*)strExtension;
+ (BOOL)validateMobile:(NSString *)strMobilePhone;
+ (BOOL)validateEmail:(NSString *)strEmail;
+ (BOOL)validateURL:(NSString *)strURL;

+ (void)setButtonTitleHPosition:(UIButton*)button width:(CGFloat)fWidth leftOffset:(CGFloat)fOffset;
+ (void)setButtonImageTitlePosition:(UIButton*)button spacing:(CGFloat)fSpace;
+ (void)setButtonImageLeftTitleRight:(UIButton*)button spacing:(CGFloat)fSpace;
+ (void)setButtonImageRightTitleLeft:(UIButton*)button spacing:(CGFloat)fSpace;
+ (ALAssetsLibrary *)defaultAssetsLibrary;
+ (UIImage*)grayImage:(UIImage*)source;
+ (id)getObjectFromJSONString:(NSString *)str;
+ (id)getObjectFromJSONData:(NSData *)data;

+(void)showProgressView:(NSString*)strText view:(UIView*)view modal:(BOOL)bModal;
+(void)hideProgressView:(UIView*)view;
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end
