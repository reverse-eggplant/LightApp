//
//  StartScreenView.m
//  LightApp
//
//  Created by malong on 14/11/28.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "StartScreenView.h"

@implementation StartScreenView

- (id)initWithScreenNews:(NSDictionary *)screenNews
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight)];
    if (!self) return nil;
    
   UIImageView * advertisement = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight)];
    [advertisement setImageWithURL:[NSURL URLWithString:[screenNews valueForKey:@"favicon"]]];
    advertisement.tag = 150;
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight-0.0)];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[screenNews valueForKey:@"url"]]]];
    [self addSubview:webView];
    
    [self addSubview:advertisement];
    __weak typeof(advertisement)weakAdvertisement = advertisement;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            weakAdvertisement.frame = CGRectMake(-ScreenWidth, 0.0, ScreenWidth-40.0, 80.0);
        }completion:^(BOOL finished) {
            [weakAdvertisement removeFromSuperview];
        }];
    });
    UIButton * jumpButton = [SharedSingleton getAButtonWithFrame:CGRectMake(ScreenWidth-60.0, 20.0, 50.0, 50.0) nomalTitle:@"跳过" hlTitle:@"跳过" titleColor:DARK bgColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8] nbgImage:nil hbgImage:nil action:@selector(jumpButtonAction) target:self buttonTpye:UIButtonTypeCustom];
    jumpButton.titleLabel.font = CELL_BOLDFONT(16.0);
    jumpButton.layer.cornerRadius = 25.0;
    [self addSubview:jumpButton];
    
    return self;
}

- (void)jumpButtonAction
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(-ScreenWidth, 0.0, ScreenWidth, ScreenHeight);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
