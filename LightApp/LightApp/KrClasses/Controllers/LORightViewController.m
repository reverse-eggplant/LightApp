//
//  RightViewController.m
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LORightViewController.h"
#import "LODetailViewController.h"
#import "LOLogViewController.h"

#import "RightTableViewCell.h"
#import "CommentTableViewCell.h"

#import "CenterTopics.h"
#import "CommentInfo.h"

@interface LORightViewController ()<UITableViewDelegate>
{
    NSMutableArray * collentNews; //我的收藏信息数组
    NSMutableArray * hotNews;     //我的收藏信息数组
    NSMutableArray * comments; //我的评论，既我评论过的新闻
    UIButton * clickedButton;  //点击过的按钮
    TableViewArrayDataSource * commentDataSource; //评论数组
    
    NSDictionary * sideBarDic; //广告位信息字典
}
@end

static NSString * RightTableViewCellID = @"RightTableViewCellID";

static NSString * RightCommentTableViewCellID = @"RightCommentTableViewCellID";


@implementation LORightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    //获取顶部广告位对应的广告信息，并使用
    [AFNHttpRequestOPManager getInfoWithSubUrl:IOS_EVENT_SIDEBAR
                                    parameters:@{@"token":@"e1cbdfe589bff295bb29:12375"}
                                         block:^(id  result , NSError *error)
     {
         if ($safe(result) && [[result valueForKey:@"sites"]isKindOfClass:[NSArray class]]) {
             sideBarDic = [NSDictionary dictionaryWithDictionary:[[result valueForKey:@"sites"] objectAtIndex:0]];
         }
     }];
    

    // Do any additional setup after loading the view.
}

/**
 当视图出现时，显示导航栏，轮播图开始播放，关闭视图控制器的拖拽返回手势，并打开mm_drawerController的拖拽手势
 */
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SXViewConrollerManager closePan];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
}

/**
 当视图将要消失时，隐藏导航栏，轮播图停止播放，打开视图控制器的拖拽返回手势，并关闭mm_drawerController的拖拽手势
 */
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [SXViewConrollerManager openPan];
    
    DLog(@"Center will disappear");
}

- (void)setupRefresh{return;}; //弃用MJRefresh


