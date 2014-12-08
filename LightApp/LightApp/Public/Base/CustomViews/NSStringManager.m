//
//  NSStringManager.m
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "NSStringManager.h"

@implementation NSStringManager

//字符串尺寸
+ (CGSize) sizeOfCurrentString:(NSString *)aString
                          font:(float)fontSize
                   contentSize:(CGSize)size
{
    if (aString == nil || aString.length == 0) {
        return CGSizeZero;
    }
    
    NSRange range = NSMakeRange(0, aString.length);
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:aString];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    CGSize stringSize = [aString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[attri attributesAtIndex:0 effectiveRange:&range] context:nil].size;

    return stringSize;
    
}

+ (CGSize) sizeOfCurrentString:(NSString *)aString
                          font:(float)fontSize
                   contentSize:(CGSize)size
                      WithName:(NSString*)fontname
{
    
    if (aString == nil || aString.length == 0) {
        return CGSizeZero;
    }
    
    NSRange range = NSMakeRange(0, aString.length);
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:aString];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:fontname size:fontSize] range:range];
    CGSize stringSize = [aString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[attri attributesAtIndex:0 effectiveRange:&range] context:nil].size;
        return stringSize;
}


@end
