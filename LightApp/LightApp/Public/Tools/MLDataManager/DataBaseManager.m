//
//  DataBaseManager.m
//  LightApp
//
//  Created by malong on 14/11/13.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDatabase.h"

#define kDefaultDataBaseName @"LightApp.sqlite"

@implementation DataBaseManager

static DataBaseManager * _defaultDataBaseManager = nil;
static dispatch_once_t once = 0;

+(DataBaseManager *) defaultDataBaseManager{
    
    dispatch_once(&once, ^{
        _defaultDataBaseManager = [[DataBaseManager alloc] init];
        
    });
    return _defaultDataBaseManager;

}

- (void) dealloc {
    [self close];
}

- (id) init {
    
    self = [super init];
    
    if (self) {
        int state = [self initializeDBWithName:kDefaultDataBaseName];
        
        if (state == kDBCREATEFAILURE) {
            DLog(@"数据库初始化失败");
        } else {
            DLog(@"数据库初始化成功");
        }
    }
    return self;
}

/**
 * @brief 初始化数据库操作
 * @param name 数据库名称
 * @return 返回数据库初始化状态，
 */

- (int) initializeDBWithName : (NSString *) name {
    if (!name) {
        return kDBCREATEFAILURE;  // 返回数据库创建失败
    }
    // 沙盒Docu目录
    NSString * filePath = [NSString stringWithFormat:@"/%@",name];
    _dataBasePath = DOCUMENTFILEPATH(filePath);
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:_dataBasePath];
    [self connect];
    if (!exist) {
        return kDBHASEXSIT;
    } else {
        return kDBCREATESUCCESS;
    }
    
}



/// 连接数据库
- (void) connect {
    
    if (!_dataBase) {
        _dataBase = [[FMDatabase alloc] initWithPath:_dataBasePath];
    }
    if (![_dataBase open]) {
        DLog(@"不能打开数据库");
    }
}
/// 关闭连接
- (void) close {
    [_dataBase close];
    _defaultDataBaseManager = nil;
}


#pragma mark 数据库操作方法

- (void) createDataBaseWithModelName:(NSString *)modelName{
    
    FMResultSet * set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",modelName]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        [AppDelegate showStatusWithText:@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE SUser (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, name VARCHAR(50), description VARCHAR(100))";
        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
            [AppDelegate showStatusWithText:@"数据库创建失败" duration:2];
        } else {
            [AppDelegate showStatusWithText:@"数据库创建成功" duration:2];
        }
    }
}



@end
