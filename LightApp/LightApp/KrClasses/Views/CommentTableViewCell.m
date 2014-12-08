//
//  CommentTableViewCell.m
//  LightApp
//
//  Created by malong on 14/12/2.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentInfo.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentInfo:(CommentInfo *)commentInfo{
    if (_commentInfo == commentInfo) {
        return;
    }
    _commentInfo = commentInfo;
    _userNameLabel.text = $safe([commentInfo.user valueForKey:@"name"]);
    [_userAvantar setImageWithURL:[NSURL URLWithString:[[commentInfo valueForKey:@"user"] valueForKey:@"avatar_url"]]];
    _commentLabel.text = commentInfo.body;
    
    [self setNeedsDisplay];
    
}

@end
