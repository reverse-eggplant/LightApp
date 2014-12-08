//
//  DetailViewController.h
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

typedef enum {
    kDETAILRightClose,  //右侧关闭样式，说明当前视图控制器模态而来
    kDETAILLeftClose,   //左侧关闭样式，说明当前视图控制器模态而来
    kDETAILLeftBack     //左侧返回样式，说明当前视图控制器push而来
}DetailType;       //内容样式，即指当前网页底部工具栏的样式

#import "BaseViewController.h"
@class CenterTopics;
@class CommentInfo;

@interface LODetailViewController : BaseViewController

/**
*param detailType 新闻详情页样式
*/
@property (nonatomic)DetailType detailType;


/**
*param webViewUrl 网页链接，当webViewUrl不为空时，不取其他属性信息来加载webview，而是直接让webview加载该链接
*/
@property (nonatomic,copy)NSString * webViewUrl;


/**
 param newsInfo 新闻信息，当newsInfo不为空时，不根据其它属性信息加载webview的内容，而是根据newInfo中
 的信息来加载。如果newsInfo的body_html属性为空，则调用获取新闻详情的接口获取新闻的详情
*/
@property (nonatomic,strong) CenterTopics * newsInfo;


/**
 *param commentInfo 评论信息，当前界面由点击评论cell进入，其中新闻id可用来请求新闻详情接口来而加载网页
*/
@property (nonatomic,strong) CommentInfo * commentInfo;



/**
 *param newsId 新闻id，当newsInfo中的body_html属性为空，时根据newsId获取新闻详情
 */
@property (nonatomic,strong) NSString * newsId;

@end



/**
*webview上部的灰色阴影图
*/
@interface CoverTopView : UIView

- (id)initWithFrame:(CGRect)frame
           imageUrl:(NSString *)imageUrl
            excerpt:(NSString *)excerpt;

@end