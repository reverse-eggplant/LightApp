//
//  BaseViewController.m
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.view.alpha = 1.0;
    
    [[SXViewConrollerManager sharedVCMInstance]setRootController:self];
    
    DLog(@"_pushinfo = %@",_pushInfo);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _pushInfo = nil;
}

#pragma mark 视图设置




#pragma mark 视图控制器跳转
- (void)PopToLastViewController{
    
    [SXViewConrollerManager clearDelegate];

    [self.navigationController popViewControllerAnimated:YES];
    

}
- (void)PopToRootViewController{
    
    [SXViewConrollerManager clearDelegate];
  
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