- (void)setupTableView
{
    //显示评论条数，既我的收藏和实时热门下的celldatasource
    hotNews = $marrnew;
    collentNews = $marrnew;
    TableViewCellConfigureBlock  tableViewCellConfigureBlock = ^(RightTableViewCell * rightTableViewCell,RightHotNew * newsInfo){
        [rightTableViewCell setNewsInfo:newsInfo];
    };
    
    self.tableViewArrayDataSource = [[TableViewArrayDataSource alloc]initWithItems:hotNews identifier:RightTableViewCellID configureCellBlock:tableViewCellConfigureBlock];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableViewArrayDataSource;
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTableViewCell" bundle:nil] forCellReuseIdentifier:RightTableViewCellID];
    
    //我的评论下的celldatasource
    comments = $marrnew;
    TableViewCellConfigureBlock  commentTableViewCellConfigureBlock = ^(CommentTableViewCell * commentTableViewCell,CommentInfo * commentInfo){
        [commentTableViewCell setCommentInfo:commentInfo];
    };
    
    commentDataSource = [[TableViewArrayDataSource alloc]initWithItems:comments identifier:RightCommentTableViewCellID configureCellBlock:commentTableViewCellConfigureBlock];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:RightCommentTableViewCellID];
    
    
    
    //设置tableheadView和各按钮，默认点中实时热门
    UIView * tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 207.0)];
    tableHeadView.backgroundColor = CLEARCOLOR;
    self.tableView.tableHeaderView = tableHeadView;
 
    UIImageView * bottomLine = [[UIImageView alloc]initWithImage:LOADPNGIMAGE(@"divider-top")];
    bottomLine.frame = CGRectMake(0.0, 167, ScreenWidth-80.0, 4.0);
    [tableHeadView addSubview:bottomLine];
    
    //活动广告位
     UIButton * sideBarButton = [SharedSingleton getAButtonWithFrame:CGRectMake(0.0, 168.0,  ScreenWidth-70.0, 40) nomalTitle:nil hlTitle:nil titleColor:[UIColor lightGrayColor] bgColor:nil nbgImage:@"rightside" hbgImage:@"rightside" action:@selector(sedeBarButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    [tableHeadView addSubview:sideBarButton];
    
    //logo按钮，点击可弹出登录界面
    UIButton * logoButton = [SharedSingleton getAButtonWithFrame:CGRectMake(15.0, 35.0, 50.0, 50.0)
                                                      nomalTitle:nil
                                                         hlTitle:nil
                                                      titleColor:nil
                                                         bgColor:UIColorFromRGB(0Xd5d5d5)
                                                        nbgImage:@"logo-small"
                                                        hbgImage:@"logo-small"
                                                          action:@selector(logoButtonAction)
                                                          target:self
                                                      buttonTpye:UIButtonTypeCustom];
    logoButton.layer.cornerRadius = 5.0;
    [tableHeadView addSubview:logoButton];
    
    [SharedSingleton addAlabelForAView:self.view withText:@"未登录"
                                 frame:CGRectMake(70.0, 35.0, 40.0, 13.0)
                                  font:DEFAULT_BOLDFONT(13.0)
                             textColor:UIColorFromRGB(0X000000)];
    
    
    //分割线
    UIImageView * line = [[UIImageView alloc]initWithImage:LOADPNGIMAGE(@"dot-line@2x")];
    line.frame = CGRectMake(0.0, 98.0, ScreenWidth, 1.0);
    [tableHeadView addSubview:line];
    
    
    //3个按钮
    for (int i = 0; i<3; i++) {
        
        UIButton * button = [SharedSingleton getAButtonWithFrame:CGRectMake(15+i*70, 108.0, 68, 50.0) nomalTitle:(i==0)?@"我的收藏":((i == 1)?@"我的评论":@"实时热门") hlTitle:(i==0)?@"我的收藏":((i == 1)?@"我的评论":@"实时热门") titleColor:UIColorFromRGB(0X727b83) bgColor:nil nbgImage:nil hbgImage:nil action:@selector(topButtonsAction:) target:self buttonTpye:UIButtonTypeCustom];
        button.tag = 100+i;
        button.titleLabel.font = DEFAULT_FONT_S(13.0);
        [button setBackgroundImage:[LOADPNGIMAGE(@"swipe-layout-btn") resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5, 5.0, 5.)] forState:UIControlStateNormal];
        [button setBackgroundImage:[LOADPNGIMAGE(@"swipe-layout-btn-pressed") resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5, 5.0, 5.)] forState:UIControlStateHighlighted];
        [tableHeadView addSubview:button];
        
        if (i == 2) {
            [self topButtonsAction:button];
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 按钮方法
- (void)logoButtonAction
{
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[LOLogViewController alloc]init]] animated:YES completion:nil];
}
/**
 点击当前按钮，直接返回
 切换按钮，按钮图片转换，并从新请求数据
 根据数据返回的结构不同，生成不同的model，并切换tableveiw的cell，刷新界面
 */
