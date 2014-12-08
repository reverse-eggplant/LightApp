//
//  CenterViewController.m
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LOCenterViewController.h"
#import "LODetailViewController.h"

#import "MMDrawerBarButtonItem.h"
#import "CenterTableViewCell.h"
#import "CenterTableHeadView.h"
#import "CenterTopics.h"


#import "KrStarAppTableViewCell.h"
#import "KrStarAppInfo.h"

@interface LOCenterViewController ()<UITableViewDelegate>

{
    NSMutableArray * topNews;           //顶部轮播图信息数组
    CenterTableHeadView * _tableHeadView;
    TableViewArrayDataSource * krStarAppsDataSource;
    
    int tableNewsNumber;   // 数据库新闻条数
}

@property (nonatomic,strong)NSMutableArray * CenterListModels;  //新闻列表数组

@property (nonatomic,strong)NSMutableArray * starApps;          //氪星人的应用

@end

static NSString * const CenterTableViewCellIdentifier = @"CenterTableViewCellIdentifier";

static NSString * const KrStarAppCellIdentifier = @"KrStarAppCellIdentifier";


@implementation LOCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviAndTableView];
    if(![DataBaseManager isTableExist:@"KrStarAppInfo"])[DataBaseManager createDataBaseWithDBModel:[[KrStarAppInfo alloc]init]];
    
    if(![DataBaseManager isTableExist:@"CenterTopics"])[DataBaseManager createDataBaseWithDBModel:[[CenterTopics alloc]init]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self headerRereshing];

    });

}


/**
 当视图出现时，显示导航栏，轮播图开始播放，关闭视图控制器的拖拽返回手势，并打开mm_drawerController的拖拽手势
 */
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;

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
    [_tableHeadView stopAnimating];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [SXViewConrollerManager openPan];
    
    DLog(@"Center will disappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 视图布局

/**
 *brief 设置导航栏和列表
 */
- (void)setupNaviAndTableView{
    
    [self.navigationItem setLeftBarButtonItem:[ViewFactory
                                               getABarButtonItemWithImage:@"nav-left"
                                               imageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 20)
                                               target:self
                                               selection:@selector(leftDrawerButtonPress:)]];
    
    [self.navigationItem setRightBarButtonItem:[ViewFactory
                                                getABarButtonItemWithImage:@"nav-right"
                                                imageEdgeInsets:UIEdgeInsetsMake(0.0, 20, 0.0, -20)
                                                target:self
                                                selection:@selector(rightDrawerButtonPress:)]];
    
    UIImageView * logo = [[UIImageView alloc]initWithImage:LOADPNGIMAGE(@"nav-36kr")];
    [self.navigationItem setTitleView:logo];
    
    
    //中心页新闻列表cell注册
    TableViewCellConfigureBlock  tableViewCellConfigureBlock = ^(CenterTableViewCell * cell,CenterTopics * centerListModel){
        [cell setNewsInfo:centerListModel];
        
    };
    self.CenterListModels = $marrnew;
    self.tableViewArrayDataSource = [[TableViewArrayDataSource alloc]initWithItems:self.CenterListModels identifier:CenterTableViewCellIdentifier configureCellBlock:tableViewCellConfigureBlock];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableViewArrayDataSource;
    [self.tableView registerNib:[CenterTableViewCell nib] forCellReuseIdentifier:CenterTableViewCellIdentifier];
    
    
    //氪星人的应用cell注册
    TableViewCellConfigureBlock  krStarAppCellConfigureBlock = ^(KrStarAppTableViewCell * cell,KrStarAppInfo * appInfo){
        [cell setPushVC:self];
        [cell setAppInfo:appInfo];
    };
    self.starApps = $marrnew;
    krStarAppsDataSource = [[TableViewArrayDataSource alloc]initWithItems:self.starApps
                                                               identifier:KrStarAppCellIdentifier
                                                       configureCellBlock:krStarAppCellConfigureBlock];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KrStarAppTableViewCell" bundle:nil]
         forCellReuseIdentifier:KrStarAppCellIdentifier];

    
}


/**
 展示顶部table的头视图
 非首页状态，顶部头视图去掉
 首页状态：1、网络断开，从缓存读取新闻头条；2、网络连接，请求接口，并更新缓存
 */
