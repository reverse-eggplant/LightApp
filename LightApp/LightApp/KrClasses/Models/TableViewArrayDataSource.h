//
//  TableViewArrayDataSource.h
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

//tableView的公用datasource

/*
 *brief cell设置block
 */
typedef void(^TableViewCellConfigureBlock) (id cell , id item);

#import <Foundation/Foundation.h>

@interface TableViewArrayDataSource : NSObject<UITableViewDataSource>

/*
 *param items 列表数据数组
 */
@property (nonatomic,strong) NSArray * items;


/*
 *param identifier 列表cell的唯一标示
 */
@property (nonatomic,copy) NSString * identifier;


/*
 *param configureCellBlock 设置cell的block，在block里面对cell和item进行处理
 */
@property (nonatomic,copy)TableViewCellConfigureBlock configureCellBlock;


/*
 *brief 根据各类数据初始化
 */
- (id)initWithItems:(NSArray *)items
         identifier:(NSString *)identifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

/*
 *brief 返回某个cell对应的item
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;


@end
