//
//  DataBaseManager.h
//  LightApp
//
//  Created by malong on 14/11/13.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"
#import "DBModel.h"


typedef enum{
    kDBCREATEFAILURE = -1,     //创建失败
    kDBHASEXSIT = 0,            //已经存在
    kDBCREATESUCCESS = 1        //创建成功
    
}DBTYPE;


@class FMDatabase;

/**
 * @brief 对本地数据链接进行操作管理，建立链接和关闭连接
 */

@interface DataBaseManager : NSObject
{
    NSString * _dataBasePath;  //数据库路径
}

@property (nonatomic, readonly) FMDatabase * dataBase;  // 数据库操作对象，数据库建立后，存在此处


+(DataBaseManager *) defaultDataBaseManager;


- (void) close;  // 关闭数据库


/**
 * @brief 创建数据库
 */
- (void) createDataBaseWithModelName:(NSString *)modelName;



/**
 * @brief 保存一条用户记录
 *
 * @param dataModel 需要保存的数据模型
 */
- (void) saveDataModel:(DBModel *) dataModel;



/**
 * @brief 删除一条用户数据
 *
 * @param modelName 需要删除的数据模型的名称
 * @param key 需要删除的数据模型的主键
 */
- (void) deleteDataModelWithModelName:(NSString *)modelName key:(NSString *) key;



/**
 * @brief 修改用户的信息
 *
 * @param dataModel 需要修改的数据模型
 */
- (void) mergeWithDataModel:(DBModel *) dataModel;



/**
 * @brief 模拟分页查找数据。取modelId大于某个值以后的limit个数据
 *
 * @param modelName 需要查询的数据模型的名称
 * @param key 需要查询的数据模型的主键
 * @param limit 每页取多少个
 */
- (NSArray *) findWithModelName:(NSString *)modelName key:(NSString *) key limit:(int) limit;



@end
