//
//  Animator.h
//  NavigationTransitionTest
//
//  Created by malong on 14/11/5.
//  Copyright (c) 2014年 malong. All rights reserved.
//

//源代码出处：https://github.com/objcio/issue5-view-controller-transitions


#import "Animator.h"

@implementation Animator

//设置过渡时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

//重写交互式动画效果
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.frame = CGRectMake(ScreenWidth/2, 0.0, ScreenWidth, ScreenHeight);
        fromViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        toViewController.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        //结束过场切换
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
    
}

@end
