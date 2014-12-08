//
//  ScreenImageView.h
//  LightApp
//
//  Created by malong on 14/12/2.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenImageView : UIView

- (id)initWithImageUrl:(NSString *)imageUrl;

-(void)show;
- (void)hide;

@end