- (void)showTableHeadView{
    if (_newsType != kCenterHomePage) {
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
        return;
    }
    
    self.tableView.tableHeaderView = [self tableHeadView];
    [self.tableView reloadData];

    if (!topNews) topNews = $marrnew;
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        __weak typeof(_tableHeadView)weakTableHeadView = _tableHeadView;
        [AFNHttpRequestOPManager getInfoWithSubUrl:TOPICS_FEATURE parameters:nil block:^(id  result , NSError *error) {
            
            if ([$safe(result) count]) {
                [topNews removeAllObjects];
                for (NSDictionary * topicNew in result) {
                    [topNews addObject:[[CenterTopics alloc] initWithAttributes:topicNew]];
                }
                [ArchiveDataBase archiveWithtSuffix:@"tableHeaderInfos" dataSourceDic:result fileName:@"CenterTopics"];
                MAINBLOCK(^{
                    [weakTableHeadView setTopBanerNews:topNews];
                    [weakTableHeadView startAnimating];
                });
            }
            
        }];
    }else{
        if ([ArchiveDataBase isHaveCachedWithSuffix:@"tableHeaderInfos" fileName:@"CenterTopics"]) {
            
            for (NSDictionary * topicNew in (NSArray *)[ArchiveDataBase unArchiveWithSuffix:@"tableHeaderInfos" fileName:@"CenterTopics"]) {
                [topNews addObject:[[CenterTopics alloc] initWithAttributes:topicNew]];
            }
            [_tableHeadView setTopBanerNews:topNews];
            
        }
    }
}

/**
 隐藏顶部table的头视图
 */
- (void)hideTableHeadView
{
    self.tableView.contentOffset = CGPointMake(0.0, 0.0);
    self.tableView.tableHeaderView = nil;
    [self.tableView reloadData];
}

/**
 设置顶部table headerview
 */
- (CenterTableHeadView *)tableHeadView{
    if (!_tableHeadView) {
       CenterTableHeadView * tableHeadView = [[CenterTableHeadView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 181.0)];
        tableHeadView.pushVC = self;
        _tableHeadView = tableHeadView;
    }
    
    return _tableHeadView;
}


#pragma mark 数据请求和刷新
/**
 下拉刷新，页码置成1
 切换tableview的datasource
 停止上拉加载
 断开网络时，从服务器读取缓存：1、首页状态下，取全部缓存新闻；2、氪星人的应用状态下，取全部应用信息；3、其他状态，按node_id（由newsType标记）来取;4、重置页码，方便网络重连后下啦加载
 网络连接时，网络请求数据，并根据对应的新闻是否已存在而选择存储与否
 */
- (void)headerRereshing{
    
    self.page = 1;
    self.tableView.dataSource = (_newsType == kCenterKrStarApp)?krStarAppsDataSource:self.tableViewArrayDataSource;
    [self.tableView footerEndRefreshing];

    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [self getCenterList];
    }else{
        if (_newsType != kCenterKrStarApp) {
            [self.CenterListModels removeAllObjects];
            [self getNewsFromSQLTable];
        }else{
            [self.starApps removeAllObjects];
            [self getNewsFromSQLTable];
        }
        [self.tableView headerEndRefreshing];

        __weak typeof(self)weakSelf = self;
        MAINBLOCK(^{
            if (weakSelf.newsType == kCenterHomePage)[weakSelf showTableHeadView];
            else [weakSelf.tableView reloadData];
        });
    }
    
}
/**
 上拉加载，页码为当前数组页数加一
 */
- (void)footerRereshing{
    
    [self.tableView headerEndRefreshing];
    if (_newsType == kCenterKrStarApp) {
        self.page = 1+self.starApps.count/PER_PAGE;
        
    }else{
        self.page = 1+self.CenterListModels.count/PER_PAGE;
        
    }
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
 
        [self getCenterList];

    }else{
        [self getNewsFromSQLTable];
    }
}

/**
 获取数据库中的相关数据,每次取PER_PAGE条，分页读取
 */
- (void)getNewsFromSQLTable{
    
    if (_newsType == kCenterKrStarApp) {
        if (self.starApps.count < [DataBaseManager findTheTableItemNumberWithModelName:@"KrStarAppInfo" keyName:nil keyValue:nil]) {
            [self.starApps addObjectsFromArray: [DataBaseManager findTheTableItemWithModelName:@"KrStarAppInfo" sql:$str(@"SELECT * FROM KrStarAppInfo limit %d,%d",(self.page-1)*PER_PAGE,PER_PAGE)]];

        }
        
    }else{
        if (self.CenterListModels.count < [DataBaseManager findTheTableItemNumberWithModelName:@"CenterTopics" keyName:(_newsType == kCenterHomePage)?nil:@"node_id" keyValue:$str(@"%d",_newsType)]) {
            [self.CenterListModels addObjectsFromArray:[DataBaseManager findTheTableItemWithModelName:@"CenterTopics" sql:(_newsType == kCenterHomePage)?$str(@"SELECT * FROM CenterTopics limit %d,%d",(self.page-1)*PER_PAGE,PER_PAGE):$str(@"SELECT * FROM CenterTopics where node_id = %@ limit %d,%d",$str(@"%d",_newsType),(self.page-1)*PER_PAGE,PER_PAGE)]];
        }
        
    }
    [self.tableView reloadData];
    [self.tableView footerEndRefreshing];

}

/**
 根据不同的页面类型，发起不同的请求
 */
