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

@property (nonatomic, readonly ,strong)Store * store;

@end

