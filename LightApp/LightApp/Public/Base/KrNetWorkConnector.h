//
//  KrNetWorkConnector.h
//  LightApp
//
//  Created by malong on 14/11/26.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#define BASEURL @"http://www.36kr.com/"

#define SETTINGSALL     @"api/v1/settings/all.json?token=e1cbdfe589bff295bb29:12375"               //1、设置相关，版本信息

#define APP_SPLASH      @"api/v1/site/app_splash.json"              //2、应用程序配置设备版本,返回启动屏广告信息

#define TOPICS_FEATURE  @"api/v1/topics/feature.json?token=e1cbdfe589bff295bb29:12375"             //3、首页轮播区信息

#define SITES           @"api/v1/sites.json?token=e1cbdfe589bff295bb29:12375"                      //4、应用程序启动屏广告

//#define APP_SPLASH      @"/api/v1/site/app_splash.json?app_screen_w=320&app_screen_h=548&client=ios"

#define REPLIES         @"api/v1/topics/infoid/replies.json?token=e1cbdfe589bff295bb29:12375"//用户评论替换infoid

#define TOPICS          @"api/v1/topics.json"                       //5、首页列表信息

#define NEWINFO         @"/api/v1/topics/infoid.json?token=e1cbdfe589bff295bb29:12375" //6、新闻详情接口，需替换id

#define FAVORITE        @"/api/v1/users/u1378167092/topics/favorite.json?token=e1cbdfe589bff295bb29:12375" //7、我的收藏

#define MYREPLIES       @"/api/v1/users/u1378167092/replies.json?token=e1cbdfe589bff295bb29:12375" //8、我的评论

#define IOS_EVENT_SIDEBAR @"/api/v1/sites/ios_event_sidebar.json"   //9、侧边栏信息

#define TOP_HITS        @"/api/v1/topics/popular/top-hits.json?token=e1cbdfe589bff295bb29:12375"     //10、实时热门

#define IOS_APPS        @"/api/v1/site/ios_apps.json?token=e1cbdfe589bff295bb29:12375"            //13、氪星人的应用

#define US_STARTUPS     @"/api/v1/topics/category/us-startups.json" //15、国外创业公司page/per_page

#define CN_STARTUPS     @"/api/v1/topics/category/cn-startups.json" //16、国内创业公司page/per_page

#define BREAKING        @"/api/v1/topics/category/breaking.json"    //17、国外资讯page/per_page

#define CN_NEWS         @"/api/v1/topics/category/cn-news.json"     //18、国内资讯page/per_page

#define DIGEST          @"/api/v1/topics/category/digest.json"      //19、生活方式page/per_page

#define COLUMN          @"/api/v1/topics/category/column.json"      //20、专栏文章page/per_page

#define SEARCH          @"/api/v1/search.json?token=e1cbdfe589bff295bb29:12375" //21、搜索接口q=36kr&per_page=60

#define LOGIN           @"/account/user_tokens.json?"         //登录接口

