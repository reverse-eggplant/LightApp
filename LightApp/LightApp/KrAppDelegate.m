//
//  KrAppDelegate.m
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "KrAppDelegate.h"
#import "LOLeftViewController.h"
#import "LOCenterViewController.h"
#import "LORightViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "StartScreenView.h"
#import "TestSQLModel.h"

#import "UMSocial.h"
#import "UMFeedback.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
@import QuartzCore;

@implementation KrAppDelegate

+ (instancetype)shareDelegate{
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [UMSocialData setAppKey:UM_APPKEY];
    [UMFeedback checkWithAppkey:UM_APPKEY];
    [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_WECHATSECRET url:nil];


    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:[[LOCenterViewController alloc] initWithStyle:UITableViewStylePlain]]
                                             leftDrawerViewController:[[LOLeftViewController alloc] initWithStyle:UITableViewStylePlain]
                                             rightDrawerViewController:[[LORightViewController alloc] initWithStyle:UITableViewStylePlain]];
    
    [drawerController setMaximumRightDrawerWidth:ScreenWidth-70];
    [drawerController setMaximumLeftDrawerWidth:ScreenWidth-70];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
    {
         
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = drawerController;
    [self setNavigationBar];
    
    [AFNHttpRequestOPManager getInfoWithSubUrl:APP_SPLASH parameters:@{@"app_screen_w":$str(@"%d",(int)ScreenWidth),@"app_screen_h":$str(@"%d",(int)ScreenHeight),@"client":@"ios"} block:^(id result, NSError *error) {
        if (result) {
            MAINBLOCK(^{
                StartScreenView * starScreenView = [[StartScreenView alloc] initWithScreenNews:[result objectAtIndex:0]];
                [self.window addSubview:starScreenView];
            });
        }
    }];
    
    [self.window makeKeyAndVisible];
    return YES;
}

//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
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
    
    //加载启动广告
    [AFNHttpRequestOPManager getInfoWithSubUrl:SITES parameters:nil block:^(id  result , NSError *error) {
        if ([result isKindOfClass:[NSArray class]] && [result count] == 2)
        {
            [USER_DEFAULT setValue:[[[result objectAtIndex:1] valueForKey:@"sites"] objectAtIndex:0] forKey:@"sites"];
            [USER_DEFAULT synchronize];
            
        }
    }];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark   设置导航栏
- (void)setNavigationBar{
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x0083d5)]; //ios7以后，使用这个方法设置导航栏的颜色
    //真机调试时，ios7.1里面不能通过如下方法translucent设置为NO
    //    [UINavigationBar appearance].translucent = NO;    //关闭模糊效果
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];   //给返回按钮着色
    //设置文字阴影
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0], NSFontAttributeName, nil]];
    
    
}




@end
