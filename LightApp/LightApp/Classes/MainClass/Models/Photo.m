//
//  Picture.m
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "Photo.h"

//存入时按此键值编码，解码时也按如下键值
static NSString * const IdentifierKey = @"identifier";
static NSString * const NameKey = @"name";
static NSString * const CreationDateKey = @"creationDate";

@implementation Photo

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeInt64:self.identifier forKey:IdentifierKey];
    [aCoder encodeObject:self.name forKey:NameKey];
    [aCoder encodeObject:self.creationDate forKey:CreationDateKey];
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeInt64ForKey:IdentifierKey];
        self.name = [aDecoder decodeObjectOfClass:[NSString class] forKey:NameKey];
        self.creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:CreationDateKey];

    }
    return self;
}

- (BOOL)requiresSecureCoding
{
    return YES;
}

@end
