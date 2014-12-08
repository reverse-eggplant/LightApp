//
//  CustomAlertView.h
//  LightApp
//
//  Created by malong on 14/12/7.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title      //提示语
          imageName:(NSString *)imageName; //提示图片

+ (void)showWithTitle:(NSString *)title;      //提示语

- (void)show;
- (void)hide;

@end
