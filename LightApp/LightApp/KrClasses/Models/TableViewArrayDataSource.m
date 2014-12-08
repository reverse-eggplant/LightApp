//
//  TableViewArrayDataSource.m
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "TableViewArrayDataSource.h"


@implementation TableViewArrayDataSource

- (id)init{
    return nil;
}

- (id)initWithItems:(NSArray *)items
         identifier:(NSString *)identifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock{
    
    self = [super init];
    if (self) {
        self.items = items;
        self.identifier = identifier;
        self.configureCellBlock = [configureCellBlock copy];
    }
    
    return self;
}


- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.items[(NSUInteger)indexPath.row];  //在用时要记得用NSUInteger做强制转换
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
