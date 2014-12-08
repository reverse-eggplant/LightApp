//
//  CenterTopics.m
//  LightApp
//
//  Created by malong on 14/11/30.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "CenterTopics.h"

@interface CenterTopics()
@property (readwrite, nonatomic, copy) NSString * created_at;    //创建时间
@property (readwrite, nonatomic, copy) NSString * excerpt;    //引用
@property (readwrite, nonatomic) NSUInteger resultId;     //信息id
@property (readwrite, nonatomic) NSUInteger node_id;      //节点id
@property (readwrite, nonatomic, copy) NSString * feature_img;  //图片地址
@property (readwrite, nonatomic) NSUInteger last_reply_user_id;      //最后重复用户id
@property (readwrite, nonatomic, copy) NSString * last_reply_user_login;    //
@property (readwrite, nonatomic, copy) NSString * node_name;    //
@property (readwrite, nonatomic, copy) NSString * replied_at;    //
@property (readwrite, nonatomic) NSUInteger replies_count;    //
@property (readwrite, nonatomic, strong)NSArray * tags;
@property (readwrite, nonatomic, copy) NSString * title;    //
@property (readwrite, nonatomic, copy) NSString * user_avatar_url;
@property (readwrite, nonatomic, copy) NSString * user_id;
@property (readwrite, nonatomic, copy) NSString * user_login;
@property (readwrite, nonatomic, copy) NSString * user_name;@property (readwrite, nonatomic, copy) NSString * updated_at;    //
@property (readwrite, nonatomic, copy) NSString * body_html;    //创建时间


@end
@implementation CenterTopics

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

    self.excerpt = $safe([attributes valueForKey:@"excerpt"]);
    self.last_reply_user_id = (NSUInteger)[$safe([attributes valueForKey:@"last_reply_user_id"]) integerValue];
    self.last_reply_user_login = $safe([attributes valueForKey:@"last_reply_user_login"]);
    self.replied_at = $safe([attributes valueForKey:@"replied_at"]);
    self.tags = $safe([attributes valueForKey:@"tags"]);
    self.resultId = (NSUInteger)[$safe([attributes valueForKey:@"id"]) integerValue];
    self.node_id = (NSUInteger)[$safe([attributes valueForKey:@"node_id"]) integerValue];
    self.replies_count = (NSUInteger)[$safe([attributes valueForKey:@"replies_count"]) integerValue];
    self.body_html = $safe([attributes valueForKey:@"body_html"]);
    if ($safe([attributes valueForKey:@"user"])) {
        self.user_avatar_url = $safe([[attributes valueForKey:@"user"] valueForKey:@"avatar_url"]);
        self.user_id = $safe([[attributes valueForKey:@"user"] valueForKey:@"id"]);
        self.user_login = $safe([[attributes valueForKey:@"user"] valueForKey:@"login"]);
        self.user_name = $safe([[attributes valueForKey:@"user"] valueForKey:@"name"]);
    }
    
    return self;
    
}

@end


@implementation RightHotNew

@end
