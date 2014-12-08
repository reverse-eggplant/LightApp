//
//  CenterViewController.h
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//



/*
 *brief 中心页面的新闻类型,根据类型不同，展示的信息不同.所赋值为新闻信息的node_id
 */
typedef enum
{
    kCenterHomePage = 0,              //首页
    kCenterKrStarApp = 100,             //氪星人的应用,node_id无效
    kCenterAbroadVentureCompany = 6,  //国外的创业公司
    kCenterInlandVentureCompany = 11,  //锅内的创业公司
    kCenterAbroadInformation = 1,     //国外资讯
    kCenterInlandInformation = 14,     //国内资讯
    kCenterLifeStyle = 5,             //生活方式
    kCenterSpecialColumn = 16          //相关文章

}CenterNewsType;

#import "BaseTableViewController.h"

@interface LOCenterViewController : BaseTableViewController

@property (nonatomic)CenterNewsType newsType;

/**
 *brief 当中心页为首页模式时，展示tableview的headerview
*/
- (void)showTableHeadView;


/**
 *brief 当中心页为非首页模式时，tableview的headerview设置为nil
 */
- (void)hideTableHeadView;


@end
