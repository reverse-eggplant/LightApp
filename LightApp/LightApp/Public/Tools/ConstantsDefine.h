//
//  ConstantsDefine.h
//  LightApp
//
//  Created by malong on 14/11/5.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#ifndef LightApp_ConstantsDefine_h
#define LightApp_ConstantsDefine_h


#pragma mark 版本及其他信息
//版本及其他信息
#define IOS7    ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7.0)
#define IOS8    ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8.0)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#pragma mark 屏幕宽高等
//屏幕宽高等。
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define NavigationBarHeight     44.0

#pragma mark 颜色设置
// 颜色设置
#define CLEARCOLOR [UIColor clearColor]

//十六进制方式设置rgb
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark 文件及其他资源路径

#define DEFAULTFILEMANAGER [NSFileManager defaultManager]       //文件管理器

#define CACHEFILEPATH(fileName) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]  //缓存路径

#define DOCUMENTFILEPATH(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]  //文件目录路径

#define ISFILEEXIST(filePath) [DEFAULTFILEMANAGER fileExistsAtPath:filePath]  //判断文件是否存在


#define USER_DEFAULT [NSUserDefaults standardUserDefaults]  //实例化



#pragma mark GCD
//GCD
#define BACKGROUNDBLOCK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAINBLOCK(block) dispatch_async(dispatch_get_main_queue(),block)

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]


#endif
