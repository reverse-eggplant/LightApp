//
//  PictureDataTableViewCell.m
//  LightApp
//
//  Created by malong on 14/11/4.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "PictureDataTableViewCell.h"
#import "Photo.h"

@implementation PictureDataTableViewCell

+ (UINib *)nib{
    return [UINib nibWithNibName:@"PictureDataTableViewCell" bundle:nil];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)configurePictureData:(Photo *)picture{
    self.titlelabel.text = picture.name;
    self.createDatelabel.text = [[self dateFormatter] stringFromDate:picture.creationDate];
    [self setNeedsDisplay];
    
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.titlelabel.shadowColor = [UIColor darkGrayColor];
        self.titlelabel.shadowOffset = CGSizeMake(3, 3);
    } else {
        self.titlelabel.shadowColor = nil;
    }
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return dateFormatter;
}

@end
