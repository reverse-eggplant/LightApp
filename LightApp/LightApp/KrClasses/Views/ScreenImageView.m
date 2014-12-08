//
//  ScreenImageView.m
//  LightApp
//
//  Created by malong on 14/12/2.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "ScreenImageView.h"

@implementation ScreenImageView

- (id)initWithImageUrl:(NSString *)imageUrl{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight)];
    self.backgroundColor = RGBAColor(0.0, 0.0, 0.0, 0.8);
    if (!self) return nil;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight)];
    imageView.backgroundColor = CLEARCOLOR;
    imageView.contentMode = UIViewContentModeCenter;
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self addSubview:imageView];
    self.alpha = 0.0;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    return self;
}

- (void)show{
    
    [MAINWINDOW addSubview:self];
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 1;
    }];
}

- (void)hide{
    
    __weak typeof(self)weakSelf = self;

    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0.0;
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
