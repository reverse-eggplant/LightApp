//
//  DetailViewController.m
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LODetailViewController.h"
#import "BottomToolBar.h"
#import "CenterTopics.h"
#import "SearchResultModel.h"
#import "KrStarAppInfo.h"
#import "ScreenImageView.h"
#import "CommentInfo.h"
#import "CustomAlertView.h"

@interface LODetailViewController ()<UIWebViewDelegate>
{
    UIWebView * detailWebView;     //详情展示webview
    __weak UIButton * _advertisingButton; //详情展示webview底部广告标签
    __weak BottomToolBar * _bottomToolBar; //界面底部工具栏，有三种样式
    __weak BottomBackBar * _bottomBackBar; //界面底部返回栏，进入界面，先添加一个底部返回栏

}
@end

@implementation LODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setupWebView];
    [self webRequest];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[AFNetworkReachabilityManager sharedManager] isReachable] && !_newsInfo) {
        [CustomAlertView showWithTitle:@"网络已断开！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_detailType == kDETAILLeftBack)
            {
                [SXViewConrollerManager popToLastViewController];
                
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 视图布局
/**
 设置webview
 */
- (void)setupWebView
{
    //上部状态栏底部添加一个蓝色视图
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, StatusBarHeight)];
    statusView.backgroundColor = UIColorFromRGB(0x0083d5);
    [self.view addSubview:statusView];
    
    [self bottomBackBar];
    
    //设置webview
    detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0, StatusBarHeight, ScreenWidth, ScreenHeight-NavigationBarHeight-StatusBarHeight)];
    UIImageView * krImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0-15.0, self.webViewUrl?(-50.0):(-210.0), 30.0, 16.0)];
    krImageView.image = LOADPNGIMAGE(@"logio-hide");
    [detailWebView.scrollView addSubview:krImageView];
    detailWebView.delegate = self;
    detailWebView.opaque = NO;
    detailWebView.scalesPageToFit = YES;
    detailWebView.scrollView.backgroundColor = [UIColor colorWithPatternImage:LOADPNGIMAGE(@"swipe-layout-bg")];
    self.view.backgroundColor = [UIColor colorWithPatternImage:LOADPNGIMAGE(@"swipe-layout-bg")];
    [self.view addSubview:detailWebView];
}

/**
 当有新闻图片、发布时间等信息时，在webview上部加一个展示图片的imageview
 */
- (void)setTopImageViewWithImageUrl:(NSString *)imageUrl
                            excerpt:(NSString *)excerpt
{
    detailWebView.scrollView.contentInset = UIEdgeInsetsMake(160, 0.0, 0.0, 0.0);
    CoverTopView * coverTopView = [[CoverTopView alloc]initWithFrame:CGRectMake(0.0, -160.0, ScreenWidth, 160.0)
                                                            imageUrl:imageUrl
                                                             excerpt:excerpt];
    [detailWebView.scrollView addSubview:coverTopView];
    
}

/**
 设置底部返回栏
 */
- (void)bottomBackBar{
    if (!_bottomBackBar) {
        BottomBackBar * bottomBackBar = [[BottomBackBar alloc]initWithFrame:CGRectMake(0.0, self.view.frame.size.height-45.0, ScreenWidth, 45.0) currentVC:self];
        [self.view addSubview:_bottomBackBar = bottomBackBar];
    }
}

/**
 设置底部工具栏
 */
- (void)bottomToolBarWithCommentCount:(NSUInteger)count
                              replies:(NSMutableArray *)replies
                               newsId:(NSString *)newsId
                           setWebView:(BOOL)yesOrNo{
    
    if (_webViewUrl) [_bottomBackBar removeFromSuperview];
    
    if (!_bottomToolBar) {
       BottomToolBar * bottomToolBar = [[BottomToolBar alloc]initWithDetailType:_detailType currentVC:self commentCount:count];
        if(newsId)  [bottomToolBar setNewsId:newsId];
       if (yesOrNo) bottomToolBar.webview = detailWebView;
        if (replies)[bottomToolBar setReplies:replies];
        [self.view addSubview:_bottomToolBar = bottomToolBar];
    }
}

/**
 *根据不同的属性值，在初始化本类对象成功后，发起不同的网络请求,生成不同样式的底部工具栏
 *如果_webViewUrl不为空，说明当前新闻详情展示的是36Kr平台外的网页，底部工具栏为kDETAILRightClose样式，且当前控制器是模态推出的
 *如果self.newsInfo不为空，说明当前界面是点击新闻列表的cell时推过来的。这时就要判断self.newsInfo是否含有body_html相关信息：有，则直接展示；没有，则需要调用新闻详情接口请求获取
 *如果self.commentInfo不为空，说明当前界面是点击新闻评论列表cell而来，需要提取self.commentInfo里面跟新闻id相关的topic_id，用来请求获取新闻详情
 *如果self.newsId不为空，则直接调用新闻详情接口获取新闻详情
 */