- (void)topButtonsAction:(UIButton *)sender
{
    
    if ($eql(clickedButton,sender))return;
    
    //更改按钮选中状态
    [clickedButton setBackgroundImage:[LOADPNGIMAGE(@"swipe-layout-btn") resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5, 5.0, 5.)] forState:UIControlStateNormal];
    [clickedButton setBackgroundImage:[LOADPNGIMAGE(@"swipe-layout-btn-pressed") resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5, 5.0, 5.)] forState:UIControlStateHighlighted];

    [sender setBackgroundImage:[LOADPNGIMAGE(@"swipe-layout-btn-pressed") resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5, 5.0, 5.)] forState:UIControlStateNormal];
    [sender setBackgroundImage:[LOADPNGIMAGE(@"swipe-layout-btn-pressed") resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5, 5.0, 5.)] forState:UIControlStateHighlighted];
    
    clickedButton = sender;
    switch (sender.tag-100) {
        case 0:
            if (collentNews.count) {
                self.tableView.dataSource = self.tableViewArrayDataSource;
                self.tableViewArrayDataSource.items = collentNews;
                [self.tableView reloadData];
                return;
            }
            break;
        case 1:
            if (comments.count) {
                self.tableView.dataSource = commentDataSource;
                [self.tableView reloadData];
                return;
            }
            break;
        case 2:
            if (hotNews.count) {
                self.tableView.dataSource = self.tableViewArrayDataSource;
                self.tableViewArrayDataSource.items = hotNews;
                [self.tableView reloadData];
                return;
            }
            break;
            
        default:
            break;
    }

    
    __weak typeof(self)weakSelf = self;

    //根据点击的按钮不同，调用不同的接口
    [AFNHttpRequestOPManager getInfoWithSubUrl:((sender.tag-100) == 2)?TOP_HITS:((sender.tag-100)?MYREPLIES:FAVORITE)
                                    parameters:nil
                                         block:^(id  result , NSError *error)
     {
         __strong typeof(weakSelf)strongSelf = weakSelf;

         //根据接口返回的数据结构不同，生成不同的model，并替换self.tableview的datasource
         if (sender.tag-100 == 1) {
             strongSelf.tableView.dataSource = commentDataSource;
             if ([$safe(result) count]) {
                 [comments removeAllObjects];
                 for (int i = 0; i<[result count]; i++) {
                     NSDictionary * comment = [result objectAtIndex:i];
                     CommentInfo * commentInfo = [[CommentInfo alloc] initWithAttributes:comment];
                     [comments addObject:commentInfo];
                 }

             }
             
         }else{
             
             strongSelf.tableView.dataSource = strongSelf.tableViewArrayDataSource;
             if ([$safe(result) count]) {
                 for (int i = 0; i<[result count]; i++) {
                     NSDictionary * newInfo = [result objectAtIndex:i];
                     RightHotNew * rightHotNew = [[RightHotNew alloc] initWithAttributes:newInfo];
                     rightHotNew.numberLabelAlpha = 1.0-MIN(0.7, (i/10.0));
                     if (sender.tag-100 == 2) {
                         strongSelf.tableViewArrayDataSource.items = hotNews;
                         [hotNews addObject:rightHotNew];
                     }else{
                         strongSelf.tableViewArrayDataSource.items = collentNews;
                         [collentNews addObject:rightHotNew];
                     }
                 }
             }
         }
         
         MAINBLOCK(^{[strongSelf.tableView reloadData];});

     }];

}

//活动条按钮方法，点击进入活动详情界面
- (void)sedeBarButtonAction
{
    LODetailViewController * detailVC = [[LODetailViewController alloc]init];
    detailVC.detailType = kDETAILRightClose;
    detailVC.webViewUrl = [sideBarDic valueForKey:@"url"];
    [self presentViewController:detailVC animated:YES completion:nil];
}

#pragma mark UITableViewDelegate
/**
 点击新闻列表cell，将新闻信息传递给新闻详情控制器的newInfo
 点击我的评论cell，将评论信息传递给新闻详情控制器的commentinfo
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LODetailViewController * detailViewController = [[LODetailViewController alloc]init];
    if($eql(self.tableViewArrayDataSource,self.tableView.dataSource)){
        if (clickedButton.tag-100) {
            detailViewController.newsInfo = hotNews[indexPath.row];
        }else{
            detailViewController.newsInfo = collentNews[indexPath.row];

        }
    }else{
        detailViewController.commentInfo = comments[indexPath.row];
    }
    detailViewController.detailType = kDETAILLeftClose;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:detailViewController] animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return $eql(self.tableViewArrayDataSource,self.tableView.dataSource)?50:60;
}




@end
