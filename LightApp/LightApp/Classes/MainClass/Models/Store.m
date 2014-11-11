//
//  Store.m
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "Store.h"
#import "Photo.h"

@implementation Store

+ (instancetype)getAStore{
    return [self new];
}

- (id)init{
    self = [super init];
    if (self) {
        [self readArchiveData];
    }
    return self;
    
}

//读取photodata.bin二进制文件里面的数据

- (void)readArchiveData{
    
    //要取数据，先获取路径
    NSURL * pictureDataURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"photodata" withExtension:@"bin"];
//    NSURL * pictureDataUrl = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle]pathForResource:@"photodata" ofType:@"bin"]];
    
    NSAssert(pictureDataURL != nil, @"Unable to find archive in bundle.");   //NSAssert(x!=0,@"x must not be zero");

    
    //由路径获取数据
    NSData * pictureData = [NSData dataWithContentsOfURL:pictureDataURL options:0 error:NULL];
    
    //数据解码
    NSKeyedUnarchiver * unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:pictureData];
    
    //根据键值将解码后的内容反编译成数组
    
    _pictures = [unArchiver decodeObjectOfClass:[NSArray class] forKey:@"photos"];
    //解码完成，关闭解码
    [unArchiver finishDecoding];
    


}

- (NSArray *)sortedPictures{
    return [self.pictures sortedArrayUsingComparator:^NSComparisonResult(Photo * picture1, Photo * picture2) {
        return [picture2.creationDate compare:picture1.creationDate];
    }];
}

@end
