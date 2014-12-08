//
//  KrStarAppInfo.m
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "KrStarAppInfo.h"
@interface KrStarAppInfo()
@property (readwrite, nonatomic, copy) NSString * code_block;    //代码块
@property (readwrite, nonatomic, copy) NSString * created_at;    //创建时间
@property (readwrite, nonatomic, copy) NSString * desc;         //详情
@property (readwrite, nonatomic, copy) NSString * favicon;      //应用icon
@property (readwrite, nonatomic, copy) NSString * link;         //网页链接
@property (readwrite, nonatomic, copy) NSString * name;         //应用名
@property (readwrite, nonatomic, copy) NSString * url;          //应用下载地址
@property (readwrite, nonatomic, assign)NSUInteger appId;   //应用id

@end
@implementation KrStarAppInfo

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self)return nil;
    self.code_block = $safe([attributes valueForKey:@"code_block"]);
    self.created_at =$safe([attributes valueForKey:@"created_at"]);
    self.desc = $safe([attributes valueForKey:@"desc"]);
    self.favicon = $safe([attributes valueForKey:@"favicon"]);
    self.link = $safe([attributes valueForKey:@"link"]);
    self.name = $safe([attributes valueForKey:@"name"]);
    self.url = $safe([attributes valueForKey:@"url"]);
    if (_url) {
        self.appId = [[[[self.url $split:@"/id"] objectAtIndex:1] substringToIndex:9] integerValue];
    }
    return self;
}
@end
