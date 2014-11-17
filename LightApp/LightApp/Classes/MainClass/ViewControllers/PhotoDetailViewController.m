//
//  PhotoDetailViewController.m
//  LightApp
//
//  Created by malong on 14/11/5.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Photo.h"
#import "TestSQLModel.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.pushInfo) {
        Photo * pushInfo = (Photo *)self.pushInfo;
        self.navigationItem.title = pushInfo.name;
        
        
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 50, 120, 40);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(100, 150, 120, 40);
    deleteButton.backgroundColor = [UIColor orangeColor];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
    UIButton * changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame = CGRectMake(100, 250, 120, 40);
    changeButton.backgroundColor = [UIColor orangeColor];
    [changeButton setTitle:@"修改" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
    
    UIButton * findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findButton.frame = CGRectMake(100, 350, 120, 40);
    findButton.backgroundColor = [UIColor orangeColor];
    [findButton setTitle:@"查询" forState:UIControlStateNormal];
    [findButton addTarget:self action:@selector(findData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findButton];
    
    // Do any additional setup after loading the view.
}

- (void)addData{
    
    TestSQLModel * testmodel = [[TestSQLModel alloc]init];
    testmodel.date = [NSDate date];
    testmodel.number = [NSNumber numberWithInt:30];
    testmodel.data = [@"data" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"propertyNames = %@",testmodel.propertyNames);
    
    
    NSLog(@"propertiesDic = %@",testmodel.propertiesDic);
    
    
    [DataBaseManager createDataBaseWithDBModel:testmodel];
    
    [DataBaseManager saveDataWithMDBModel:testmodel];
    
}


- (void)deleteData{
    
    
    [DataBaseManager deleteDataModelWithModelName:@"TestSQLModel" keyName:@"number" keyValue:[NSNumber numberWithInt:30]];
    
}

- (void)changeData{
    
    TestSQLModel * testmodel = [[TestSQLModel alloc]init];
    testmodel.date = [NSDate date];
    testmodel.number = [NSNumber numberWithInt:40];
    testmodel.data = [@"data" dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [DataBaseManager mergeWithDBModel:testmodel keyName:@"number" keyValue:[NSNumber numberWithInt:30]];
    
}

- (void)findData{
    
    [DataBaseManager findWithModelName:@"TestSQLModel" keyName:@"number" keyValue:[NSNumber numberWithInt:30] limit:30];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
