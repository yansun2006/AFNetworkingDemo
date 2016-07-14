//
//  Common.m
//  CorpKnowlGroup
//
//  Created by yuson on 11-4-28.
//  Copyright 2011 DNE. All rights reserved.
//

#import "Common.h"
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include "MBProgressHUD.h"
#import "Constants.h"

static NSString *g_userAccount;                     //用户名
static NSString *g_userPwd;                     //用户密码
static NSString *g_serverAppVersion;            //应用的服务器版本
static NSString *g_sessionID;                   //REST Server Session ID
static NSString *g_chatSessionID;               //Chat Session ID
static BOOL g_bInfoComplete = YES;              //真实姓名和部门是否填写整(YES:完整,NO:不完整)
static BOOL g_bFirstEnterApp = NO;              //应用首次安装或者更新应用后第一次进入应用

int iOSPlatform	= 6;
CGFloat kScreenWidth	= 0.0;
CGFloat kScreenHeight = 0.0;
CGFloat kStatusBarHeight = 0.0f;
CGFloat kTabBarHeight = 49.0f;
CGFloat NAV_BAR_HEIGHT = 44.0;
NSString *NAV_BG_IMAGE = @"nav_ios6";

double g_fFontScale	= 1.0;                   //文字大小比例系数

//Dynaimc Text Height
double TextH(double fHeight)
{
    return fHeight*g_fFontScale;
}

BOOL isBigFont()
{
    BOOL bRes = NO;
    NSInteger nSize = TextH(10000);
    if (nSize>10000)
    {
        bRes = YES;
    }
    return bRes;
}

#define TEXT_FIELD_TAG	9999

@interface ModalAlertDelegate : NSObject <UIAlertViewDelegate, UITextFieldDelegate> 
{
	CFRunLoopRef currentLoop;
	NSString *text;
	NSUInteger index;
}
@property (assign) NSUInteger index;
@property (retain) NSString *text;
@end

@implementation ModalAlertDelegate
@synthesize index;
@synthesize text;

-(id) initWithRunLoop: (CFRunLoopRef)runLoop 
{
	if (self = [super init]) currentLoop = runLoop;
	return self;
}


// User pressed button. Retrieve results
-(void)alertView:(UIAlertView*)aView clickedButtonAtIndex:(NSInteger)anIndex 
{
	UITextField *tf = (UITextField *)[aView viewWithTag:TEXT_FIELD_TAG];
	if (tf) self.text = tf.text;
	self.index = anIndex;
	CFRunLoopStop(currentLoop);
}

- (BOOL) isLandscape
{
	return ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight);
}

// Move alert into place to allow keyboard to appear
- (void) moveAlert: (UIAlertView *) alertView
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.25f];
	if (![self isLandscape])
		alertView.center = CGPointMake(160.0f, 180.0f);
	else 
		alertView.center = CGPointMake(240.0f, 90.0f);
	[UIView commitAnimations];
	
	[[alertView viewWithTag:TEXT_FIELD_TAG] becomeFirstResponder];
}

- (void) dealloc
{
	self.text = nil;
	//[super dealloc];
}

@end

@implementation Common

+ (void) warningAlert:(NSString *)str
{
	UIAlertView *endAlert =[[UIAlertView alloc] initWithTitle:@"警告"  message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];	
	[endAlert show];
}

+ (void) tipAlert:(NSString *)str
{
	UIAlertView *endAlert =[[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[endAlert show];
}

+ (void) tipAlert:(NSString *)strContent andTitle:(NSString *)strTitle
{
	UIAlertView *endAlert =[[UIAlertView alloc] initWithTitle:strTitle message:strContent delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];	
	[endAlert show];
}

+ (NSString *) getKey:(int)index
{
	NSString *key = [NSString stringWithFormat:@"index%d",index];
	
	return key;
}

+ (BOOL) IsSubString:(NSString *)srcString subString:(NSString *)destString
{
	NSComparisonResult result = [srcString compare:destString options:NSCaseInsensitiveSearch
												   range:NSMakeRange(0, destString.length)];
	if (result == NSOrderedSame)
		return YES;
	else
		return NO;
}

+ (NSUInteger) ask: (NSString *) question withCancel: (NSString *) cancelButtonTitle withButtons: (NSArray *) buttons
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:nil delegate:madelegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	for (NSString *buttonTitle in buttons) [alertView addButtonWithTitle:buttonTitle];
	[alertView show];
	
	// Wait for response
	CFRunLoopRun();
	
	// Retrieve answer
	NSUInteger answer = madelegate.index;
//	[alertView release];
//	[madelegate release];
	return answer;
}

+ (void) say: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	[Common ask:statement withCancel:@"Okay" withButtons:nil];
	//[statement release];
}

