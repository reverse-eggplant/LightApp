//
//  LeftTableViewCell.m
//  LightApp
//
//  Created by malong on 14/11/27.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textLabel.font = CELL_BOLDFONT(15.0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.textLabel.textColor = selected?BLUE:DARK;
    self.selectedImageView.hidden = !selected;
    // Configure the view for the selected state
}

@end