- (void)webRequest{
    
    if (_webViewUrl)
    {
        [detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewUrl]]];
        [self bottomToolBarWithCommentCount:0 replies:nil newsId:nil setWebView:YES];
        
    }else if(self.newsInfo)
    {
        [self setTopImageViewWithImageUrl:self.newsInfo.feature_img excerpt:self.newsInfo.excerpt];
        
        //判断是否传过来了body_html
        if ([[self.newsInfo propertyNames] containsObject:@"body_html"] && [self.newsInfo valueForKey:@"body_html"]) {
            
            [self bottomToolBarWithCommentCount:self.newsInfo.replies_count
                                        replies:nil
                                         newsId:$str(@"%lu",(unsigned long)self.newsInfo.resultId)
                                     setWebView:YES];
            
            [detailWebView loadHTMLString:[self usefulWithAuthor:self.newsInfo.user_name
                                                       creatTime:self.newsInfo.created_at
                                                          avatar:self.newsInfo.user_avatar_url
                                                        bodyHtml:[self.newsInfo valueForKey:@"body_html"]] baseURL:nil];
            
        }else{
            self.newsId = $str(@"%lu",(unsigned long)self.newsInfo.resultId);
            [self getNewDetail];
        }
        
    }else if(self.commentInfo){
        self.newsId =$str(@"%lu",(unsigned long)self.commentInfo.topic_id);
        [self getNewDetail];
        
    }else if (self.newsId){
        [self getNewDetail];
    }

}

#pragma mark html字符串替换
/**
 *brief 将topic.html文件生成的字符串中的对应字符替换成相应的字符
 *param userName 发布新闻的用户名称
 *param creatTime 新闻发布时间
 *param avatar 发布新闻的用户头像
 *param bodyHtml 新闻主提html字符串
 */
- (NSString *)usefulWithAuthor:(NSString *)userName
                     creatTime:(NSString *)timeString
                        avatar:(NSString *)avatarUrl
                      bodyHtml:(NSString *)bodyHtmlString
{
    NSString * htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topic" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    if (userName) htmlString = [htmlString stringByReplacingOccurrencesOfString:@"__AUTHOR__" withString:userName];
    if (timeString) htmlString = [htmlString stringByReplacingOccurrencesOfString:@"__TIME__" withString:timeString];
    if (avatarUrl) htmlString = [htmlString stringByReplacingOccurrencesOfString:@"__AVATAR__" withString:avatarUrl];
    if (bodyHtmlString) htmlString = [htmlString stringByReplacingOccurrencesOfString:@"__BODY__" withString:bodyHtmlString];

    
    return htmlString;
}

#pragma mark 网略请求

/**
 根据新闻id，获取新闻详情，并获取新闻对应的评论信息
 */
- (void)getNewDetail
{
    __weak typeof(self)weakSelf = self;
    
    [AFNHttpRequestOPManager getInfoWithSubUrl:[NEWINFO stringByReplacingOccurrencesOfString:@"infoid" withString:self.newsId] parameters:nil block:^(id  result , NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if (result) {
           NSDictionary * newInfoDic = [NSDictionary dictionaryWithDictionary:result];
            
          [detailWebView loadHTMLString:[self usefulWithAuthor:[[newInfoDic valueForKey:@"user"] valueForKey:@"name"]
                                                     creatTime:[TimeManager theInterValTimeFromCreateTime:[newInfoDic valueForKey:@"created_at"] formatString:nil]
                                                        avatar:[[newInfoDic valueForKey:@"user"]
                                                                valueForKey:@"avatar_url"]
                                                      bodyHtml:[newInfoDic
                                                                valueForKey:@"body_html"]] baseURL:nil];

            NSMutableArray * replies = $marrnew;
            if ([$safe([result valueForKey:@"replies"]) count]) {
                
                for (NSDictionary * repleyDic in [result valueForKey:@"replies"]) {
                    CommentInfo * repley = [[CommentInfo alloc] initWithAttributes:repleyDic];
                    [replies addObject:repley];
                }
                
                MAINBLOCK(^{
                    [strongSelf setTopImageViewWithImageUrl:[newInfoDic valueForKey:@"feature_img"]
                                              excerpt:[newInfoDic valueForKey:@"excerpt"]];
                    
                    [strongSelf bottomToolBarWithCommentCount:replies.count
                                                replies:replies
                                                 newsId:$safe([newInfoDic valueForKey:@"id"])
                                             setWebView:NO];

                });

            }else{
                
                MAINBLOCK(^{
                    [strongSelf setTopImageViewWithImageUrl:[newInfoDic valueForKey:@"feature_img"] excerpt:[newInfoDic valueForKey:@"excerpt"]];
                    [strongSelf bottomToolBarWithCommentCount:0
                                                      replies:nil
                                                       newsId:$safe([newInfoDic valueForKey:@"id"])
                                                   setWebView:NO];
                });

            }
            
        }
                                             
    }];
}

#pragma mark 底部广告按钮方法
/**
 用详情页展示底部广告详情
 */
