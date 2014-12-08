//
//  CommentInfo.m
//  LightApp
//
//  Created by malong on 14/12/2.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "CommentInfo.h"
@interface CommentInfo()

@property (readwrite, nonatomic, copy) NSString * body;       //评论的话
@property (readwrite, nonatomic, copy) NSString * body_html;  //评论的html
@property (readwrite, nonatomic, copy) NSString * created_at; //评论时间
@property (readwrite, nonatomic) NSUInteger commentId;        //评论id
@property (readwrite, nonatomic) NSUInteger topic_id;         //顶部信息id
@property (readwrite, nonatomic, copy) NSString * updated_at; //评论更新时间
@property (readwrite, nonatomic, copy) NSString * message_id; //信息id
@property (readwrite, nonatomic, strong)NSDictionary * user; //用户信息

@end

@implementation CommentInfo

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.created_at =$safe([attributes valueForKey:@"created_at"]);
    self.updated_at = $safe([attributes valueForKey:@"updated_at"]);
    self.commentId = (NSUInteger)[$safe([attributes valueForKey:@"id"]) integerValue];
    self.body = $safe([attributes valueForKey:@"body"]);
    self.body_html = $safe([attributes valueForKey:@"body_html"]);
    self.message_id = $safe([attributes valueForKey:@"message_id"]);
    self.user = $safe([attributes valueForKey:@"user"]);
    self.topic_id = (NSUInteger)[$safe([attributes valueForKey:@"topic_id"]) integerValue];
    
    return self;
    
}

@end


