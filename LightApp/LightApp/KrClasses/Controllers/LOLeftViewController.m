//
//  LeftViewController.m
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LOLeftViewController.h"
#import "LOCenterViewController.h"
#import "LOSearchResultViewController.h"
#import "LOSetViewController.h"
#import "CenterTopics.h"
#import "SearchResultModel.h"
#import "LeftTableViewCell.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "CustomAlertView.h"

@interface LOLeftViewController ()<UITextFieldDelegate>
{
    __weak UITextField * _searchTF;
    NSIndexPath * currentIndexPath;
    
   __weak UIButton * offLineButton;
    AFHTTPRequestOperation * offlineOperation;
    
}
@end

static NSString * const LeftTableViewCellIdentifier = @"LeftTableViewCellIdentifier";

@implementation LOLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

/**
 在刚进入界面时，设置tableview的cell为之前选中的cell
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView selectRowAtIndexPath:currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 设置视图

/**
 设置列表
 */
- (void)setupTableView{
    
    self.tableView.scrollEnabled = NO;
    
    [self setTableHeaderView];
    
    [self setTableFooterView];
    
    TableViewCellConfigureBlock  tableViewCellConfigureBlock = ^(LeftTableViewCell * cell,NSString * text){
        cell.textLabel.text = text;
        
    };
    
    self.tableViewArrayDataSource = [[TableViewArrayDataSource alloc]initWithItems:@[@"首页",@"氪星人的应用",@"国外创业公司",@"国内创业公司",@"国外咨询",@"国内资讯",@"生活方式",@"专栏文章"] identifier:LeftTableViewCellIdentifier configureCellBlock:tableViewCellConfigureBlock];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableViewArrayDataSource;
    currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:LeftTableViewCellIdentifier];
    
}

/**
 设置列表头视图
 */
- (void)setTableHeaderView
{
    //设置列表头视图
    UIView * tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 250.0, NavigationBarHeight+20.0)];
    tableHeadView.backgroundColor = CLEARCOLOR;
    self.tableView.tableHeaderView = tableHeadView;
    
    UIImageView * backIV = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"search"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)]];
    backIV.frame = CGRectMake(5.0, 27.0, ScreenWidth-80.0, 30.0);
    [tableHeadView addSubview:backIV];
    
    UIImageView * bottomLine = [[UIImageView alloc]initWithImage:LOADPNGIMAGE(@"divider-top")];
    bottomLine.frame = CGRectMake(0.0, 60.0, ScreenWidth-80.0, 4.0);
    [tableHeadView addSubview:bottomLine];
    [self searchTF];
}

/**
 设置列表尾视图
 */
- (void)setTableFooterView{
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth-80.0, 60.0)];
    tableFooterView.backgroundColor = CLEARCOLOR;
    self.tableView.tableFooterView = tableFooterView;
    
    offLineButton = [SharedSingleton getAButtonWithFrame:CGRectMake((ScreenWidth-295)/2.0, 25.0, 100.0, 30.0) nomalTitle:@"离线" hlTitle:nil titleColor:UIColorFromRGB(0X717b83) bgColor:nil nbgImage:@"icon-offline-1" hbgImage:nil action:@selector(offLineButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    offLineButton.titleLabel.font = CELL_BOLDFONT(12.0);
    offLineButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0);
    [offLineButton setBackgroundImage:[LOADPNGIMAGE(@"download-btn") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    [offLineButton setBackgroundImage:[LOADPNGIMAGE(@"download-btn-pressed") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)]forState:UIControlStateHighlighted];
    [tableFooterView addSubview:offLineButton];
    
    UIButton * setButton = [SharedSingleton getAButtonWithFrame:CGRectMake((ScreenWidth-295)/2.0+115.0, 25.0, 100.0, 30.0) nomalTitle:@"设置" hlTitle:nil titleColor:UIColorFromRGB(0X717b83) bgColor:nil nbgImage:@"icon-setting" hbgImage:nil action:@selector(seting) target:self buttonTpye:UIButtonTypeCustom];
    setButton.titleLabel.font = CELL_BOLDFONT(12.0);
    setButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0);
    [setButton setBackgroundImage:[LOADPNGIMAGE(@"download-btn") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    [setButton setBackgroundImage:[LOADPNGIMAGE(@"download-btn-pressed") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)]forState:UIControlStateHighlighted];
    [tableFooterView addSubview:setButton];
    
}

/**
 搜索框
 */
- (UITextField *)searchTF
{
    if (!_searchTF) {
        UITextField * searchTF = [SharedSingleton getATFWithFrame:CGRectMake(10.0, 27.0, ScreenWidth-90.0, 30.0) delegate:self palceHolder:@" 搜索文章" image:nil];
        searchTF.font = CELL_BOLDFONT(13.0);
        searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        searchTF.returnKeyType = UIReturnKeySearch;
        [self.tableView.tableHeaderView addSubview:_searchTF = searchTF];
    }
    return _searchTF;

}

#pragma mark 触发方法
/**
 离线按钮点击方法：发起离线请求，请求1000条首页新闻信息缓存到数据库
 未抓取到离线下载接口，用首页列表接口代替
 */
- (void)offLineButtonAction
{

    if ([USER_DEFAULT boolForKey:OFFLINEDONE]) {
        [CustomAlertView showWithTitle:@"离线完成！"];
        return;
    }
    offLineButton.enabled = NO;

    if(!offlineOperation){
        offlineOperation = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.36kr.com/api/v1/topics.json?token=e1cbdfe589bff295bb29:12375&per_page=1000"]]];
        
        __weak typeof(offLineButton)weakOffLienButton = offLineButton;
        
        [offlineOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float progress = totalBytesRead / (float)9137069;
            //        DLog(@"totalBytesRead = %llu = totalBytesRead",totalBytesRead);
            [weakOffLienButton setTitle:$str(@"离线%.0f%%",MIN(progress*100, 100)) forState:UIControlStateNormal];
            
            [weakOffLienButton setTitle:$str(@"离线%.0f%%",MIN(progress*100, 100)) forState:UIControlStateHighlighted];
            
        }];
        
        [offlineOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            weakOffLienButton.enabled = YES;
            [weakOffLienButton setTitle:@"离线" forState:UIControlStateNormal];
            [weakOffLienButton setTitle:@"离线" forState:UIControlStateHighlighted];
            
            id  result = [[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding] objectFromJSONString];
            
            if ([$safe(result) count]) {
                __block NSArray * results = result;
                BACKGROUNDBLOCK(^{
                    for (NSDictionary * topicNew in results) {
                        CenterTopics * centerListMoel = [[CenterTopics alloc] initWithAttributes:topicNew];
                        if (![DataBaseManager isModelExist:@"CenterTopics" keyName:@"resultId" keyValue:$str(@"%lu",(unsigned long)centerListMoel.resultId)]) {
                            [DataBaseManager insertDataWithMDBModel:centerListMoel];
                        }
                        [USER_DEFAULT setBool:YES forKey:OFFLINEDONE];
                        [USER_DEFAULT synchronize];
                    }
                    
                });
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakOffLienButton setTitle:@"离线" forState:UIControlStateNormal];
            
            [weakOffLienButton setTitle:@"离线" forState:UIControlStateHighlighted];
            weakOffLienButton.enabled = YES;
            DLog(@"error = %@",error);
        }];
 
    }
    [offlineOperation start];
}

