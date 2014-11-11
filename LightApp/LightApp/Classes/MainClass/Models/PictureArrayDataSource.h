//
//  PictureArrayDataSource.h
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

/*
 
 
 */

typedef void(^TableViewCellConfigureBlock) (id cell , id item);

#import <Foundation/Foundation.h>

@interface PictureArrayDataSource : NSObject<UITableViewDataSource>

//根据各类数据初始化
- (id)initWithItems:(NSArray *)items
           identifier:(NSString *)identifier
   configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

//返回某个cell对应的item
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;


@end
