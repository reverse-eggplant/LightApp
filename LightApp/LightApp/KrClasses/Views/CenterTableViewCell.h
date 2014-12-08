//
//  CenterTableViewCell.h
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CenterTopics;

@interface CenterTableViewCell : UITableViewCell

+ (UINib *)nib;

@property (nonatomic,weak)IBOutlet UILabel * titleLabel;
@property (nonatomic,weak)IBOutlet UILabel * detailLabel;
@property (nonatomic,weak)IBOutlet UILabel * dateLabel;
@property (nonatomic,weak)IBOutlet UILabel * commentsLabel;

@property (nonatomic,weak)IBOutlet UIImageView * rightImageView;

@property (nonatomic,strong)CenterTopics * newsInfo; //新闻信息

@end
