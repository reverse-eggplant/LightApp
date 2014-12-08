//
//  AFBreakpointDownLoader.h
//  LightApp
//
//  Created by malong on 14/12/7.
//  Copyright (c) 2014年 malong. All rights reserved.
// 版权说明：
// 本类大部分代码来自于源码分享网站: Code4App.com
// 在源码基础上做了部分改动
//原demo地址：http://code4app.com/ios/DownloadOperation/53f60fe8933bf0d36a8b5726


#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 *获取缓存路径的代码块
 */
typedef NSString *(^cacheFilePathBlock)(void);

/**
 *跟踪下载进度的代码块
 */
typedef void(^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface AFBreakpointDownLoader : NSObject

@property (nonatomic, copy)cacheFilePathBlock cacheFilePathBlock;

@property(nonatomic , copy)progressBlock progressBlock;

@property (nonatomic,strong)    AFHTTPRequestOperation* requestOperation;


-(void)downloadWithUrl:(id)url
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//下载暂停
- (void)pause;

//下载继续
- (void)resume;

@end
