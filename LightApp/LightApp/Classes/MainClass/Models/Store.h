//
//  Store.h
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

+ (instancetype)getAStore;   //返回当前类的一个示例

@property (nonatomic,readonly,strong) NSArray * pictures;

- (NSArray *)sortedPictures;

@end
