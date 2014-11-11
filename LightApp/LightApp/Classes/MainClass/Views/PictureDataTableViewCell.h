//
//  PictureDataTableViewCell.h
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface PictureDataTableViewCell : UITableViewCell

+ (UINib *)nib;

@property (nonatomic, weak)IBOutlet UILabel * titlelabel;

@property (nonatomic, weak)IBOutlet UILabel * createDatelabel;

- (void)configurePictureData:(Photo *)picture;

@end