+ (BOOL) ask: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = ([Common ask:statement withCancel:nil withButtons:[NSArray arrayWithObjects:@"是", @"否", nil]] == 0);
	//[statement release];
	return answer;
}

+ (BOOL) alert: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = ([Common ask:statement withCancel:nil withButtons:[NSArray arrayWithObjects:@"好", nil]] == 0);
	//[statement release];
	return answer;
}

+ (BOOL) confirm: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = [Common ask:statement withCancel:@"Cancel" withButtons:[NSArray arrayWithObject:@"OK"]];
	//[statement release];
	return	answer;
}

+(NSString *) textQueryWith: (NSString *)question prompt: (NSString *)prompt button1: (NSString *)button1 button2:(NSString *) button2
{
	// Create alert
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:@"\n" delegate:madelegate cancelButtonTitle:button1 otherButtonTitles:button2, nil];
	
	// Build text field
	UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 30.0f)];
	tf.borderStyle = UITextBorderStyleRoundedRect;
	tf.tag = TEXT_FIELD_TAG;
	tf.placeholder = prompt;
	tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf.keyboardType = UIKeyboardTypeAlphabet;
	tf.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
	tf.autocorrectionType = UITextAutocorrectionTypeNo;
	tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	
	// Show alert and wait for it to finish displaying
	[alertView show];
	while (CGRectEqualToRect(alertView.bounds, CGRectZero));
	
	// Find the center for the text field and add it
	CGRect bounds = alertView.bounds;
	tf.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f - 10.0f);
	[alertView addSubview:tf];
	//[tf release];
	
	// Set the field to first responder and move it into place
	[madelegate performSelector:@selector(moveAlert:) withObject:alertView afterDelay: 0.7f];
	
	// Start the run loop
	CFRunLoopRun();
	
	// Retrieve the user choices
	NSUInteger index = madelegate.index;
	NSString *answer = [madelegate.text copy] ;
	if (index == 0) answer = nil; // assumes cancel in position 0
		
		//[alertView release];
	//[madelegate release];
	return answer;
}

+ (NSString *) ask: (NSString *) question withTextPrompt: (NSString *) prompt
{
	return [Common textQueryWith:question prompt:prompt button1:@"Cancel" button2:@"OK"];
}

+ (NSString *) getMD5Value:(NSString *)str
{
	const char *cStr = [str UTF8String]; 
    unsigned char result[16]; 
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat: 
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7], 
            result[8], result[9], result[10], result[11], 
            result[12], result[13], result[14], result[15] 
            ]; 
}

+ (NSString *) getStringByKey:(NSString *)key
{
	NSUserDefaults *userInformation = [NSUserDefaults standardUserDefaults];
	return [userInformation stringForKey:key];
}

+ (void) saveString:(NSString *)object withKey:(NSString *)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:object forKey:key];
	[defaults synchronize];
}

+ (void) removeStringByKey:(NSString *)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:key];
	[defaults synchronize];
}

+ (void) saveImage:(UIImage *)image ToDocumentFile:(NSString *)file
{
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:file];
	
	success = [fileManager fileExistsAtPath:imageFile];
	if(success) 
    {
		[fileManager removeItemAtPath:imageFile error:&error];
	}
	
	[UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFile atomically:YES];
}

+ (NSMutableDictionary *) getFileInfo:(NSString *)fileName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// Get file size
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
	NSString * mb_String = nil;
	if(fileAttributes != nil)
	{
		NSString *fileSize = [fileAttributes objectForKey:NSFileSize];
		long long n_FileSize = [fileSize longLongValue];
		float kb_size = n_FileSize*1.0f/1024;
		float mb_size = kb_size*1.0f/1024;
		
		mb_String = [NSString stringWithFormat:@"%.2f MB",mb_size];
	}
	
	//data string
	NSDate * date = [fileAttributes objectForKey:NSFileModificationDate];
	NSMutableDictionary * savedDictionary = [NSMutableDictionary dictionary];
	if( mb_String)
	{
		[savedDictionary setObject:mb_String forKey:@"fileSizeMB"];
        
		NSString *fileSize = [fileAttributes objectForKey:NSFileSize];
		[savedDictionary setObject:fileSize forKey:@"fileSize"];
	}
    
	// date
	if(date)
	{
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss:a"];
		
		NSString * string = [formatter stringFromDate:date];
		[savedDictionary setObject:string forKey:@"modifyDate"];
        //[formatter release];
	}
	
	NSString * fileType = [fileAttributes objectForKey:NSFileType];
	NSString * myFileName = [NSString stringWithFormat:@"%@.%@",[fileAttributes objectForKey:@"NSFileOwnerAccountName"],fileType];
	[savedDictionary setObject:myFileName forKey:@"fileName"];
	
	return savedDictionary;
}

