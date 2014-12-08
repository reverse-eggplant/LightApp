//
//  SetViewController.m
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LOSetViewController.h"
#import "LOSetDetailViewController.h"
#import <StoreKit/StoreKit.h>
#import "CustomAlertView.h"
#import "SetTableViewCell.h"
#import "UMFeedback.h"

@interface LOSetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SKStoreProductViewControllerDelegate>
{
    NSArray * items;
}
@end

static NSString * SetTableViewCellIdentifier = @"SetTableViewCellIdentifier";

@implementation LOSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    items = @[@"绑定 印象笔记",@"3G网络自动离线文章",@"清除缓存",@"评分与反馈",@"关于36氪",@"关于36氪App",@"微博分享"];
    
    [self.navigationItem setLeftBarButtonItem:[ViewFactory
                                               getABarButtonItemWithImage:@"nav-left"
                                               imageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 20)
                                               target:self
                                               selection:@selector(leftDrawerButtonPress)]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:SetTableViewCellIdentifier];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 45.0)];
    tableFooterView.backgroundColor = CLEARCOLOR;
    [SharedSingleton addAlabelForAView:tableFooterView withText:@"36氪 1.5（Build 159）" frame:CGRectMake(10.0, 8.0, ScreenWidth-20, 12.0) font:DEFAULT_FONT_S(12.0) textColor:UIColorFromRGB(0X5a565a)];
    [SharedSingleton addAlabelForAView:tableFooterView withText:@"Copyright 2012-1013,36kr.com" frame:CGRectMake(10.0, 23.0, ScreenWidth-20, 14.0) font:DEFAULT_FONT_S(12.0) textColor:UIColorFromRGB(0X5a565a)];
    

    self.tableView.tableFooterView = tableFooterView;
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setupRefresh
{
    return;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftDrawerButtonPress{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 10.0)];
    view.backgroundColor = CLEARCOLOR;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 10.0)];
    view.backgroundColor = CLEARCOLOR;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section==3)?4:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SetTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = items[(indexPath.section == 3)?(indexPath.row+3):indexPath.section];
    
    cell.cellType = (indexPath.section == 3)?((indexPath.row == 0)?TYPE_TOP:((indexPath.row == 3)?TYPE_BOTTOM:TYPE_CENTER)):TyPE_NONE;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            if ([DataBaseManager deleteDataBase]) {
                [CustomAlertView showWithTitle:@"成功清除！"];
                [USER_DEFAULT setBool:NO forKey:OFFLINEDONE];
                [USER_DEFAULT synchronize];
            }else{
                [CustomAlertView showWithTitle:@"清除失败！"];
            }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"AppStore评分", @"意见反馈",nil];
                    [alert show];
                }
                    break;
                case 1:
                case 2:
                {
                    LOSetDetailViewController * setDetailViewController = [[LOSetDetailViewController alloc]init];
                    setDetailViewController.naviTitle = (indexPath.row == 1)?@"关于36氪":@"关于36氪App";
                    setDetailViewController.webUrl = (indexPath.row == 1)?@"http://www.36kr.com/about?mobile=yes":@"http://about36krapp.sinaapp.com/app.html";
                    [self.navigationController pushViewController:setDetailViewController animated:YES];
                }
                    break;
                case 3:
                    
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

#pragma mark alertdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 1:
        {
            SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
            storeProductVC.delegate = self;
            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"593394038" forKey:SKStoreProductParameterITunesItemIdentifier];
            __weak typeof(self)weakSelf = self;
            [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if (result) {
                    [strongSelf presentViewController:storeProductVC animated:YES completion:nil];
                }
            }];
        }
            break;
        case 2:
        {
            [UMFeedback showFeedback:self withAppkey:UM_APPKEY];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
