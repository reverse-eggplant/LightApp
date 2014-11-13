//
//  DataBaseManager.h
//  LightApp
//
//  Created by malong on 14/11/13.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"


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

@end