+ (NSString *) getFilePathFromName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (void)setUserAccount:(NSString *)strAccount {
    if (g_userAccount != strAccount) {
        g_userAccount = [strAccount copy];
    }
}
+ (NSString *)getUserAccount {
    return g_userAccount;
}

//获取登录用户的密码
+ (void)setUserPwd:(NSString *)strPwd
{
    if (g_userPwd != strPwd) 
	{
        //[g_userPwd release];
        g_userPwd = [strPwd copy];
    }
}
+ (NSString *) getUserPwd
{
	return g_userPwd;
}

//获取服务器App版本号
+ (void)setServerAppVersion:(NSString *)strVersion
{
    if (g_serverAppVersion != strVersion)
    {
        g_serverAppVersion = [strVersion copy];
    }
}
+ (NSString *)getServerAppVersion
{
    return g_serverAppVersion;
}

//SESSION ID 
+ (void)setSessionID:(NSString *)strSessionID
{
    if (g_sessionID != strSessionID) 
	{
        //[g_sessionID release];
        g_sessionID = [strSessionID copy];
    }
}
+ (NSString *)getSessionID
{
	return g_sessionID;
}

//CHAT SESSION ID
+ (void)setChatSessionID:(NSString *)strSessionID
{
    if (g_chatSessionID != strSessionID)
    {
        g_chatSessionID = [strSessionID copy];
    }
}
+ (NSString *)getChatSessionID
{
    return g_chatSessionID;
}

//真实姓名和部门是否填写整
+ (void)setInfoCompleteState:(BOOL)bInfoComplete
{
        g_bInfoComplete = bInfoComplete;
}
+ (BOOL)getInfoCompleteState
{
	return g_bInfoComplete;
}

//应用首次安装或者更新应用后第一次进入应用
+ (void)setFirstEnterAppState:(BOOL)bFirstEnterApp
{
    g_bFirstEnterApp = bFirstEnterApp;
}
+ (BOOL)getFirstEnterAppState
{
    return g_bFirstEnterApp;
}

+ (UIImage *)getImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(NSString *)doSimpleHtmlText:(NSString*)strHtmlText
{
    NSString *strTemp = [strHtmlText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    strTemp = [strTemp stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    strTemp = [strTemp stringByReplacingOccurrencesOfString:@"<br />" withString:@"\r\n"];
    strTemp = [strTemp stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return strTemp;
}

+(NSString*)getFileIconImageByName:(NSString*)strFileName
{
    NSString *strFileExtension = [strFileName pathExtension].lowercaseString;
    NSString *strImgName = @"file_preview";
    NSString *strExistType = @"apk,app,caf,doc,docx,file,ipa,mov,mp3,mp4,pdf,ppt,pptx,rar,xls,xlsx,zip,txt";
    NSRange range = [strExistType rangeOfString:strFileExtension];
    if (range.length>0)
    {
        //exist file type
        strImgName = [NSString stringWithFormat:@"%@_preview",strFileExtension];
    }
    return strImgName;
}

+(BOOL)checkIsImageOrNot:(NSString*)strFileName
{
    BOOL bIsImage = NO;
    NSString *strFileExtension = [strFileName pathExtension].lowercaseString;
    NSString *strExistType = @"png,jpg,jpeg,bmp,gif,tiff,ico";
    NSRange range = [strExistType rangeOfString:strFileExtension];
    if (range.length>0)
    {
        //exist file type
        bIsImage = YES;
    }
    return bIsImage;
}

+(NSString*)createImageNameByDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"]; 
    NSString *strDateTime = [dateFormatter stringFromDate:[NSDate date]]; 
    //[dateFormatter release];
    strDateTime = [NSString stringWithFormat:@"%@.jpg",strDateTime];
    return strDateTime;
}

+(NSString*)createVideoNameByDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"]; 
    NSString *strDateTime = [dateFormatter stringFromDate:[NSDate date]]; 
    //[dateFormatter release];
    strDateTime = [NSString stringWithFormat:@"%@.mov",strDateTime];
    return strDateTime;
}

+(UIImage*)getThumbnailFromVideo:(NSURL*)strVideoUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:strVideoUrl options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:nil];
    //[generate release];
    //[asset release];
    
    UIImage *imgRet = [[UIImage alloc] initWithCGImage:imgRef];
    CFRelease(imgRef);
    
    return imgRet;
}

+(float)getTextViewHeight:(int)nWidth andText:(NSString*)strText andViewController:(UIViewController*)tempViewController
{
    float fHeight = 0.0;
    if (strText == nil || strText.length == 0)
    {
        return fHeight;
    }
    else
    {
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, nWidth, 1)];
        textView.font = [UIFont systemFontOfSize:15];
        textView.text = strText;
        [tempViewController.view addSubview:textView];
        //fHeight = textView.contentSize.height;
        fHeight = [Common measureHeight:textView];
        [textView removeFromSuperview];
        //[textView release];
        DLog(@"fHeight:%f",fHeight);
        return fHeight;
    }
}

