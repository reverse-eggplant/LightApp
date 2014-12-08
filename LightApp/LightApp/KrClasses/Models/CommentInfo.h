//
//  CommentInfo.h
//  LightApp
//
//  Created by malong on 14/12/2.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (readonly, nonatomic, copy) NSString * body;       //评论的话
@property (readonly, nonatomic, copy) NSString * body_html;  //评论的html
@property (readonly, nonatomic, copy) NSString * created_at; //评论时间
@property (readonly, nonatomic) NSUInteger commentId;        //评论id
@property (readonly, nonatomic) NSUInteger topic_id;         //顶部信息id
@property (readonly, nonatomic, copy) NSString * message_id; //信息id
@property (readonly, nonatomic, copy) NSString * updated_at; //评论更新时间
@property (readonly, nonatomic, strong)NSDictionary * user; //用户信息

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end

