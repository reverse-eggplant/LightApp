//
//  CenterTopics.h
//  LightApp
//
//  Created by malong on 14/11/30.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CenterTopics : NSObject

@property (readonly, nonatomic, copy) NSString * created_at; //创建时间
@property (readonly, nonatomic, copy) NSString * excerpt;    //引用
@property (readonly, nonatomic) NSUInteger resultId;     //信息id
@property (readonly, nonatomic) NSUInteger node_id;      //节点id
@property (readonly, nonatomic, copy) NSString * feature_img;  //图片地址
@property (readonly, nonatomic) NSUInteger last_reply_user_id;      //最后重复用户id
@property (readonly, nonatomic, copy) NSString * last_reply_user_login;    //
@property (readonly, nonatomic, copy) NSString * node_name;     //
@property (readonly, nonatomic, copy) NSString * replied_at;    //
@property (readonly, nonatomic) NSUInteger replies_count;       //
@property (readonly, nonatomic, strong)NSArray * tags;
@property (readonly, nonatomic, copy) NSString * title;         //

@property (readonly, nonatomic, copy) NSString * user_avatar_url;
@property (readonly, nonatomic, copy) NSString * user_id;
@property (readonly, nonatomic, copy) NSString * user_login;
@property (readonly, nonatomic, copy) NSString * user_name;

@property (readonly, nonatomic, copy) NSString * updated_at;    //
@property (readonly, nonatomic, copy) NSString * body_html;     //创建时间


- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end



//右侧控制器中，我的收藏和实时热门列表的cell对应model
@interface RightHotNew : CenterTopics

@property (nonatomic)float numberLabelAlpha;

@end