+ (CGFloat)measureHeight:(UITextView*)textView
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
//    {
        CGRect frame = textView.bounds;
        CGSize fudgeFactor;
        // The padding added around the text on iOS6 and iOS7 is different.
        fudgeFactor = CGSizeMake(10.0, 16.0);
        
        frame.size.height -= fudgeFactor.height;
        frame.size.width -= fudgeFactor.width;
        
        NSMutableAttributedString* textToMeasure;
        if(textView.attributedText && textView.attributedText.length > 0)
        {
            textToMeasure = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        }
        else
        {
            textToMeasure = [[NSMutableAttributedString alloc] initWithString:textView.text];
            [textToMeasure addAttribute:NSFontAttributeName value:textView.font range:NSMakeRange(0, textToMeasure.length)];
        }
        
        if ([textToMeasure.string hasSuffix:@"\n"])
        {
            NSAttributedString *attributedString= [[NSAttributedString alloc] initWithString:@"-" attributes:@{NSFontAttributeName: textView.font}];
            [textToMeasure appendAttributedString:attributedString];
            //[attributedString release];
        }
        
        // NSAttributedString class method: boundingRectWithSize:options:context is
        // available only on ios7.0 sdk.
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT) 
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
        
        return CGRectGetHeight(size) + fudgeFactor.height;
//    }
//    else
//    {
//        return textView.contentSize.height;
//    }
#else
    return textView.contentSize.height;
#endif
}

+(NSString*)replaceLineBreak:(NSString*)strText
{
    if (strText == nil || strText.length == 0)
    {
        strText = nil;
    }
    else
    {
//        strText = [strText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        strText = [strText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    return strText;
}

+(UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    UIImageOrientation orient = aImage.imageOrientation;
    UIImageOrientation newOrient = UIImageOrientationUp;
    switch (orient) 
    {
        case 3://竖拍 home键在下
            newOrient = UIImageOrientationRight;
            break;
        case 2://倒拍 home键在上
            newOrient = UIImageOrientationLeft;
            break;
        case 0://左拍 home键在右
            newOrient = UIImageOrientationUp;
            break;
        case 1://右拍 home键在左
            newOrient = UIImageOrientationDown;
            break;
        default:
            newOrient = UIImageOrientationRight;
            break;
    }
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGFloat ratio = 0;
    if ((width > 1024) || (height > 1024)) 
    {
        if (width >= height) 
        {
            ratio = 1024/width;
        }
        else 
        {
            ratio = 1024/height;
        }
        width *= ratio;
        height *= ratio;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    switch(newOrient)
    {
        case UIImageOrientationUp: 
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationDown: 
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft: 
            
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRight: 
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (newOrient == UIImageOrientationRight || newOrient == UIImageOrientationLeft) 
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else 
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

+(NSString*)dataToHexString:(NSData*)data
{
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    NSUInteger strLen = 2*nbBytes;
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) 
    {
        [hex appendFormat:@"%02X", bytes[i]];
        //We need to increment here so that the every-n-bytes computations are right.
        ++i;
    }
    return hex;
}

+(NSString*)getCurrentDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]]; 
    return strDate;
}

+(UIImage *)getImageFromView:(UIView *)orgView
{ 
	UIGraphicsBeginImageContext(orgView.bounds.size); 
    
	[orgView.layer renderInContext:UIGraphicsGetCurrentContext()]; 	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); 		
	UIGraphicsEndImageContext(); 
    
	return image;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
+(NSString*)getDateStrFromDateTimeStr:(NSString*)strDateTime
{
    NSString *strDate = @"";
    if (strDateTime == nil || strDateTime.length == 0)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
        NSDate *dateTime = [dateFormatter dateFromString:strDateTime]; 
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; 
        strDate = [dateFormatter stringFromDate:dateTime];
    }
    
    return strDate;
}

+(NSDate*)getDateFromDateStr:(NSString*)strDateTime
{
    NSDate *date = nil;
    if (strDateTime == nil || strDateTime.length == 0)
    {
        date = nil;
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; 
        date = [dateFormatter dateFromString:strDateTime];
    }
    return date;
}

+(NSString*)getChatTimeStr:(NSString*)strDateTime
{
    NSString *strDate = @"";
    if (strDateTime == nil || strDateTime.length == 0)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
        NSDate *dateTime = [dateFormatter dateFromString:strDateTime]; 
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; 
        strDate = [dateFormatter stringFromDate:dateTime]; 
        
        NSString *strToday = [dateFormatter stringFromDate:[NSDate date]]; 
        if([strDate isEqualToString:strToday])
        {
            //today
            [dateFormatter setDateFormat:@"HH:mm"];
            strDate = [dateFormatter stringFromDate:dateTime]; 
        }
    }
    return strDate;
}

