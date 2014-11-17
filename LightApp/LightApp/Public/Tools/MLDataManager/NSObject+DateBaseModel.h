//
//  NSObject+DateBaseModel.h
//  LightApp
//
//  Created by malong on 14/11/15.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 * @brief 数据库模型类目
 */


@interface NSObject (DateBaseModel)


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


/**
 * @brief 获取对象的所有方法信息
 */
-(NSArray *)mothodLists;

@end