- (void)showAdvertising
{
    LODetailViewController * detailVC = [[LODetailViewController alloc]init];
    detailVC.webViewUrl = [[USER_DEFAULT valueForKey:@"sites"] valueForKey:@"link"];
    detailVC.detailType = kDETAILRightClose;
    [self presentViewController:detailVC animated:YES completion:nil];
}


#pragma mark UIWebViewDelegate
/**
 当工具栏为kDETAILRightClose模式时，请求发起，启动工具栏的请求菊花
 当_webViewUrl不为空时，说明在加载一个36kr外部的链接，将链接加入_bottomToolBar.absoluteStrings，直接返回yes
 当_webViewUrl为空时，根据webview加载类型选择展示图片、push或者present到下一个详情界面
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (_detailType == kDETAILRightClose) [_bottomToolBar startAnimating];
    
    if (_webViewUrl){
        if ($safe(request.URL.absoluteString) &&![_bottomToolBar.absoluteStrings containsObject:request.URL.absoluteString]) {
            [_bottomToolBar.absoluteStrings addObject:request.URL.absoluteString];
        }
        [_bottomToolBar resetBackAndForwardArrowButtonAction];
        return YES;
    }

    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
        {
            NSString * absoluteString = request.URL.absoluteString;
            
            //判断点击图片后，将图片放大
            if ($eql([absoluteString substringToIndex:3],@"img")) {
                ScreenImageView * screenIV = [[ScreenImageView alloc]initWithImageUrl:[absoluteString substringFromIndex:3]];
                [screenIV show];
                break;
            }
            
            LODetailViewController * detailVC = [[LODetailViewController alloc]init];
            
            //如果所点击的链接为 @"http://www.36kr.com/p/213768.html" 这种样式，说明这是36kr客户端的一条新闻，应该push进入下一个新闻详情界面
            //并且赋值newId

            detailVC.detailType = [absoluteString rangeOfString:@".html"].length?kDETAILLeftBack:kDETAILRightClose;
        
            if ([absoluteString rangeOfString:@".html"].length) {
                detailVC.newsId = [[[absoluteString $split:@"/p/"] objectAtIndex:1] substringToIndex:6];
                [self.navigationController pushViewController:detailVC animated:YES];
 
            }else{
                detailVC.webViewUrl = request.URL.absoluteString;
                [self.navigationController presentViewController:detailVC animated:YES completion:nil];
            }
            return NO;

        }
            break;
            
        default:
            break;
    }
    return YES;
}
/**
 请求结束后，当工具栏为kDETAILRightClose模式时，停止工具栏的请求菊花
 如果当前_webViewUrl不为空，无需添加广告条
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_detailType == kDETAILRightClose)[_bottomToolBar stopAnimating];
    [_bottomToolBar resetBackAndForwardArrowButtonAction];
    if (_webViewUrl) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!$eql([[USER_DEFAULT valueForKey:@"sites"] valueForKey:@"link"],_webViewUrl)) {
            if (!_advertisingButton && [USER_DEFAULT valueForKey:@"sites"]) {
                _advertisingButton = [ViewFactory getAButtonWithFrame:CGRectMake(20.0, webView.scrollView.contentSize.height-90.0, ScreenWidth-40.0, 80) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:nil nImage:nil hImage:nil action:@selector(showAdvertising) target:self buttonTpye:UIButtonTypeCustom];
                DLog(@"sites = %@",[USER_DEFAULT valueForKey:@"sites"]);
                [_advertisingButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[[USER_DEFAULT valueForKey:@"sites"] valueForKey:@"favicon"]]];
                
            }else{
                [_advertisingButton removeFromSuperview];
            }
            _advertisingButton.frame = CGRectMake(20.0, webView.scrollView.contentSize.height-90.0, ScreenWidth-40.0, 80);
            [webView.scrollView addSubview:_advertisingButton];
            
        }
    });

}

/**
 请求失败后，当工具栏为kDETAILRightClose模式时，停止工具栏的请求菊花
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (_detailType == kDETAILRightClose) {
        [_bottomToolBar stopAnimating];
    }
}

@end


#pragma mark CoverTopView

@implementation CoverTopView

- (id)initWithFrame:(CGRect)frame
           imageUrl:(NSString *)imageUrl
            excerpt:(NSString *)excerpt{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    //图片加载图
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self addSubview:imageView];
    
    //蒙板图
    UIImageView * corverImageView = [[UIImageView alloc]initWithFrame:imageView.frame];
    corverImageView.image = LOADPNGIMAGE(@"cover-overlay-home");
    [self addSubview:corverImageView];
    CGFloat excerptHeight = [NSStringManager sizeOfCurrentString:excerpt font:16.0 contentSize:CGSizeMake(ScreenWidth-40.0, 120.0)].height;
    
    //介绍文案标签
    [[SharedSingleton addAlabelForAView:self
                              withText:excerpt
                                 frame:CGRectMake(20.0, frame.size.height-excerptHeight-5.0, ScreenWidth-40.0, excerptHeight)
                                  font:CELL_BOLDFONT(16.0)
                             textColor:[UIColor  whiteColor]] setTextAlignment:NSTextAlignmentLeft];
    
    return self;
}

@end