//
//  RightTableViewCell.h
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RightHotNew;

@interface RightTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * numberLabel;
@property (nonatomic,weak)IBOutlet UILabel * conttentLabel;
@property (nonatomic,strong)RightHotNew * newsInfo;

@end

