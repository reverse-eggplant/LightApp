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


//友盟分享
#define UM_APPKEY @"547e7329fd98c5bfc10006ea"
#define WX_APPID  @"wx7bbdf1688d2b68e0"
#define WX_WECHATSECRET     @"eb3b51b11661aefd1ab5ea286bd085a0"

#pragma mark 屏幕宽高等
//屏幕宽高等。
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define StatusBarHeight 20.0
#define NavigationBarHeight     44.0

#pragma mark 颜色设置
// 颜色设置
#define CLEARCOLOR [UIColor clearColor]

//十六进制方式设置rgb
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAColor(r,g,b,a)        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//常用颜色
#define BLUE UIColorFromRGB(0X2b75ba)
#define DARK UIColorFromRGB(0X141F40)
#define GRAY UIColorFromRGB(0X808080)

//获取主屏window
#define MAINWINDOW [[[UIApplication sharedApplication] delegate]window]

#pragma mark 字体
//字体名
#define HLN @"HelveticaNeue"
#define HLN_Bold @"HelveticaNeue-Bold"
#define HLN_Light @"HelveticaNeue-Light"
#define HLN_Thin @"HelveticaNeue-Thin"
#define HLN_Regular @"HelveticaNeue-Regular"

//默认字体
#define DEFAULT_FONTSIZE    15
#define DEFAULT_FONT_S(s)     [UIFont systemFontOfSize:s]
#define DEFAULT_FONT_NS(n,s)     [UIFont fontWithName:n size:s]
#define DEFAULT_BOLDFONT(s) [UIFont fontWithName:@"Arial-BoldMT" size:s]
// For table cells
#define CELL_FONTSIZE    16
#define CELL_FONT(s)     [UIFont fontWithName:@"Helvetica" size:s]
#define CELL_BOLDFONT(s) [UIFont fontWithName:@"Helvetica-Bold" size:s]

//页码
#define PER_PAGE 15

//资源
#pragma mark 文件及其他资源路径

#define LOADIMAGE(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define LOADPNGIMAGE(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"png"]]

#define PNGIMAGE(name)     [UIImage imageNamed:name]
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

#define DEFAULTFILEMANAGER [NSFileManager defaultManager]       //文件管理器

#define CACHEFILEPATH(fileName) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]  //缓存路径

#define DOCUMENTFILEPATH(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]  //文件目录路径

#define ISFILEEXIST(filePath) [DEFAULTFILEMANAGER fileExistsAtPath:filePath]  //判断文件是否存在


#define USER_DEFAULT [NSUserDefaults standardUserDefaults]  //实例化
#define OFFLINEDONE @"offLineDone"   //是否离线


#pragma mark GCD
//GCD
#define BACKGROUNDBLOCK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAINBLOCK(block) dispatch_async(dispatch_get_main_queue(),block)

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]


#endif
