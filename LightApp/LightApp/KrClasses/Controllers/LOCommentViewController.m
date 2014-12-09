//
//  CommentViewController.m
//  LightApp
//
//  Created by malong on 14/12/2.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LOCommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentInfo.h"
#import "BottomToolBar.h"
#import "CustomAlertView.h"

@interface LOCommentViewController ()
{
    BottomBackBar * bottombackBar;
}
@end

static NSString * CommentTableViewCellID = @"CommentTableViewCellID";

@implementation LOCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //手动添加状态栏，在当前界面消失后移除
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, StatusBarHeight)];
    statusView.backgroundColor = UIColorFromRGB(0x0083d5);
    statusView.tag = 150;
    [MAINWINDOW addSubview:statusView];
    
    [self setupTableView];
    
    bottombackBar = [[BottomBackBar alloc]initWithFrame:CGRectMake(0.0, self.view.frame.size.height-45.0, ScreenWidth, 45.0) currentVC:self];
    [self.tableView addSubview:bottombackBar];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[MAINWINDOW viewWithTag:150]removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[AFNetworkReachabilityManager sharedManager] isReachable] && !_commentInfos.count) {
        [CustomAlertView showWithTitle:@"网络已断开！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SXViewConrollerManager popToLastViewController];
            
        });
        
    }
}

- (void)setupRefresh{}

//设置列表
- (void)setupTableView{
    
    
    TableViewCellConfigureBlock  tableViewCellConfigureBlock = ^(CommentTableViewCell * cell,CommentInfo * commentInfo){
        [cell setCommentInfo:commentInfo];
        
    };
    
    if (!self.commentInfos) {
        self.commentInfos = $marrnew;
        self.tableViewArrayDataSource = [[TableViewArrayDataSource alloc]initWithItems:self.commentInfos identifier:CommentTableViewCellID configureCellBlock:tableViewCellConfigureBlock];
        
        __weak typeof(self)weakSelf = self;
        [AFNHttpRequestOPManager getInfoWithSubUrl:[REPLIES stringByReplacingOccurrencesOfString:@"infoid" withString:self.infoId] parameters:nil block:^(id  result , NSError *error) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            if ($safe(result) &&[[$safe(result) valueForKey:@"replies"] count]) {
                for (NSDictionary * comment in [$safe(result) valueForKey:@"replies"]) {
                    CommentInfo * commentInfo = [[CommentInfo alloc]initWithAttributes:comment];
                    [strongSelf.commentInfos addObject:commentInfo];
                }
                MAINBLOCK(^{[strongSelf.tableView reloadData];});
            }
        }];
        
    }else{
        self.tableViewArrayDataSource = [[TableViewArrayDataSource alloc]initWithItems:self.commentInfos identifier:CommentTableViewCellID configureCellBlock:tableViewCellConfigureBlock];

    }

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableViewArrayDataSource;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:CommentTableViewCellID];
    UIView * tableFooterView = [ViewFactory clearViewWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 45.0)];
    self.tableView.tableFooterView = tableFooterView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    bottombackBar.frame = CGRectMake(0.0, self.view.frame.size.height+scrollView.contentOffset.y-45.0, ScreenWidth, 45.0);
}


@end
