//
//  CommentTableViewCell.h
//  LightApp
//
//  Created by malong on 14/12/2.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentInfo;

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic,weak)IBOutlet UILabel * userNameLabel;
@property (nonatomic,weak)IBOutlet UILabel * commentLabel;
@property (nonatomic,weak)IBOutlet UIImageView * userAvantar;

@property (nonatomic,strong)CommentInfo * commentInfo;

@end
