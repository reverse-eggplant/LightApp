//
//  AppDelegate.m
//  LightApp
//
//  Created by malong on 14/10/31.
//  Copyright (c) 2014年 malong. All rights reserved.
//

/*
 *
 *
 */


#import "AppDelegate.h"
#import "PhotoTableViewController.h"

#import "Store.h"

#import "TestSQLModel.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIWindow * statusWindow;
@property (nonatomic, strong) UILabel * statusLabel;

- (void) dismissStatus;

@end

@implementation AppDelegate

+ (instancetype)shareDelegate{
    return [UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    PhotoTableViewController *photosViewController = [[PhotoTableViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photosViewController];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:navigationController];
    
    [USER_DEFAULT setValue:@"text" forKey:@"TEST"];
    
    DLog(@"userdefault = %@",[NSUserDefaultManager dictionaryRepresentation]);
    
    [self setNavigationBar];
    [self setStatusWindowAndStatusLabel];

    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark store
@synthesize store = _store;

//get方法获取store
- (Store *)store{
    
    if (_store == nil) {
        _store = [Store getAStore];
    }
    return _store;
}


#pragma mark   设置导航栏
- (void)setNavigationBar{

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x0083d5)]; //ios7以后，使用这个方法设置导航栏的颜色
    
//真机调试时，ios7.1里面不能通过如下方法translucent设置为NO
//    [UINavigationBar appearance].translucent = NO;    //关闭模糊效果
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];   //给返回按钮着色
    
/*
    使用导航栏的titleTextAttributes属性来定制导航栏的文字风格。在text attributes字典中使用如下一些key，可以指定字体、文字颜色、文字阴影色以及文字阴影偏移量：
    UITextAttributeFont – 字体key
    UITextAttributeTextColor – 文字颜色key
    UITextAttributeTextShadowColor – 文字阴影色key
   UITextAttributeTextShadowOffset – 文字阴影偏移量key
 */
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];


}



/**
 * @brief 设置自定义状态栏
 */
- (void)setStatusWindowAndStatusLabel
{
    
    self.statusWindow = [[UIWindow alloc] initWithFrame:CGRectZero];
    self.statusWindow.backgroundColor = [UIColor clearColor];
    self.statusWindow.windowLevel = UIWindowLevelStatusBar + 1;
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.backgroundColor = [UIColor blackColor];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.statusWindow addSubview:self.statusLabel];
    [self.statusWindow makeKeyAndVisible];
    
}

/**
 * @brief 在状态栏显示 一些Log
 *
 * @param string 需要显示的内容
 * @param duration  需要显示多长时间
 */
+ (void) showStatusWithText:(NSString *) string duration:(NSTimeInterval) duration {
    
    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    delegate.statusLabel.text = string;
    [delegate.statusLabel sizeToFit];
    CGRect rect = [UIApplication sharedApplication].statusBarFrame;
    CGFloat width = delegate.statusLabel.frame.size.width;
    CGFloat height = rect.size.height;
    rect.origin.x = rect.size.width - width - 5;
    rect.size.width = width;
    delegate.statusWindow.frame = rect;
    delegate.statusLabel.frame = CGRectMake(0, 0, width, height);
    
    if (duration < 1.0) {
        duration = 1.0;
    }
    if (duration > 4.0) {
        
        duration = 4.0;
    }
    
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
    //                                 (int64_t)(((duration<1.0)?1.0:
    //                                           (duration>4.0?4.0:duration)))*NSEC_PER_SEC),
    //                   dispatch_get_main_queue(), ^{
    //      [self dismissStatus];
    //
    //    });
    
    [delegate performSelector:@selector(dismissStatus) withObject:nil afterDelay:duration];
}

/**
 * @brief 干掉状态栏文字
 */
- (void) dismissStatus {
    CGRect rect = self.statusWindow.frame;
    rect.origin.y -= rect.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.statusWindow.frame = rect;
    }];
}

@end
