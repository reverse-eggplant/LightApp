//
//  BottomToolBar.m
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "BottomToolBar.h"
#import "LOLogViewController.h"
#import "LOCommentViewController.h"

#import "CenterTopics.h"


#import "UMSocialDataService.h"
#import "UMSocial.h"

@implementation BottomToolBar

- (id)initWithDetailType:(DetailType)type
               currentVC:(UIViewController *)thecurrentVC
            commentCount:(NSUInteger)theCommentCount
{

   self = [super initWithFrame:CGRectMake(0.0, ScreenHeight-45.0, ScreenWidth, 45.0)];
    if (!self) {
        return nil;
    }
    self.userInteractionEnabled = YES;
    detailType = type;
    currentVC = thecurrentVC;
    _absoluteStrings = $marrnew;
    
    self.image = [LOADPNGIMAGE(@"bottom-bg") resizableImageWithCapInsets:UIEdgeInsetsMake(10., 5, 10.0, 5.0)];
    
    //关闭／返回按钮
    UIButton * closeButton = [SharedSingleton getAButtonWithFrame:CGRectMake((type==kDETAILLeftClose)?12.0:((type==kDETAILRightClose)?(ScreenWidth-63.0):0.0), 10.0, 50, 27.0) nomalTitle:(type==kDETAILLeftBack)?nil:@"关闭" hlTitle:(type==kDETAILLeftBack)?nil:@"关闭" titleColor:UIColorFromRGB(0X4a5257) bgColor:nil nbgImage:(type==kDETAILLeftBack)?@"bottom-back":nil hbgImage:(type==kDETAILLeftBack)?@"bottom-back":nil action:@selector(closeButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    
    if(type!=kDETAILLeftBack){
        [closeButton setBackgroundImage:[LOADPNGIMAGE(@"bottom-close") resizableImageWithCapInsets:UIEdgeInsetsMake(10., 5, 10.0, 5.0)] forState:UIControlStateNormal];
        closeButton.titleLabel.font = CELL_BOLDFONT(14.0);
    }
    [self addSubview:closeButton];
    
    
    switch (type) {
        case kDETAILLeftClose:
        case kDETAILLeftBack:
        {

            UIButton * likeButton = [SharedSingleton getAButtonWithFrame:CGRectMake(ScreenWidth-157.0, 12.5, 25.0, 25.0) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nbgImage:@"bottom-like" hbgImage:@"bottom-like" action:@selector(likeButtonAction:) target:self buttonTpye:UIButtonTypeCustom];
            [self addSubview:likeButton];
            
            UIButton * commentButton = [SharedSingleton getAButtonWithFrame:CGRectMake(ScreenWidth-107.0, 12.5, 25.0, 25.0)
                                                                 nomalTitle:theCommentCount?$str(@"%d",theCommentCount):nil
                                                                    hlTitle:theCommentCount?$str(@"%d",theCommentCount):nil
                                                                 titleColor:[UIColor whiteColor]
                                                                    bgColor:nil
                                                                   nbgImage:nil
                                                                   hbgImage:nil
                                                                     action:@selector(commentButtonAction)
                                                                     target:self
                                                                 buttonTpye:UIButtonTypeCustom];
            commentButton.titleLabel.font = CELL_BOLDFONT(10);
            [commentButton setBackgroundImage:LOADPNGIMAGE(theCommentCount?@"bottom-comment-blank":@"bottom-comment")
                                                                                forState:UIControlStateNormal];
            [commentButton setBackgroundImage:LOADPNGIMAGE(theCommentCount?@"bottom-comment-blank":@"bottom-comment")
                                     forState:UIControlStateHighlighted];
            [self addSubview:commentButton];
            
            UIButton * shareButton = [SharedSingleton getAButtonWithFrame:CGRectMake(ScreenWidth-57.0, 12.5, 25.0, 25.0) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nbgImage:@"bottom-share" hbgImage:@"bottom-share" action:@selector(shareButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            [self addSubview:shareButton];
            
            
        }
            break;
        case kDETAILRightClose:
        {

            backArrowButton = [SharedSingleton getAButtonWithFrame:CGRectMake(16.0, 12.5, 25.0, 25.0) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nbgImage:@"bottom-left-arrow" hbgImage:@"bottom-left-arrow" action:@selector(backArrowButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            backArrowButton.enabled = NO;
            [self addSubview:backArrowButton];
            
            forwardArrowButton = [SharedSingleton getAButtonWithFrame:CGRectMake(50.0, 12.5, 25.0, 25.0) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nbgImage:@"bottom-right-arrow" hbgImage:@"bottom-right-arrow" action:@selector(forwardArrowButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            forwardArrowButton.enabled = NO;
            [self addSubview:forwardArrowButton];
            
            refreshButton = [SharedSingleton getAButtonWithFrame:CGRectMake(100.0, 12.5, 25.0, 25.0) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nbgImage:nil hbgImage:nil action:@selector(refreshButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            [self addSubview:refreshButton];
            
            activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0-15, 7.5, 30, 30.0)];
            [self addSubview:activityIndicatorView];
            activityIndicatorView.hidesWhenStopped = YES;
            activityIndicatorView.color = UIColorFromRGB(0X8b8b8b);
            [self startAnimating];
            
        }
            
            break;
            
            
        default:
            break;
    }
    
    return self;
}



#pragma mark kDETAILLeftBack和kDETAILLeftClose样式下的按钮方法
- (void)closeButtonAction{
    if (!currentVC)return;

    if (detailType == kDETAILLeftBack)
    {
        [SXViewConrollerManager popToLastViewController];
        
    }else{
        [currentVC dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)likeButtonAction:(UIButton *)sender
{
    if (!currentVC)return;
    [sender setImage:LOADPNGIMAGE(liked?@"bottom-like":@"bottom-liked") forState:UIControlStateNormal];
    [sender setImage:LOADPNGIMAGE(liked?@"bottom-like":@"bottom-liked") forState:UIControlStateHighlighted];
    liked = !liked;
    
}

//评论按钮方法
- (void)commentButtonAction
{
    if (!currentVC && !self.newsId && !_replies )return;
    
    LOCommentViewController * commentViewController = [[LOCommentViewController alloc]init];
    if (self.replies) {
        [commentViewController setCommentInfos:_replies];
    
    }else{
        commentViewController.infoId = self.newsId;

    }
    [currentVC.navigationController pushViewController:commentViewController animated:YES];
    
}

- (void)shareButtonAction
{
    UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:@"微信分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"朋友圈" otherButtonTitles:@"好友",@"邮箱",@"短信", nil];
    [action showInView:MAINWINDOW];
    
}

#pragma mark kDETAILRightClose样式下的方法

- (void)resetBackAndForwardArrowButtonAction{
    if (_webview) {
        backArrowButton.enabled = _webview.canGoBack;
        forwardArrowButton.enabled = _webview.canGoForward;
    }
}
- (void)backArrowButtonAction{
    if (_webview) {
        [self.webview goBack];

    }
}

- (void)forwardArrowButtonAction{
    if (_webview) {
        [self.webview goForward];
        
    }
}

- (void)refreshButtonAction
{
    if (self.webview.loading)
    {
        [self.webview stopLoading];
        [self stopAnimating];
    }else{
        [self startAnimating];
        [self.webview reload];
    }

}

- (void)startAnimating
{
    
    [refreshButton setImage:LOADPNGIMAGE(@"bottom-stop") forState:UIControlStateNormal];
    [refreshButton setImage:LOADPNGIMAGE(@"bottom-stop") forState:UIControlStateHighlighted];

    [activityIndicatorView startAnimating];
}


- (void)stopAnimating
{

    [refreshButton setImage:LOADPNGIMAGE(@"bottom-refresh") forState:UIControlStateNormal];
    [refreshButton setImage:LOADPNGIMAGE(@"bottom-refresh") forState:UIControlStateHighlighted];

    [activityIndicatorView stopAnimating];

}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 4) return;
    //生成新闻网页链接
    NSString * link = @"http://www.36kr.com/p/infoId.html";
    link = [link stringByReplacingOccurrencesOfString:@"infoId" withString:self.newsId];

    //根据不同的index调用不同的分享方式
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[buttonIndex?(buttonIndex == 1?UMShareToWechatTimeline:(buttonIndex == 2?UMShareToEmail:UMShareToSms)):UMShareToWechatTimeline]
                                                        content:link
                                                          image:nil
                                                       location:nil
                                                    urlResource:nil
                                            presentedController:currentVC
                                                     completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



@implementation BottomBackBar

- (id)initWithFrame:(CGRect)frame currentVC:(UIViewController *)currentVC{
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.userInteractionEnabled = YES;
    self.image = [LOADPNGIMAGE(@"bottom-bg") resizableImageWithCapInsets:UIEdgeInsetsMake(10., 5, 10.0, 5.0)];
    currentViewController = currentVC;
    
    UIButton * backButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0,10.0, 50.0, 27.0) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nImage:@"bottom-back" hImage:@"bottom-back" action:@selector(goBack) target:self buttonTpye:UIButtonTypeCustom];
    [self addSubview:backButton];
    return self;
}

- (void)goBack
{
    if (currentViewController) {
        [currentViewController.navigationController popViewControllerAnimated:YES];
    }
}
@end


