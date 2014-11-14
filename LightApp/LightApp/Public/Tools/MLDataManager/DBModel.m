//
//  DBModel.m
//  LightApp
//
//  Created by malong on 14/11/13.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "DBModel.h"


@implementation DBModel

- (id)init{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
    
}

- (NSDictionary *)propertiesDic {
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}


- (NSMutableArray*)propertyNames{
    unsigned int outCount, i;
    
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray * propertyNames = [NSMutableArray arrayWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [propertyNames addObject:propertyName];
        
    }
    
    free(properties);
    return propertyNames;
}



- (NSMutableArray *)propertyVaules{
    
    NSMutableArray * propertyNames = [self propertyNames];
    NSMutableArray * propertyVaules = [NSMutableArray arrayWithCapacity:propertyNames.count];
    
    for (int i = 0; i<propertyNames.count; i++) {

        id propertyValue = [self valueForKey:[propertyNames objectAtIndex:i]];
        
        if (nil != propertyValue) {
            [propertyVaules addObject:propertyValue];
        }
    }
    
    return propertyVaules;
}


@end