+(NSString*)getChatDateTime:(NSDate*)dateTime
{
    NSString *strDate = @"";
    if (dateTime == nil)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yy-MM-dd"]; 
        strDate = [dateFormatter stringFromDate:dateTime]; 
        
        NSString *strToday = [dateFormatter stringFromDate:[NSDate date]]; 
        if([strDate isEqualToString:strToday])
        {
            //today
            [dateFormatter setDateFormat:@"HH:mm"];
            strDate = [dateFormatter stringFromDate:dateTime]; 
        }
    }
    return strDate;
}

+(NSString*)getDateTimeStrByDate:(NSDate*)dateTime
{
    NSString *strDate = @"";
    if (dateTime == nil)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yy-MM-dd hh:mm:ss"];
        strDate = [dateFormatter stringFromDate:dateTime];
    }
    return strDate;
}

+(NSString*)getChatTimeStr2:(NSString*)strDateTime
{
    NSString *strDate = @"";
    if (strDateTime == nil || strDateTime.length == 0)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
        NSDate *dateTime = [dateFormatter dateFromString:strDateTime]; 
        
        [dateFormatter setDateFormat:@"yy-MM-dd"]; 
        strDate = [dateFormatter stringFromDate:dateTime]; 
        
        NSString *strToday = [dateFormatter stringFromDate:[NSDate date]]; 
        if([strDate isEqualToString:strToday])
        {
            //today
            [dateFormatter setDateFormat:@"HH:mm"];
            strDate = [dateFormatter stringFromDate:dateTime]; 
        }
        else
        {
            [dateFormatter setDateFormat:@"MM-dd HH:mm"]; 
            strDate = [dateFormatter stringFromDate:dateTime]; 
        }
    }
    return strDate;
}

+(NSString*)getDateTimeAndNoSecond:(NSString*)strDateTime
{
    NSString *strDate = @"";
    if (strDateTime == nil || strDateTime.length == 0)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateTime = [dateFormatter dateFromString:strDateTime];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        strDate = [dateFormatter stringFromDate:dateTime];
    }
    
    return strDate;
}

+(NSString*)getDateTimeStrStyle1:(NSString*)strDateTime
{
    NSString *strDate = @"";
    if (strDateTime == nil || strDateTime.length == 0)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateTime = [dateFormatter dateFromString:strDateTime];
        
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        strDate = [dateFormatter stringFromDate:dateTime];
    }
    return strDate;
}

+(NSString*)getDateTimeStrStyle2:(NSString*)strDateTime andFormatStr:(NSString*)strFormat
{
    NSString *strDate = @"";
    if (strDateTime == nil || strDateTime.length == 0)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateTime = [dateFormatter dateFromString:strDateTime];
        
        [dateFormatter setDateFormat:strFormat];
        strDate = [dateFormatter stringFromDate:dateTime];
    }
    return strDate;
}

+(NSString*)getDateTimeStringFromString:(NSString*)strDateTime format:(NSString*)strFormat
{
    NSString *strDate;
    if (strDateTime == nil || strDateTime.length == 0)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateTime = [dateFormatter dateFromString:strDateTime];
        
        [dateFormatter setDateFormat:strFormat];
        strDate = [dateFormatter stringFromDate:dateTime];
        
        if (strDate == nil)
        {
            strDate = @"";
        }
    }
    return strDate;
}

+(NSDate*)getDateFromString:(NSString*)strDateTime format:(NSString*)strFormat
{
    NSDate *date = nil;
    if (strDateTime == nil || strDateTime.length == 0)
    {
        date = nil;
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:strFormat];
        date = [dateFormatter dateFromString:strDateTime];
    }
    return date;
}

+(NSString*)getDateTimeStrFromDate:(NSDate*)date format:(NSString*)strFormat
{
    NSString *strDate = @"";
    if (date == nil)
    {
        strDate = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:strFormat];
        strDate = [dateFormatter stringFromDate:date];
    }
    return strDate;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *)minAndSec:(int)seconds
{
	int minutesPart = seconds / 60; 
	int secondsPart = seconds % 60;
	
	NSString *minutesString = (minutesPart < 10) ? [NSString stringWithFormat:@"0%d", minutesPart] : [NSString stringWithFormat:@"%d", minutesPart];
	NSString *secondsString = (secondsPart < 10) ? [NSString stringWithFormat:@"0%d", secondsPart] : [NSString stringWithFormat:@"%d", secondsPart];
    
	return [NSString stringWithFormat:@"%@:%@", minutesString, secondsString];
}

