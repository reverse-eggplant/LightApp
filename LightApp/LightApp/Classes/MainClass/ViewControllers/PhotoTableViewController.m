//
//  PhotoTableViewController.m
//  LightApp
//
//  Created by malong on 14/11/5.
//  Copyright (c) 2014年 malong. All rights reserved.
//


#import "PhotoTableViewController.h"


#import "PictureDataTableViewCell.h"


#import "PictureArrayDataSource.h"
#import "Store.h"
#import "Photo.h"



static NSString * const PhotoTableViewControllerCellIdentifier = @"PhotoTableViewControllerCellIdentifier";


@interface PhotoTableViewController ()<UITableViewDelegate>

@property (nonatomic,strong)PictureArrayDataSource * pictureArrayDataSource;


@end

@implementation PhotoTableViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLog(@"2");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"1");
    self.navigationItem.title = @"Pictures";
    [self setupTableView];
    

    
}

- (void)setupTableView{
    TableViewCellConfigureBlock  tableViewCellConfigureBlock = ^(PictureDataTableViewCell * pictureDataTableViewCell,Photo * picture){
        [pictureDataTableViewCell configurePictureData:picture];
    };
    
    NSArray * pictures = [AppDelegate shareDelegate].store.sortedPictures;
    self.pictureArrayDataSource = [[PictureArrayDataSource alloc]initWithItems:pictures
                                                                    identifier:PhotoTableViewControllerCellIdentifier configureCellBlock:tableViewCellConfigureBlock];
    
    self.tableView.dataSource = self.pictureArrayDataSource;
    self.tableView.delegate = self;
    [self.tableView registerNib:[PictureDataTableViewCell nib] forCellReuseIdentifier:PhotoTableViewControllerCellIdentifier];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [SXViewConrollerManager pushToTheViewController:@"PhotoDetailViewController" transferInfo:[self.pictureArrayDataSource itemAtIndexPath:indexPath]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


@end
