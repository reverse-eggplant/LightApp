//
//  AppDelegate.h
//  LightApp
//
//  Created by malong on 14/10/31.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Store;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)shareDelegate; //类方法返回代理

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly ,strong)Store * store;  //仓库


/**
 * @brief 在状态栏显示 一些Log
 *
 * @param string 需要显示的内容
 * @param duration  需要显示多长时间
 */
+ (void) showStatusWithText:(NSString *) string duration:(NSTimeInterval) duration;


@end

