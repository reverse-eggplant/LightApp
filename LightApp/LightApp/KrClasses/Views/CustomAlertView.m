//
//  CustomAlertView.m
//  LightApp
//
//  Created by malong on 14/12/7.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
          imageName:(NSString *)imageName {
    self = [super initWithFrame:frame];
    self.backgroundColor = RGBAColor(50.0, 50.0, 50.0, 0.8);
    if (!self) return nil;
    self.layer.cornerRadius = 10.0;
    if (imageName) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:LOADPNGIMAGE(imageName)];
        imageView.frame = CGRectMake(10.0, 10.0, frame.size.width-20.0, frame.size.height-20.0);
        [self addSubview:imageView];
    }
    [SharedSingleton addAlabelForAView:self withText:title frame:CGRectMake(5.0, frame.size.height/2.0-10.0, frame.size.width-10, 20.0) font:CELL_BOLDFONT(20.0) textColor:[UIColor whiteColor]];
    [self show];
    return self;
    
}
+ (void)showWithTitle:(NSString *)title{
    CustomAlertView * customView = [[[self class] alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-75.0, ScreenHeight/2.0-25.0, 150.0, 50.0) title:title imageName:nil];
    [customView show];
}


- (void)show{
    [MAINWINDOW addSubview:self];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    NSLog(@"show");
    self.alpha = 1;
    [self.layer addAnimation:popAnimation forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)hide
{
    NSLog(@"hideAlertAction");
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animationDidStop");
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
