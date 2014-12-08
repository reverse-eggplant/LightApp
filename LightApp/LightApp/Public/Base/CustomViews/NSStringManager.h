//
//  NSStringManager.h
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringManager : NSObject

/*
 *brief:根据字号大小和范围，获取字符串的尺寸
 *param size 视图区间
 */
+ (CGSize) sizeOfCurrentString:(NSString *)aString
                          font:(float)fontSize
                   contentSize:(CGSize)size;


/*
 *brief:根据字号大小和范围，获取字符串的尺寸
 *param size 视图区间
 *fontname 字体名称
 */
+ (CGSize) sizeOfCurrentString:(NSString *)aString
                          font:(float)fontSize
                   contentSize:(CGSize)size
                      WithName:(NSString*)fontname;

@end
