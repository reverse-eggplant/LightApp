//
//  BaseTableViewController.h
//  LightApp
//
//  Created by malong on 14/11/5.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewArrayDataSource.h"
#import "MJRefresh.h"

@interface BaseTableViewController : UITableViewController

@property (nonatomic)NSUInteger page;
@property (nonatomic,strong)TableViewArrayDataSource * tableViewArrayDataSource;

- (void)PopToLastViewController;    //返回上级控制器

- (void)PopToRootViewController;    //返回根控制器



@end
