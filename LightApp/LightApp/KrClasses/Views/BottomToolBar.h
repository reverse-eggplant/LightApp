//
//  BottomToolBar.h
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "LODetailViewController.h"

@class CenterTopics;

@interface BottomToolBar : UIImageView<UIActionSheetDelegate>
{
    DetailType detailType;
    
    BOOL liked; //是否喜欢

    UIViewController * currentVC; //当前控制器
        
    UIButton * backArrowButton;   //webview的goback控制按钮
    UIButton * forwardArrowButton;//webview的goforward控制按钮
    UIButton * refreshButton;     //刷新和关闭刷新按钮

    UIActivityIndicatorView * activityIndicatorView; //请求加载菊花
    
}

/*
 *对应的新闻的评论数组，当它不为空时，会在点击评论按钮时直接传递到评论详情界面；为空，则取newsId传递
 */
@property (nonatomic,strong)NSMutableArray * replies;



/*
 *对应新闻信息id
 */
@property (nonatomic,strong)NSString * newsId;



/*
 *工具栏所在控制器上的webview，currentVC控制器内webview的界面变化状态，由当前工具栏管理
 */
@property (nonatomic,weak)UIWebView * webview;


/*
 *当webViewUrl不为空时，创建用来存储网页链接的数组，该数组按请求的顺序添加链接
 */
@property (nonatomic,strong)NSMutableArray * absoluteStrings;


/*
 *当webViewUrl不为空时，根据网页的状态设置按钮状态
 */
- (void)resetBackAndForwardArrowButtonAction;


/*
 *param:type 底部工具栏样式，根据不同的值创建出不同的样式
 *param:thecurrentVC 当前正在展示的控制器
 *param:theComments 当前新闻的评论数
 */
- (id)initWithDetailType:(DetailType)type
               currentVC:(UIViewController *)thecurrentVC
            commentCount:(NSUInteger)theCommentCount;

/*
 *brief 关闭风火轮
 */
- (void)startAnimating;


/*
 *brief 打开风火轮
 */
- (void)stopAnimating;


@end



/*
 *底部返回工具栏，只有一个返回按钮，点击pop回上一个控制器
 */
@interface BottomBackBar : UIImageView

{
    UIViewController * currentViewController; //工具栏所在的父视图的控制器
}

- (id)initWithFrame:(CGRect)frame
          currentVC:(UIViewController *)currentVC;

@end
