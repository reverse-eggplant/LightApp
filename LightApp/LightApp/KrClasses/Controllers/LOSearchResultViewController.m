//
//  SearchResultViewController.m
//  LightApp
//
//  Created by malong on 14/11/28.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LOSearchResultViewController.h"
#import "LODetailViewController.h"

#import "SearchResultTableViewCell.h"
#import "SearchResultModel.h"


@interface LOSearchResultViewController ()

@end

static NSString * SearchResultTableViewCellIdentifier = @"SearchResultTableViewCellIdentifier";

@implementation LOSearchResultViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.page = 1;
    self.navigationItem.title = [NSString stringWithFormat:@"搜索:%@",_searchTitle?:@""];
    [self setupNaviAndTableView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 设置导航栏和列表
 */
- (void)setupNaviAndTableView{
    
    [self.navigationItem setLeftBarButtonItem:[ViewFactory
                                               getABarButtonItemWithImage:@"nav-left"
                                               imageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 20)
                                               target:self
                                               selection:@selector(dismiss)]];
    

    TableViewCellConfigureBlock  tableViewCellConfigureBlock = ^(SearchResultTableViewCell * cell,SearchResultModel * searchResult){
        cell.titleLabel.text = searchResult.title;
        
    };
    
    if (!_results) {
        _results = [[NSMutableArray alloc]init];

    }
    
    self.tableViewArrayDataSource = [[TableViewArrayDataSource alloc]initWithItems:_results identifier:SearchResultTableViewCellIdentifier configureCellBlock:tableViewCellConfigureBlock];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableViewArrayDataSource;

    [self.tableView registerNib:[UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:SearchResultTableViewCellIdentifier];
    
    
}

#pragma mark 数据请求和刷新

/**
 下拉刷新，页码置成1
 */
- (void)headerRereshing{
    self.page = 1;
    [self searchNewsWithKeyword];
}

/**
 上拉加载，页码累加
 */
- (void)footerRereshing{
    self.page++;
    [self searchNewsWithKeyword];
  
}

/**
 根据关键字搜索，用来下拉刷新或者上拉加载
 */
- (void)searchNewsWithKeyword{
    
    __weak typeof(self)weakSelf = self;
    [AFNHttpRequestOPManager getInfoWithSubUrl:SEARCH parameters:@{@"p":_searchTitle,@"per_page":@"60",@"page":$str(@"%d",weakSelf.page)} block:^(id  result , NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;

        if (strongSelf.page == 1)[strongSelf.results removeAllObjects];
        
        if ([result isKindOfClass:[NSArray class]] && [result count])
        {
            for (NSDictionary * dic in result) {
                [strongSelf.results addObject:[[SearchResultModel alloc] initWithAttributes:dic]];
            }
        }
        MAINBLOCK(^{
            [strongSelf.tableView headerEndRefreshing];
            [strongSelf.tableView footerEndRefreshing];
            [strongSelf.tableView reloadData];
        });
        
    }];
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LODetailViewController * detailVC = [[LODetailViewController alloc]init];
    SearchResultModel * resultModel = _results[indexPath.row];
    detailVC.newsId = $str(@"%lu",(unsigned long)resultModel.resultId);
    detailVC.detailType = kDETAILLeftBack;
    [self.navigationController pushViewController:detailVC animated:YES];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - Button Handlers
/**
 模态退出
 */
-(void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

@end
