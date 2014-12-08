//
//  KrStarAppTableViewCell.h
//  LightApp
//
//  Created by malong on 14/12/1.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@class KrStarAppInfo;

@interface KrStarAppTableViewCell : UITableViewCell<SKStoreProductViewControllerDelegate>

@property (nonatomic,weak)IBOutlet UIImageView * logImageView;
@property (nonatomic,weak)IBOutlet UILabel * titleLabel;
@property (nonatomic,weak)IBOutlet UILabel * detailLabel;
@property (nonatomic,weak)IBOutlet UILabel * timeLabel;
@property (nonatomic,weak)IBOutlet UIButton * downLoadButton;
@property (nonatomic,strong)KrStarAppInfo * appInfo;

@property (nonatomic,weak)UIViewController * pushVC;

@end
