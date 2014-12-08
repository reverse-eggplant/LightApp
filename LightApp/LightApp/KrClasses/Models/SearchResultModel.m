//
//  SearchResultModel.m
//  LightApp
//
//  Created by malong on 14/11/30.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "SearchResultModel.h"

@interface SearchResultModel ()

@property (readwrite, nonatomic, copy) NSString * created_at;    //创建时间
@property (readwrite, nonatomic, copy) NSString * feature_img;  //信息图片
@property (readwrite, nonatomic) NSUInteger resultId;     //信息id
@property (readwrite, nonatomic) NSUInteger node_id;      //节点id
@property (readwrite, nonatomic, copy) NSString * node_name;  //节点名
@property (readwrite, nonatomic, copy) NSString * title;      //新闻标题
@property (readwrite, nonatomic, copy) NSString * updated_at;    //更新时间


@end

@implementation SearchResultModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    self.created_at = $safe([attributes valueForKey:@"created_at"]);
    self.feature_img = $safe([attributes valueForKey:@"feature_img"]);
    self.node_name = $safe([attributes valueForKey:@"node_name"]);
    self.title = $safe([attributes valueForKey:@"title"]);
    self.updated_at = $safe([attributes valueForKey:@"updated_at"]);
    self.created_at = $safe([attributes valueForKey:@"created_at"]);
    self.resultId = (NSUInteger)[$safe([attributes valueForKey:@"id"]) integerValue];
    self.node_id = (NSUInteger)[$safe([attributes valueForKey:@"node_id"]) integerValue];
    
    return self;
    
}


@end
