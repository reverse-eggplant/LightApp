//
//  BaseViewController.h
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,strong) id pushInfo;    //推到下级界面时携带的数据

- (void)PopToLastViewController;    //返回上级控制器

- (void)PopToRootViewController;    //返回根控制器

@end
