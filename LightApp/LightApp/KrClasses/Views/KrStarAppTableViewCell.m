//
//  KrStarAppTableViewCell.m
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "KrStarAppTableViewCell.h"
#import "KrStarAppInfo.h"


@implementation KrStarAppTableViewCell

- (void)awakeFromNib {
    [self.downLoadButton setBackgroundImage:[LOADPNGIMAGE(@"download-btn") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    [self.downLoadButton setBackgroundImage:[LOADPNGIMAGE(@"download-btn-pressed") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
    [self.downLoadButton addTarget:self action:@selector(downLoadApp) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAppInfo:(KrStarAppInfo *)appInfo{
    if (_appInfo == appInfo) {
        return;
    }
    _appInfo = appInfo;
    [_logImageView setImageWithURL:[NSURL URLWithString:appInfo.favicon] placeholderImage:LOADPNGIMAGE(@"images-small-loader")];
    _titleLabel.text = appInfo.name;
    _detailLabel.text = appInfo.desc;
    _timeLabel.text = [TimeManager theInterValTimeFromCreateTime:appInfo.created_at formatString:nil];
    
    [self setNeedsDisplay];
}

- (void)downLoadApp{
    if (_pushVC && self.appInfo.url) {
        
        SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
        storeProductVC.delegate = self;
        
        NSString * appId = [[[self.appInfo.url  $split:@"/id"] objectAtIndex:1] substringToIndex:9];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
        [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                [_pushVC presentViewController:storeProductVC animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
