//
//  BCEBasePost.h
//  BCE
//
//  Created by malong on 14-7-6.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNRequestManager : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

/*
 *brief 检查网络状态
 */
+ (void)checkNetWorkStatus;



/*
 *brief get方法获取数据
 */
+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;



/*
 *brief post方法获取数据
 *param Parameters 参数字典集合
 *param suburl 接口地址
 *param block  数据回调block
 */
+ (void)postWithParameters:(NSDictionary *)Parameters
                    subUrl:(NSString *)suburl
                     block:(void (^)(NSDictionary *resultDic, NSError *error))block;




/*
 *brief post方法上传图片和视频接口
 *param Parameters 参数字典集合
 *param imageDatas 图片数据数组集合
 *param names 图片地址名称数组集合     注：根据后台提供的接口不同表单提交时的命名也不同，此处只做参考
 *param video 视频上传数据
 *param suburl 接口地址
 *param block  数据回调block
 */
+ (void)postWithParameters:(NSDictionary *)Parameters
                    subUrl:(NSString *)suburl
                imageDatas:(NSArray *)imageDatas
                     names:(NSArray *)names
                     video:(NSData *)video
                     block:(void (^)(NSDictionary *resultDic, NSError *error))block;



/*
 *brief get方法获取数据
 *param Parameters 参数字典集合
 *param suburl 接口地址
 *param block  数据回调block
 */
+ (void)getInfoWithSubUrl:(NSString *)subUrl
               parameters:(NSDictionary *)Parameters
                    block:(void (^)(NSDictionary * resultDic, NSError *error))block;



/*
 *brief get方法获取数据
 *param suburl 接口地址
 *param block  数据回调block
 */
+ (void)getInfoWithSubUrl:(NSString *)subUrl
                    block:(void (^)(NSDictionary * resultDic, NSError *error))block;




/*
 *brief 取消网络请求
 */
+ (void)cancelRequest;

@end