+ (UITableView*)getTableViewByCell:(UITableViewCell*)tableViewCell
{
    UITableView *tableView = (UITableView *)tableViewCell.superview;
    if (![tableView isKindOfClass:[UITableView class]]) 
    {
       tableView = (UITableView *)tableView.superview; 
    }
    return tableView;
}

+(void)initGlobalValue
{
    if([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)
    {
        //iOS9 (equal or higher than iOS8)
        iOSPlatform	= 9;
        kScreenWidth	= [[UIScreen mainScreen] bounds].size.width;
        kScreenHeight = [[UIScreen mainScreen] bounds].size.height;
        kStatusBarHeight = 20.0f;
        NAV_BAR_HEIGHT = 64.0;
        NAV_BG_IMAGE = @"nav";
    }
    else if([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
    {
        //iOS8
        iOSPlatform	= 8;
        kScreenWidth	= [[UIScreen mainScreen] bounds].size.width;
        kScreenHeight = [[UIScreen mainScreen] bounds].size.height;
        kStatusBarHeight = 20.0f;
        NAV_BAR_HEIGHT = 64.0;
        NAV_BG_IMAGE = @"nav";
    }
    else if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //iOS7
        iOSPlatform	= 7;
        kScreenWidth	= [[UIScreen mainScreen] bounds].size.width;
        kScreenHeight = [[UIScreen mainScreen] bounds].size.height;
        kStatusBarHeight = 20.0f;
        NAV_BAR_HEIGHT = 64.0;
        NAV_BG_IMAGE = @"nav";
    }
    else
    {
        //lower than ios7
        iOSPlatform	= 6;
        kScreenWidth	= [[UIScreen mainScreen] applicationFrame].size.width;
        kScreenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
        kStatusBarHeight = 0.0f;
        NAV_BAR_HEIGHT = 44.0;
        NAV_BG_IMAGE = @"nav_ios6";
    }
}

+(NSString*)checkStrValue:(NSString*)strValue
{
    if (strValue == nil || (id) strValue == [NSNull null])
    {
        strValue = @"";
    }
    return strValue;
}

+ (NSString *)getFileNameFromPath:(NSString *)path
{
    NSString *fileName = nil;
    NSArray *array = [path componentsSeparatedByString:@"/"];
    NSUInteger nCount = [array count];
    if (nCount > 0)
    {
        fileName = [array objectAtIndex:nCount-1];
    }
    
    return fileName;
}

+ (NSString *)getAppVersion
{
	NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
	NSString *version = [dic objectForKey:@"CFBundleVersion"];
	return version;
}

+(NSString*)createImageNameByDateTimeAndPara:(NSInteger)nPara
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDateTime = [dateFormatter stringFromDate:[NSDate date]];
    strDateTime = [NSString stringWithFormat:@"%@-%li.jpg",strDateTime,(long)nPara];
    return strDateTime;
}

+(NSString*)getDevicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])
    {
        platform = @"iPhone";
    }
    else if ([platform isEqualToString:@"iPhone1,2"])
    {
        platform = @"iPhone 3G";
    }
    else if ([platform isEqualToString:@"iPhone2,1"])
    {
        platform = @"iPhone 3GS";
    }
    else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"])
    {
        platform = @"iPhone 4";
    }
    else if ([platform isEqualToString:@"iPhone4,1"])
    {
        platform = @"iPhone 4S";
    }
    else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"])
    {
        platform = @"iPhone 5";
    }
    else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"])
    {
        platform = @"iPhone 5C";
    }
    else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"])
    {
        platform = @"iPhone 5S";
    }
    else if ([platform isEqualToString:@"iPhone7,1"])
    {
        platform = @"iPhone 6";
    }
    else if ([platform isEqualToString:@"iPhone7,2"])
    {
        platform = @"iPhone 6 Plus";
    }
    else if ([platform isEqualToString:@"iPod4,1"])
    {
        platform = @"iPod touch 4";
    }
    else if ([platform isEqualToString:@"iPod5,1"])
    {
        platform = @"iPod touch 5";
    }
    else if ([platform isEqualToString:@"iPod3,1"])
    {
        platform = @"iPod touch 3";
    }
    else if ([platform isEqualToString:@"iPod2,1"])
    {
        platform = @"iPod touch 2";
    }
    else if ([platform isEqualToString:@"iPod1,1"])
    {
        platform = @"iPod touch";
    }
    else if ([platform isEqualToString:@"iPad1,1"])
    {
        platform = @"iPad";
    }
    else if ([platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"])
    {
        platform = @"iPad 2";
    }
    else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"])
    {
        platform = @"iPad Mini 1";
    }
    else if ([platform isEqualToString:@"iPad3,1"]||[platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,3"])
    {
        platform = @"iPad 3";
    }
    else if ([platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"])
    {
        platform = @"iPad 4";
    }
    else if ([platform isEqualToString:@"iPad4,1"]||[platform isEqualToString:@"iPad4,2"]||[platform isEqualToString:@"iPad4,3"])
    {
        platform = @"iPad air";
    }
    else if ([platform isEqualToString:@"iPad4,4"]||[platform isEqualToString:@"iPad4,5"]||[platform isEqualToString:@"iPad4,6"])
    {
        platform = @"iPad mini 2";
    }
    else if ([platform isEqualToString:@"iPad4,7"]||[platform isEqualToString:@"iPad4,8"]||[platform isEqualToString:@"iPad4,9"])
    {
        platform = @"iPad mini 3";
    }
    else if ([platform isEqualToString:@"iPad5,3"]||[platform isEqualToString:@"iPad5,4"])
    {
        platform = @"iPad air 2";
    }
    else if ([platform isEqualToString:@"x86_64"] || [platform isEqualToString:@"i386"])
    {
        platform = @"iOS Simulator";
    }
    else
    {
        platform = [NSString stringWithFormat:@"最新iOS设备,型号：%@",platform];
    }
    
    NSString *strPlatform = [NSString stringWithFormat:@"%@,%@:%@",platform,[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    return strPlatform;
}

+(BOOL)isImageValid:(UIImage*)image
{
    BOOL bResult = YES;
    if (image == nil)
    {
        bResult = NO;
    }
    else
    {
        CGImageRef cgref = [image CGImage];
        CIImage *cim = [image CIImage];
        if (cim == nil && cgref == NULL)
        {
            bResult = NO;
        }
    }
    return bResult;
}

//获取本地化字符串（由于使用频繁，不在此方法中设置过多的判断和设置）
+ (NSString *)localStr:(NSString *)strKey value:(NSString*)strValue
{
    return strValue;
}

+ (NSString*)getFileSizeFormatString:(unsigned long long)lFileSize
{
    NSString *strFileSize = @"";
    if (lFileSize>(1024*1024))
    {
        //Mb
        strFileSize = [NSString stringWithFormat:@"%.2f MB",(double)lFileSize/(1024*1024)];
    }
    else if (lFileSize>(1024))
    {
        //Kb
        strFileSize = [NSString stringWithFormat:@"%.2f KB",(double)lFileSize/1024];
    }
    else
    {
        //B
        strFileSize = [NSString stringWithFormat:@"%llu B",lFileSize];
    }
    return strFileSize;
}

+(BOOL)checkDoSupportByWebView:(NSString*)strFileName
{
    BOOL bSupport = NO;
    NSString *strFileExtension = [strFileName pathExtension].lowercaseString;
    NSString *strExistType = @"doc,docx,mov,mp3,mp4,pdf,ppt,pptx,xls,xlsx,txt";
    NSRange range = [strExistType rangeOfString:strFileExtension];
    if (range.length>0)
    {
        //exist file type
        bSupport = YES;
    }
    return bSupport;
}

//获取字符串的大小size
+ (CGSize)getStringSize:(NSString*)strContent andFont:(UIFont*)font andBound:(CGSize)size
{
    CGSize sizeResult = CGSizeZero;
    if ((id) strContent != [NSNull null] && strContent != nil)
    {
        if (iOSPlatform>=7)
        {
            if (strContent != nil && strContent.length > 0)
            {
                NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:strContent];
                [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, strContent.length)];
                
                //设置换行方式 NSLineBreakByCharWrapping(为了与控件换行方式一致，计算的行高也一致)
                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.lineBreakMode=NSLineBreakByCharWrapping;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,strContent.length)];
                
                sizeResult = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
            }
        }
        else
        {
            //sizeResult = [strContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
            sizeResult = CGSizeZero;
        }
    }
    return  sizeResult;
}

//获取字符串的大小size
+ (CGSize)getStringSize:(NSString*)strContent font:(UIFont*)font bound:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize sizeResult = CGSizeZero;
    if ((id) strContent != [NSNull null] && strContent != nil)
    {
        if (iOSPlatform>=7)
        {
            if (strContent != nil && strContent.length > 0)
            {
                NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:strContent];
                [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, strContent.length)];
                
                //设置换行方式
                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.lineBreakMode=lineBreakMode;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,strContent.length)];
                
                sizeResult = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
            }
        }
        else
        {
            //sizeResult = [strContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
            sizeResult = CGSizeZero;
        }
    }
    return  sizeResult;
}

