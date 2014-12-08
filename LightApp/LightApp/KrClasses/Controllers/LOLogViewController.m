//
//  LOLogViewController.m
//  LightApp
//
//  Created by malong on 14/12/6.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LOLogViewController.h"
#import "GTMBase64.h"
#import "JSONKit.h"

@interface LOLogViewController ()<UITextFieldDelegate>
{
    UITextField * userTF;
    UITextField * passWordTF;
}

@end

@implementation LOLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    [self setupSubViews];
}

- (void)setupSubViews{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = CELL_BOLDFONT(14.0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, -10.0);
    [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
    
    UIImageView * userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 150+NavigationBarHeight+StatusBarHeight, ScreenWidth-20.0, 39.0)];
    userImageView.image = [LOADPNGIMAGE(@"login-textfield") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    [self.view addSubview:userImageView];
    userTF = [SharedSingleton getATFWithFrame:CGRectMake(15.0, 150+NavigationBarHeight+StatusBarHeight, ScreenWidth-30.0, 39.0) delegate:self palceHolder:@"用户名" image:nil];
    userTF.returnKeyType = UIReturnKeyNext;
    userTF.font = CELL_BOLDFONT(16.0);
    [self.view addSubview:userTF];
    
    
    UIImageView * passWordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 195+NavigationBarHeight+StatusBarHeight, ScreenWidth-20.0, 39.0)];
    passWordImageView.image = [LOADPNGIMAGE(@"login-textfield") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    [self.view addSubview:passWordImageView];
    passWordTF = [SharedSingleton getATFWithFrame:CGRectMake(15.0, 195+NavigationBarHeight+StatusBarHeight, ScreenWidth-30.0, 39.0) delegate:self palceHolder:@"密码" image:nil];
    passWordTF.font = CELL_BOLDFONT(16.0);
    passWordTF.secureTextEntry = YES;
    passWordTF.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:passWordTF];
    
    
    UIButton * sinaLoginButton = [SharedSingleton getAButtonWithFrame:CGRectMake(10.0, 280.0+(ScreenHeight-339.0)/2.0, 125.0, 39.0) nomalTitle:nil hlTitle:nil titleColor:[UIColor whiteColor] bgColor:nil nbgImage:@"login-weibo" hbgImage:@"login-weibo" action:nil target:nil buttonTpye:UIButtonTypeCustom];
    [[SharedSingleton addAlabelForAView:sinaLoginButton withText:@"新浪登录" frame:CGRectMake(15.0,10.0,100.0,15.0) font:CELL_BOLDFONT(15.0) textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:sinaLoginButton];
    
    
    
    [SharedSingleton addAlabelForAView:self.view withText:@"OR" frame:CGRectMake(ScreenWidth/2.0-15, 290.0+(ScreenHeight-339.0)/2.0, 30, 15.0) font:CELL_BOLDFONT(15.0) textColor:[UIColor blackColor]];
    
    
    
    UIButton * tencentButton = [SharedSingleton getAButtonWithFrame:CGRectMake(ScreenWidth-135.0, 280.0+(ScreenHeight-339.0)/2.0, 125.0, 39.0) nomalTitle:nil hlTitle:nil titleColor:[UIColor whiteColor] bgColor:nil nbgImage:@"login-qq" hbgImage:@"login-qq" action:nil target:nil buttonTpye:UIButtonTypeCustom];
    [[SharedSingleton addAlabelForAView:tencentButton withText:@"腾讯登录" frame:CGRectMake(10.0,10.0,100.0,15.0) font:CELL_BOLDFONT(15.0) textColor:[UIColor whiteColor]] setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:tencentButton];
    
    
    
    UIButton * registerButton = [SharedSingleton getAButtonWithFrame:CGRectMake(10.0, ScreenHeight-28.0, ScreenWidth-20.0, 13.0) nomalTitle:@"没有36Kr账号？注册一个吧" hlTitle:@"没有36Kr账号？注册一个吧" titleColor:UIColorFromRGB(0X555555) bgColor:nil nbgImage:nil hbgImage:nil action:@selector(goToRegister) target:self buttonTpye:UIButtonTypeCustom];
    registerButton.titleLabel.font = CELL_BOLDFONT(13.0);
    [self.view addSubview:registerButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)goToRegister{
    
}

/*
 *brief 登录
 */
- (void)goToLogin
{
    if (!(userTF.text.length && passWordTF.text.length)) return;
    
    
    NSString *str = [NSString stringWithFormat:@"%@:%@",userTF.text,passWordTF.text];
    NSMutableURLRequest *r = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.36kr.com/account/user_tokens.json"]];
    NSString *encodedStr =  [GTMBase64 stringByEncodingData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [r setValue:[@"Basic " stringByAppendingString:encodedStr]forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:r queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"response.string = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary * resultDic = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] objectFromJSONString];
        
        
    }];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self goToLogin];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self goToLogin];
    
    return YES;
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
