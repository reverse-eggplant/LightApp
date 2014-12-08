//
//  SetTableViewCell.m
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell

- (void)awakeFromNib {
    backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 0.0, ScreenWidth-20.0, 50.0)];
    [self.contentView addSubview:backgroundImageView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(CELLTYPE)cellType
{
    _cellType = cellType;
    NSString * imageName;
    switch (cellType)
    {
        case TyPE_NONE:
            imageName = @"cell";
            break;
        case TYPE_TOP:
            imageName = @"cell-top";
            break;
        case TYPE_CENTER:
            imageName = @"cell-center";
            break;
        case TYPE_BOTTOM:
            imageName = @"cell-bottom";
            break;
            
        default:
            break;
    }
    
    __block UIImageView * bgiv = backgroundImageView;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       UIEdgeInsets edgeinset = UIEdgeInsetsMake(10, 5, 10, 5);
       UIImage * bgimage = [LOADPNGIMAGE(imageName) resizableImageWithCapInsets:edgeinset];
        dispatch_async(dispatch_get_main_queue(), ^{
            bgiv.image = bgimage;
        });
    });
    
    [self setNeedsDisplay];
    
}

@end
