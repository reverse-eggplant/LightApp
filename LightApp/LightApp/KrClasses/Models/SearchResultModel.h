//
//  SearchResultModel.h
//  LightApp
//
//  Created by malong on 14/11/30.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject

@property (readonly, nonatomic, copy) NSString * created_at;    //创建时间
@property (readonly, nonatomic, copy) NSString * feature_img;  //信息图片
@property (readonly, nonatomic) NSUInteger resultId;     //信息id
@property (readonly, nonatomic) NSUInteger node_id;      //节点id
@property (readonly, nonatomic, copy) NSString * node_name;  //节点名
@property (readonly, nonatomic, copy) NSString * title;      //新闻标题
@property (readonly, nonatomic, copy) NSString * updated_at;    //更新时间

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