+(void)bubbleTip:(NSString*)strText andView:(UIView*)viewParent
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:viewParent];
    HUD.detailsLabelFont = [UIFont systemFontOfSize:15];
    [viewParent addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabelText = strText;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.0];
}

+(void)showProgressView:(NSString*)strText view:(UIView*)view modal:(BOOL)bModal
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if(bModal)
    {
        HUD.userInteractionEnabled = NO;
    }
    HUD.labelText = strText;
    HUD.yOffset = -30;
}

+(void)hideProgressView:(UIView*)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+(NSString*)createFileNameByDateTime:(NSString*)strExtension
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDateTime = [dateFormatter stringFromDate:[NSDate date]];
    strDateTime = [NSString stringWithFormat:@"%@.%@",strDateTime,strExtension];
    return strDateTime;
}

+ (BOOL)validateMobile:(NSString *)strMobilePhone
{
    //手机号以13，15，17，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:strMobilePhone];
}

+ (BOOL)validateEmail:(NSString *)strEmail
{
    //手机号以13，15，17，18开头，八个 \d 数字字符
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//网址检测
+(BOOL)validateURL:(NSString *)strURL
{
    BOOL flag;
    if (strURL.length <= 0)
    {
        flag = NO;
        return flag;
    }
    //NSString *regex2 = @"^https?://(([a-zA-z0-9]|-){1,}\\.){1,}[a-zA-z0-9]{1,}-*$";
    //NSString *regex2 = @"^https?://(\\w)*$";//http://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?
    NSString *regex2 = @"^(h|H)(t|T)(t|T)(p|P)(s|S)?://.*$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:strURL];
}

//设置button 的image和title的上下排列(建议tabH:50,imageH:20,title:30)
+(void)setButtonImageTitlePosition:(UIButton*)button spacing:(CGFloat)fSpace
{
    // the space between the image and text
    CGFloat spacing = fSpace;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize;
    if (iOSPlatform>=7)
    {
        titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    }
    else
    {
        //titleSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping];
        titleSize = CGSizeZero;
    }
    
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

//设置button 的image和title的左右排列居中(image:left,title:right)
+(void)setButtonImageLeftTitleRight:(UIButton*)button spacing:(CGFloat)fSpace
{
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0.0, 0.0, -fSpace);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -fSpace,0,0.0);
}

