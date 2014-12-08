//
//  SetDetailViewController.h
//  LightApp
//
//  Created by malong on 14/12/3.
//  Copyright (c) 2014年 malong. All rights reserved.
//

/*
 *brief 设置界面的设置详情界面，目前只用来展示“关于36氪”和“关于36氪App”
 */


#import "BaseViewController.h"

@interface LOSetDetailViewController : BaseViewController

/**
 设置详情标题
 */
@property (nonatomic,copy)NSString * naviTitle;

/**
 设置详情网页链接
 */
@property (nonatomic,copy)NSString * webUrl; 

@end
