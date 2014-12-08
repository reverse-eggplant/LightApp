//
//  SetDetailViewController.m
//  LightApp
//
//  Created by malong on 14/12/3.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LOSetDetailViewController.h"

@interface LOSetDetailViewController ()
{
    UIWebView * detailWebView;
    
}
@end

@implementation LOSetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _naviTitle;
    
    if (_webUrl.length) {
        detailWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:detailWebView];
        [detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
        
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
