//
//  SearchResultViewController.h
//  LightApp
//
//  Created by malong on 14/11/28.
//  Copyright (c) 2014年 malong. All rights reserved.
//

/*
 *brief 搜索结果展示页视图控制器
 */
#import "BaseTableViewController.h"

@interface LOSearchResultViewController : BaseTableViewController

/**
 搜索关键字，做为当前界面的标题部分来展示
*/
@property (nonatomic,copy)NSString * searchTitle;


/**
 搜索结果，在最初创建时会带过来一个结果集用来展示
 */
@property (nonatomic,strong) NSMutableArray * results;  //搜索结果


@end
