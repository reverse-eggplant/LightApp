//
//  AFNHttpRequestOPManager.h
//  LightApp
//
//  Created by malong on 14/11/20.
//  Copyright (c) 2014年 malong. All rights reserved.
//

/*
 *前言：通常来说，AFNetworking已经是高度封装的了，在用到AFNetworking发请求的类里，我们直接可以调用
 *AFNetworking的API。但是，在实际开发中，我们常常将设备、版本、和账户等信息，在接口中作为参数集中提交
 *到服务器。而网络请求异常等信息，也希望集中处理。这时，在每个调用AFNetworking的地方分别处理就比较麻烦,
 *单独封装一个网略请求类，做集中处理，会跟方便管理，也便于复用和扩展。
 *
 *注：该类中的上传图片和视频的接口，是在做某个项目时根据接口需求进行的封装，并不适用于所有视频和图片上传
 *的状况。
 */

#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface AFNHttpRequestOPManager : AFHTTPRequestOperationManager

@property (nonatomic,strong)MBProgressHUD * myProgressHUD;

+ (instancetype)sharedManager;

/*
 *brief 检查网络状态
 */
+ (void)checkNetWorkStatus;

- (void)showMyProgressHUDWith:(NSString *)text;

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
                    block:(void (^)(id result, NSError *error))block;



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