- (void)getCenterList
{
    
    switch (_newsType) {
        case kCenterHomePage:
            if (_newsType == kCenterHomePage)[self showTableHeadView];
            [self getCenterListNewsWith:TOPICS];
            break;
        case kCenterKrStarApp:
            [self getCenterKrStarApps];
            break;
        case kCenterAbroadVentureCompany:
            [self getCenterListNewsWith:US_STARTUPS];
            
            break;
        case kCenterInlandVentureCompany:
            [self getCenterListNewsWith:CN_STARTUPS];
            
            break;
        case kCenterAbroadInformation:
            [self getCenterListNewsWith:BREAKING];
            
            break;
        case kCenterInlandInformation:
            [self getCenterListNewsWith:CN_NEWS];
            
            break;
        case kCenterLifeStyle:
            [self getCenterListNewsWith:DIGEST];
            
            break;
        case kCenterSpecialColumn:
            [self getCenterListNewsWith:COLUMN];
            
            break;
        default:
            break;
    }
}

/**
 brief 获取不同类型的新闻
 */
- (void)getCenterListNewsWith:(NSString *)subUrl
{
    __weak typeof(self)weakSelf = self;

    [AFNHttpRequestOPManager getInfoWithSubUrl:subUrl parameters:@{@"token":@"e1cbdfe589bff295bb29:12375",@"per_page":$str(@"%d",PER_PAGE),@"page":$str(@"%lu",(unsigned long)self.page)} block:^(id  result , NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;

       if(1 == strongSelf.page) [_CenterListModels removeAllObjects];
        if ([$safe(result) count]) {
            for (NSDictionary * topicNew in result) {
                CenterTopics * centerListMoel = [[CenterTopics alloc] initWithAttributes:topicNew];
                [_CenterListModels addObject:centerListMoel];
            }
        }
        MAINBLOCK(^{
            
            if(1 == strongSelf.page)  [strongSelf.tableView headerEndRefreshing];   //页码为1，说明在下拉刷新
            if(1 <= strongSelf.page)  [strongSelf.tableView footerEndRefreshing];   //页码不为1，说明在上拉加载
            [strongSelf.tableView reloadData];
            BACKGROUNDBLOCK(^{
                for (CenterTopics * centertop in _CenterListModels) {
                    
                    if (![DataBaseManager isModelExist:@"CenterTopics" keyName:@"resultId" keyValue:$str(@"%lu",(unsigned long)centertop.resultId)]) {
                        [DataBaseManager insertDataWithMDBModel:centertop];
                    }
                }
            });

        });
    }];
    
}

/**
 *brief 获取氪星人的应用列表
 */
- (void)getCenterKrStarApps
{
    __weak typeof(self)weakSelf = self;
    [AFNHttpRequestOPManager getInfoWithSubUrl:IOS_APPS parameters:@{@"per_page":$str(@"%d",PER_PAGE),@"page":$str(@"%lu",(unsigned long)self.page)} block:^(id  result , NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;

        if (strongSelf.page == 1)[strongSelf.starApps removeAllObjects];
        
        if ([$safe(result) count]) {
            for (int i = 0; i<[result count]; i++) {
                KrStarAppInfo * krStarAppInfo = [[KrStarAppInfo alloc] initWithAttributes:[result objectAtIndex:i]];
                [strongSelf.starApps addObject:krStarAppInfo];

            }
        }
        MAINBLOCK(^{
            [strongSelf.tableView reloadData];
            if(1 == strongSelf.page)  [strongSelf.tableView headerEndRefreshing];
            if(1 <= strongSelf.page)  [strongSelf.tableView footerEndRefreshing];
            BACKGROUNDBLOCK(^{
                for (KrStarAppInfo * krStarAppinfo in strongSelf.starApps) {
                    
                    if (![DataBaseManager isModelExist:@"KrStarAppInfo" keyName:@"appId" keyValue:$str(@"%lu",(unsigned long)krStarAppinfo.appId)]) {
                        [DataBaseManager insertDataWithMDBModel:krStarAppinfo];
                        
                    }
                }
            });
        });
    }];
    
}

#pragma mark UITableViewDelegate

/**
 新闻列表状态下，将cell对应的model传递给新闻详情页的newsInfo
 应用列表状态下，将cell对应的model的link属性中的新闻id截取出来，并传递给新闻详情页的newId
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LODetailViewController * detailVC = [[LODetailViewController alloc]init];
    if ($eql(self.tableViewArrayDataSource,self.tableView.dataSource)) {
        [detailVC setNewsInfo:_CenterListModels[indexPath.row]];
    }else{
        detailVC.newsId = [[[[_starApps[indexPath.row] valueForKey:@"link"] $split:@"/p/"] objectAtIndex:1] substringToIndex:6];
    }
    detailVC.detailType = kDETAILLeftBack;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return $eql(self.tableViewArrayDataSource,self.tableView.dataSource)?160:125;
}


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

@end