//设置button 的title和image的左右排列居中(title:left,image:right)
+(void)setButtonImageRightTitleLeft:(UIButton*)button spacing:(CGFloat)fSpace
{
    // the space between the image and text
    CGFloat spacing = fSpace;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    
    //UIButton控件的默认布局：imageView在左，label在右，中间没有空隙
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+spacing, 0, -titleSize.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width+spacing);
}

//设置button的title距离左边的偏移量
+(void)setButtonTitleHPosition:(UIButton*)button width:(CGFloat)fWidth leftOffset:(CGFloat)fOffset
{
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, (fWidth/2-fOffset-titleSize.width*0.5)*(-2), 0, 0);
}

//定义ALAssetsLibrary的单例，防止拍照生成的ALAsset出现null
+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

//转换为黑白灰度图
+(UIImage*)grayImage:(UIImage*)source
{
    int width = source.size.width;
    int height = source.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8,0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    CGColorSpaceRelease(colorSpace);
    
    if(context==NULL)
    {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0,0,width,height),source.CGImage);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    
    return grayImage;
}

//从JSON的NSString中获得object对象（NSArray、NSDictionary）
+ (id)getObjectFromJSONString:(NSString *)str
{
    NSData *data= [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //如果其中一个字符错误，都会导致整个JSON解析失败
    id jsonObject = nil;
    if (data != nil)
    {
        NSError *error = nil;
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!jsonObject)
        {
            DLog(@"-JSONValue failed. Error trace is: %@,JSON string:%@", error,str);
            
            NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
            string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            string = [string stringByReplacingOccurrencesOfString:@"" withString:@"_"];
            data = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }
    }
    
    return jsonObject;
}

//从JSON的NSData中获得object对象（NSArray、NSDictionary）
+ (id)getObjectFromJSONData:(NSData *)data
{
    //如果其中一个字符错误，都会导致整个JSON解析失败
    id jsonObject = nil;
    if (data != nil)
    {
        NSError *error = nil;
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!jsonObject)
        {
            //当解析失败去掉可能的非法字符
            NSString *strJSON = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            DLog(@"-JSONValue failed. Error trace is: %@,\n JSON:%@", error,strJSON);
            
            NSString *string = [strJSON stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
            string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            string = [string stringByReplacingOccurrencesOfString:@"" withString:@"_"];
            data = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }
    }
    
    return jsonObject;
}

//如果改字体不存在，则返回默认字体
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if (!font)
    {
        NSRange range = [fontName rangeOfString:@"medium" options:NSCaseInsensitiveSearch];
        if(range.length)
        {
            font = [UIFont boldSystemFontOfSize:fontSize];
        }
        else
        {
            font = [UIFont systemFontOfSize:fontSize];
        }
    }
    return font;
}

@end
