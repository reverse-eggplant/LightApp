//
//  CommentViewController.h
//  LightApp
//
//  Created by malong on 14/12/2.
//  Copyright (c) 2014年 malong. All rights reserved.
//

/*
 *brief 新闻评论详情页视图控制器
 */

#import "BaseTableViewController.h"

@interface LOCommentViewController : BaseTableViewController

/**
*pram commentInfos  评论列表信息数组，不为空时，直接加载，而不需根据infoId从新请求获取
*/
@property (nonatomic,strong)NSMutableArray * commentInfos;


/**
*pram infoId  对应新闻id，不为空时，根据infoId请求获取评论列表信息
*/
@property (nonatomic,copy)NSString * infoId;

@end
