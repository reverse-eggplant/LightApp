//
//  BaseTableViewController.h
//  LightApp
//
//  Created by malong on 14/11/5.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController


- (void)PopToLastViewController;    //返回上级控制器

- (void)PopToRootViewController;    //返回根控制器


@end
