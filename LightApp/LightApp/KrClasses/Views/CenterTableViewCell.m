//
//  CenterTableViewCell.m
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "CenterTableViewCell.h"
#import "CenterTopics.h"

@implementation CenterTableViewCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"CenterTableViewCell" bundle:nil];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setNewsInfo:(CenterTopics *)newsInfo{
    if (_newsInfo == newsInfo) {
        return;
    }
    _newsInfo = newsInfo;
    _titleLabel.text = newsInfo.title;
    _dateLabel.text = [TimeManager theInterValTimeFromCreateTime:newsInfo.created_at formatString:nil];
    _detailLabel.text = newsInfo.excerpt;
    _commentsLabel.text = newsInfo.replies_count?$str(@"%lu条评论",(unsigned long)newsInfo.replies_count):@"暂无评论";
    [_rightImageView setImageWithURL:[NSURL URLWithString:newsInfo.feature_img] placeholderImage:LOADPNGIMAGE(@"images-small-loader")];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
