//
//  SetTableViewCell.h
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

typedef enum {
    TyPE_NONE = 0,
    TYPE_TOP = 1,
    TYPE_CENTER = 2,
    TYPE_BOTTOM = 3
    
}CELLTYPE;
#import <UIKit/UIKit.h>

@interface SetTableViewCell : UITableViewCell
{
    UIImageView * backgroundImageView;
}

@property (nonatomic)CELLTYPE cellType;

@end