/**
 设置按钮点击方法
 */
- (void)seting
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [SXViewConrollerManager openPan];
    
    [self.mm_drawerController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[LOSetViewController alloc] init]] animated:YES completion:nil];

}

/**
 搜索对应关键字的新闻
 当搜索结果不为空时，跳转到搜索结果展示界面，并清空当前输入框
 */
- (void)search
{
    if (_searchTF.text.length == 0)return;
    
    __weak typeof(self)weakSelf = self;
    __block UITextField * tf = _searchTF;
    [AFNHttpRequestOPManager getInfoWithSubUrl:SEARCH parameters:@{@"p":_searchTF.text,@"per_page":@"60"} block:^(id  result , NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if ([result isKindOfClass:[NSArray class]] && [result count])
        {
            
            LOSearchResultViewController *  searchResultViewController = [[LOSearchResultViewController alloc]init];
            searchResultViewController.searchTitle = tf.text;
            NSMutableArray * searchResults = [[NSMutableArray alloc]init];
            
            for (NSDictionary * dic in result) {
                [searchResults addObject:[[SearchResultModel alloc] initWithAttributes:dic]];
            }
            
            searchResultViewController.results = searchResults;
            
            UINavigationController * searchNavi = [[UINavigationController alloc]initWithRootViewController:searchResultViewController];
            
            [strongSelf presentViewController:searchNavi animated:YES completion:nil];
            tf.text = nil;
        }
        
    }];
    
}

#pragma mark UITableViewDelegate

/**
 当点击原cell时，直接停止编辑当前关闭侧栏
 点击不同的cell，传递不同的标题和样式给中心控制器
 中心控制器刷新
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if ($eql(indexPath,currentIndexPath)) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }
    
    currentIndexPath = indexPath;
    
    UINavigationController * navi = (UINavigationController *)self.mm_drawerController.centerViewController;
    
    LeftTableViewCell *  currentCell = (LeftTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    LOCenterViewController * vc = [navi.viewControllers objectAtIndex:0];
    vc.navigationItem.titleView = nil;
    
    if (indexPath.row) {
        vc.navigationItem.title = currentCell.textLabel.text;
        [vc hideTableHeadView];
        
    }else{
        UIImageView * logo = [[UIImageView alloc]initWithImage:LOADPNGIMAGE(@"nav-36kr")];
        [vc.navigationItem setTitleView:logo];
        [vc showTableHeadView];
    }
    switch (indexPath.row) {
        case 0:
            vc.newsType = kCenterHomePage;

            break;
        case 1:
            vc.newsType = kCenterKrStarApp;
            
            break;
        case 2:
            vc.newsType = kCenterAbroadVentureCompany;
            
            break;
        case 3:
            vc.newsType = kCenterInlandVentureCompany;
            
            break;
        case 4:
            vc.newsType = kCenterAbroadInformation;
            
            break;
        case 5:
            vc.newsType = kCenterInlandInformation;
            
            break;
        case 6:
            vc.newsType = kCenterLifeStyle;
            
            break;
        case 7:
            vc.newsType = kCenterSpecialColumn;
            
            break;
            
        default:
            break;
    }
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [vc.tableView headerBeginRefreshing];
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NavigationBarHeight;
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self search];
    return YES;
}

@end
