//
//  CenterTableHeadView.h
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterTableHeadView : UIView<UIScrollViewDelegate>
{
   __weak UIScrollView * _topScrollView;
    __weak UIView * _horizontalScrollIndicator;

    int currentPage;

    NSTimer * timer;
}

/*
 * param pushVC CenterTableHeadView所在的控制器，在点击图片按钮时，用该控制器跳转到新闻详情界面
 */
@property (nonatomic,weak) UIViewController * pushVC;


/**
 *顶部轮播图信息
 */
@property (nonatomic,strong)NSArray * topBanerNews;


- (id)initWithFrame:(CGRect)frame;

/*
 *brief 开始轮播动画
 */
- (void)startAnimating;


/*
 *brief 停止轮播动画
 */
- (void)stopAnimating;

@end
