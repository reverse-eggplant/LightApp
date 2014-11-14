//
//  DBModel.h
//  LightApp
//
//  Created by malong on 14/11/13.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


/**
 * @brief 数据库模型基类，其他所有数据库存储对象都继承于它
 */

@interface DBModel : NSObject

@property (nonatomic, copy) NSString * modelId; //可存入数据库的模型标示id


/**
 * @brief 属性列表
 */
- (NSDictionary *)propertiesDic;

/**
 * @brief 属性列表名数组
 */
- (NSMutableArray*)propertyNames;


/**
 * @brief 属性对应值数组
 */
- (NSMutableArray*)propertyVaules;

@end
