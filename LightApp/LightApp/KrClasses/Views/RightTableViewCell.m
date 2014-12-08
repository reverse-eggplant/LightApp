//
//  RightTableViewCell.m
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "RightTableViewCell.h"
#import "CenterTopics.h"
#import "CommentInfo.h"

@implementation RightTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.numberLabel.layer.cornerRadius = 10.0;
    self.numberLabel.backgroundColor = [UIColor blueColor];
    self.numberLabel = [SharedSingleton addAlabelForAView:self.contentView withText:nil frame:CGRectMake(10.0, 15.0, 20.0, 20.0) font:CELL_BOLDFONT(10.0) textColor:[UIColor whiteColor]];
    self.numberLabel.backgroundColor = UIColorFromRGB(0X1797c9);
    self.numberLabel.clipsToBounds = YES;
    self.numberLabel.layer.cornerRadius = 10.0;
    [SharedSingleton addLineToView:self.contentView frame:CGRectMake(0.0, 49.5, ScreenWidth, 0.5) color:UIColorFromRGB(0Xe0e0e0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNewsInfo:(RightHotNew *)newsInfo
{
    if (_newsInfo == newsInfo)return;
    _newsInfo = newsInfo;
    
    _numberLabel.text =newsInfo.replies_count?$str(@"%lu",(unsigned long)newsInfo.replies_count):@"0";
    _conttentLabel.text = newsInfo.title;
    _numberLabel.backgroundColor = RGBAColor(34, 136.0, 199.0,newsInfo.numberLabelAlpha);

    [self setNeedsDisplay];
    
}



@end
