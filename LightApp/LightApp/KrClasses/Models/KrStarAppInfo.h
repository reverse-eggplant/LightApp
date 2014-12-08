//
//  KrStarAppInfo.h
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KrStarAppInfo : NSObject

@property (readonly, nonatomic, copy) NSString * code_block;    //代码块
@property (readonly, nonatomic, copy) NSString * created_at;    //创建时间
@property (readonly, nonatomic, copy) NSString * desc;         //详情
@property (readonly, nonatomic, copy) NSString * favicon;      //应用icon
@property (readonly, nonatomic, copy) NSString * link;         //网页链接
@property (readonly, nonatomic, copy) NSString * name;         //应用名
@property (readonly, nonatomic, copy) NSString * url;          //应用下载地址

@property (readonly, nonatomic, assign)NSUInteger appId;   //应用id

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
