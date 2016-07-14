//
//  Constants.h
//  TaoZhiHuiProj
//
//  Created by 焱 孙 on 15/9/7.
//  Copyright (c) 2015年 visionet. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((fmt),##__VA_ARGS__)
#else
#	define DLog(...)
#endif

#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//主题色
#define THEME_COLOR [UIColor colorWithRed:239/255.0 green:111/255.0 blue:88/255.0 alpha:1.0f]

//夜间模式主题色
#define NIGHT_COLOR [UIColor colorWithRed:27/255.0 green:32/255.0 blue:43/255.0 alpha:1.0f]

//角度到弧度之间的转换
#define degreesToRadians(x) (M_PI * (x) / 180.0)