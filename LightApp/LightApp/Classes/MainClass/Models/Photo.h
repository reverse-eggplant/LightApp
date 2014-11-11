//
//  Picture.h
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

/*
 *接收photodata.bin反序列化后数据的对象，注意类名和属性名等参数要跟photodata所存一致，否则解码会失败
 *或者数据丢失
 */
#import <Foundation/Foundation.h>

@interface Photo : NSObject<NSCoding>  //实现nscoding协议的两个方法

@property (nonatomic) int64_t identifier;      //数据标示id

@property (nonatomic,copy) NSString * name;    //图片名

@property (nonatomic,strong)NSDate * creationDate; //图片创建时间

@end
