//
//  CenterTableHeadView.m
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "CenterTableHeadView.h"
#import "LODetailViewController.h"
#import "CenterTopics.h"

@implementation CenterTableHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)return nil;
    self.backgroundColor = UIColorFromRGB(0X919191);
    [self topScrollView];
    
    return self;
}


- (void)dealloc{
    [self stopAnimating];
    self.pushVC = nil;
}



- (void)setTopBanerNews:(NSArray *)topBanerNews{
    if (_topBanerNews == topBanerNews) {
        return;
    }
    _topBanerNews = topBanerNews;
    
    for (int i = 0;i<topBanerNews.count;i++) {
        
        CenterTopics * newInfo = [topBanerNews objectAtIndex:i];
        
        UIButton * imageButton = [SharedSingleton getAButtonWithFrame:CGRectMake(i*ScreenWidth, 0.0, ScreenWidth, self.frame.size.height-3.0) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nbgImage:nil hbgImage:nil action:@selector(goToDetailViewController:) target:self buttonTpye:UIButtonTypeCustom];
        imageButton.tag = 100+i;
        [_topScrollView addSubview:imageButton];
        [imageButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:newInfo.feature_img]];
        
        
        UILabel * title = [SharedSingleton addAlabelForAView:imageButton withText:newInfo.excerpt frame:CGRectMake(0.0,140.0 , ScreenWidth, 39.0) font:CELL_BOLDFONT(13.0) textColor:[UIColor whiteColor]];
        title.contentMode = UIViewContentModeCenter;
        title.numberOfLines = 1;
        title.backgroundColor = [UIColor colorWithPatternImage:LOADPNGIMAGE(@"cover-title-bg")];
        _topScrollView.contentSize = CGSizeMake(ScreenWidth*(i+1), self.frame.size.height-3.0);
    }
    [self horizontalScrollIndicator];

    [self setNeedsDisplay];
}

/*
 * 顶部的轮播滑动图
 */
- (UIScrollView *)topScrollView
{
    if (!_topScrollView) {
        UIScrollView * topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0.0,self.frame.size.width, self.frame.size.height-3.0)];
        topScrollView.bounces = NO;
        topScrollView.pagingEnabled = YES;
        topScrollView.delegate = self;
        topScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_topScrollView = topScrollView];
    }
    return _topScrollView;

}

/*
 * 顶部的蓝色标记条
 */
- (UIView *)horizontalScrollIndicator
{
    [_horizontalScrollIndicator removeFromSuperview];
    UIView * horizontalScrollIndicator = [[UIView alloc]initWithFrame:CGRectMake(0.0, self.frame.size.height-3.0, ScreenWidth/3, 3.0)];
    horizontalScrollIndicator.backgroundColor = UIColorFromRGB(0X1c94d9);
    [self addSubview:_horizontalScrollIndicator = horizontalScrollIndicator];
    
    return _horizontalScrollIndicator;
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_horizontalScrollIndicator) {
        _horizontalScrollIndicator.frame = CGRectMake(scrollView.contentOffset.x/3.0, self.frame.size.height-3.0, ScreenWidth/3.0, 3.0);
    }

}

#pragma mark 轮播动画
- (void)startAnimating{
    
    [self stopAnimating];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(cyleScroll) userInfo:nil repeats:YES];

    
}

- (void)stopAnimating
{
    if (timer && [timer isValid])
    {
        [timer invalidate];
    }
}

- (void)cyleScroll{
    currentPage++;

    [UIView animateWithDuration:0.5 animations:^{
        _topScrollView.contentOffset = CGPointMake((currentPage%3)*ScreenWidth, 0.0);

    }];
}

#pragma mark 点几跳转

- (void)goToDetailViewController:(UIButton *)sender
{
    LODetailViewController * detailViewController = [[LODetailViewController alloc]init];
    detailViewController.newsInfo = _topBanerNews[sender.tag-100];
    detailViewController.detailType = kDETAILLeftBack;
    [_pushVC.navigationController pushViewController:detailViewController animated:YES];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
