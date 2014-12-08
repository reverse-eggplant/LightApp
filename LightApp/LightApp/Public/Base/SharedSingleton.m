//
//  SharedSingleton.m
//  LifeApp
//
//  Created by uway_soft on 13-6-17.
//  Copyright (c) 2013年 uway_soft. All rights reserved.
//

#import "SharedSingleton.h"
#import <MessageUI/MessageUI.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>

static SharedSingleton *_sharedObj = nil;


@implementation SharedSingleton

//基本方法实现
+(SharedSingleton *)sharedInstance
{
    @synchronized (self) {
        if (nil == _sharedObj) {
            _sharedObj = [[self alloc]init];
        }

    }
    return _sharedObj;
}

//重写allocWithZone方法
+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (_sharedObj == nil) {
            _sharedObj = [super allocWithZone:zone];
            return _sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone 
{
    return self;
}
- (id)init
{
    @synchronized(self) {
        self = [super init];//往往放一些要初始化的变量.
        return self;
    }
}


//字典编辑
+(id)getAUsefulInstanceWith:(NSDictionary *)attributes key:(NSString *)key{
    
    if ([[attributes objectForKey:key]
         isKindOfClass:[NSNumber class]] ||
        [[attributes objectForKey:key] isKindOfClass:[NSString class]] ||
        [[attributes objectForKey:key] isKindOfClass:[NSObject class]] || ![[attributes objectForKey:key] isKindOfClass:[NSNull class]])
    {
        return [NSMutableString stringWithFormat:@"%@", [attributes objectForKey:key]];
    }
    else
    {
        return @"";
        NSLog(@"字段值Id读取异常(字段不存在或者值为空)");
    }
}


- (void)canViewController1:(UINavigationController *)vc1
         goViewController2:(UIViewController *)vc2
{
    viewContoller1 = vc1;

//    if ([[NSUserDefaults standardUserDefaults]valueForKey:BCE_UUID]) {
//        [vc1 pushViewController:vc2 animated:YES];
//        viewContoller1 = nil;
//    }else{
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
//                                                        message:@"您尚未登录，是否前往登录呢？"
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"登录", nil];
//        [alert show];
//        alert.tag = 100;
//    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 100:
            if (buttonIndex) {

                
            }
            break;
            
        default:
            break;
    }
    
}

+ (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}


+ (NSString *)theInterValTimeFromCreateTime:(NSString *)createTime
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //两个日期对象
    NSDate *currentTime=[dateFormatter dateFromString:
                         [dateFormatter stringFromDate:[[NSDate alloc] init]]];
    DLog(@"currentTime = %@",currentTime);
    
    NSDate *cTime=[dateFormatter dateFromString:createTime];
    DLog(@"cTime = %@",cTime);
    NSTimeInterval time=[currentTime timeIntervalSinceDate:cTime];

    //间隔日期
    NSInteger days = time/(3600*24);
    NSInteger hours =  time/(3600);
    NSInteger minites =  time/60;
    DLog(@"components = %f",time);
    if (days >= 7) {
        NSString * tempStr = [dateFormatter stringFromDate:cTime];
        return [tempStr substringToIndex:10];
    }else if (days){
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }else if (hours){
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }else if(minites){
        return [NSString stringWithFormat:@"%ld分钟前",(long)minites];
    }
    return @"刚发布";
}

+ (BOOL)isTimeOlderThanCurrentTime:(NSString *)timeString
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate=[df dateFromString:timeString];
    NSLog(@"inputDate =%@",inputDate);
    
    NSDate * currentDate = [NSDate date];
    NSString * currentFateString = [df stringFromDate:currentDate];
    NSDate *standardCurrentDate=[df dateFromString:currentFateString];
    NSLog(@"standardCurrentDate =%@",standardCurrentDate);
    
    switch ([inputDate compare:currentDate]) {
        case NSOrderedSame:
            DLog(@"相等");
            return NO;
            break;
        case NSOrderedAscending:
            DLog(@"date1比date2小");
            return YES;
            break;
        case NSOrderedDescending:
            DLog(@"date1比date2大");
            return NO;
            break;
        default:
            return NO;
            break;
    }
    return YES;
    
}

+ (BOOL) isTime1:(NSString *)time1String  orderThanTime2:(NSString *)time2String
{
    
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1=[df dateFromString:time1String];
    NSLog(@"date1 =%@",date1);
    if (time1String && date1 == nil) {
        return NO;
    }
    
    NSDate *date2=[df dateFromString:time2String];
    NSLog(@"date2 =%@",date2);

    if (time2String && date2 == nil) {
        return NO;
    }
    
    switch ([date1 compare:date2]) {
        case NSOrderedSame:
            DLog(@"相等");
            return NO;
            break;
        case NSOrderedAscending:
            DLog(@"date1比date2小");
            return YES;
            break;
        case NSOrderedDescending:
            DLog(@"date1比date2大");
            return NO;
            break;
        default:
            return NO;
            break;
    }
    return YES;
    
}


+ (NSString *)lastTime:(NSDate *)lockDate
{
    NSDate *currentDate = [[NSDate alloc] init];
    //获得两个日期之间的间隔
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian
                                    components:unitFlags
                                    fromDate:currentDate
                                    toDate:lockDate
                                    options:0];
    
    NSInteger minites = [components minute];
    NSInteger seconds = [components second];
  
    //编辑锁定栏且启动计时
    if (minites>0 || seconds >= 0) {
        
    if (seconds >= 10)return [NSString stringWithFormat:
                              @"0%ld:%ld",(long)minites,(long)seconds];
        
    else return [NSString stringWithFormat:
                 @"0%ld:0%ld",(long)minites,(long)seconds];
    }
    return nil;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma mark 计算方法

+ (CGSize) sizeOfCurrentString:(NSString *)aString
                          font:(float)fontSize
                   contentSize:(CGSize)size
                      WithName:(NSString*)fontname
{

    if (aString == nil || aString.length == 0) {
        return CGSizeZero;
    }
    
    NSRange range = NSMakeRange(0, aString.length);
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:aString];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:fontname size:fontSize] range:range];
    CGSize stringSize = [aString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[attri attributesAtIndex:0 effectiveRange:&range] context:nil].size;
    
//    return stringSize.height;
    return stringSize;
}

//字符串尺寸
+ (CGSize) sizeOfCurrentString:(NSString *)aString
                          font:(float)fontSize
                   contentSize:(CGSize)size
{
    if (aString == nil || aString.length == 0) {
        return CGSizeZero;
    }
    
    NSRange range = NSMakeRange(0, aString.length);
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:aString];
     [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    CGSize stringSize = [aString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[attri attributesAtIndex:0 effectiveRange:&range] context:nil].size;
//    return stringSize.height;
    return stringSize;
    
}

CGSize textFitToSize(NSString * text){
    CGSize size;
    return size;
}



+ (float) heightOfCurrentString:(NSString *)aString
                           font:(float)fontSize
                    contentSize:(CGSize)size
{
    
//    CGSize stringSize = [aString sizeWithFont:[UIFont systemFontOfSize:fontSize]
//                            constrainedToSize:size
//                                lineBreakMode:NSLineBreakByWordWrapping];
    if (aString == nil|| aString.length == 0) {
        return CGSizeZero.height;
    }
    
    NSRange range = NSMakeRange(0, aString.length);
    NSAttributedString * attri = [[NSAttributedString alloc] initWithString:aString];
    CGSize stringSize = [aString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[attri attributesAtIndex:0 effectiveRange:&range] context:nil].size;
    return stringSize.height;
}

+ (NSString *)getANormalString:(NSString *)originString
{
    NSString *flowdesc = originString;
    flowdesc = [flowdesc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    flowdesc = [flowdesc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    flowdesc = [flowdesc stringByReplacingOccurrencesOfString:@"<!--br-->" withString:@"\n"];
    flowdesc = [flowdesc stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];

    return flowdesc;
}

+(BOOL)CallPhoneWithNumber:(NSString *)number{

    return [[UIApplication sharedApplication]
            openURL:[NSURL URLWithString:
                     [NSString stringWithFormat:@"tel://%@",number]]];
    
}


+(BOOL)SendMessageWithRecip:(NSArray *)recip WithDelegate:(id)delegate{

    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.messageComposeDelegate = delegate;
        controller.recipients = recip;
        [delegate presentViewController:controller animated:YES completion:nil];
        
        return YES;
    }
    return NO;
    
}

+(BOOL)SendEmailWithRecipients:(NSArray*)recipients Delegate:(id)delegate{

    
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        mailController.mailComposeDelegate = delegate;
        [mailController setToRecipients:recipients];
        [delegate presentViewController:mailController animated:YES completion:nil];
        
        return YES;
    }
    
    return NO;
}

+(bool)checkDevice:(NSString*)name
{
    NSString* deviceType = [UIDevice currentDevice].model;
    DLog(@"deviceType = %@", deviceType);
    
    NSRange range = [deviceType rangeOfString:name];
    return range.location != NSNotFound;
}


+(NSString*)ReplacingString:(NSString*)astring{
    
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    return astring;
    
}

+(void) clearCookieAndCache{
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    
    //清除web缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
}

+(void) addSearchHistory:(NSString *)searchText
{
    if (searchText == nil || searchText.length == 0) {
        return;
    }
    NSString*datakey=[NSString stringWithFormat:@"%@data",
                      [[NSUserDefaults standardUserDefaults]objectForKey:@"empId"]];
    
    NSMutableArray *searchHistory = [[NSMutableArray alloc]initWithCapacity:2];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:datakey]) {
        [searchHistory addObjectsFromArray:[[NSUserDefaults standardUserDefaults]
                                            objectForKey:datakey]];
    }
    

    if ([searchHistory containsObject:searchText])[searchHistory removeObject:searchText];

    [searchHistory insertObject:searchText atIndex:0];
    [[NSUserDefaults standardUserDefaults]setObject:searchHistory forKey:datakey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString *)currentVersion{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    
}

+ (NSString *)currentSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark -

//+ (BOOL)validateMobile:(NSString *)mobile {
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}


+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
//    NSString *regex = @"^((13[0-9])|(147)|(170)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSString * regex = @"^1(3[0-9]|4[57]|5[0-35-9]|7[06-8]|8[0-9])\\d{8}$";
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch) {
        return NO;
        
    }
    
    return YES;
    
}

+ (BOOL)isNumber:(NSString *)numberString
{
    NSString *regex = @"[0-9]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:numberString];
    
}

+(BOOL)isHanziWithString:(NSString *)aString{
    if (aString == nil || [aString isEqualToString:@""] ||
        [[aString stringByReplacingOccurrencesOfString:@" " withString:@""]
         isEqualToString:@""]) {
        return NO;
    }
    
    NSString * Hanzi = @"^[\u4E00-\u9FA5]{2,20}$";
    NSPredicate *regextesthanzi = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Hanzi];
    return [regextesthanzi evaluateWithObject:aString];
}

//是否为英文字幕
+(BOOL)IsEGString:(NSString *)aString
{
    DLog(@"email = %@",aString);
    NSString *emailRegex = @"[A-Za-z]";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:aString];
    
}

+(BOOL)isValidateName:(NSString *)name
{
    if (name == nil || [name isEqualToString:@""] ||
        [[name stringByReplacingOccurrencesOfString:@" " withString:@""]
         isEqualToString:@""]) {
        return NO;
    }
    NSString *nameRegex = @"(^[A-Za-z\u4E00-\u9FA5]{2,20}$)";
    NSPredicate *regextestName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [regextestName evaluateWithObject:name];
}

+(BOOL)isValidateContent:(NSString *)content
{
    if (content == nil || [content isEqualToString:@""] ||
        [[content stringByReplacingOccurrencesOfString:@" " withString:@""]
         isEqualToString:@""]) {
        return NO;
    }
    return content.length;
    
    NSString *contentRegex = @"([0-9._%+－,。｜、／｀～！？（）《》<>@*()!?#$￥\u4E00-\u9FA5]{2,2000})";
    
    NSPredicate *contentTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", contentRegex];
    
    return [contentTest evaluateWithObject:content];
    
}

+(BOOL)isValidateEmail:(NSString *)email
{
    if (nil == email) {
        return NO;
    }
    DLog(@"email = %@",email);
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

+(BOOL)isValidatePassWord:(NSString *)passWord
{
    if (![self isValidateMsg:passWord]) {
        return NO;
    }
    return YES;

//    NSString *passWordRegex = @"(^[A-Za-z0-9!@#$%&*()_]{3,24}$)";
//
//    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
//
//    return [passWordTest evaluateWithObject:passWord];
}

+(BOOL)isValidateUserName:(NSString *)userName
{
    if (![self isValidateMsg:userName]) {
        return NO;
    }
    
    NSString *userNameRegex = @"(^[A-Za-z0-9\u4E00-\u9FA5]{2,20}$)";
    
    NSPredicate *serNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    
    return [serNameTest evaluateWithObject:userName];
}

+(BOOL)isValidateMsg:(NSString *)data
{
    if (nil == data || [data isEqualToString:@""] ||
        [[data stringByReplacingOccurrencesOfString:@" " withString:@""]
         isEqualToString:@""] ) {
        return NO;
    }
    return YES;
}

+ (BOOL)isSearchTextTooShort:(NSString *)searchText
{
    if (nil == searchText) {
        return NO;
    }
    DLog(@"email = %@",searchText);
    NSString *searchTextRegex = @"[A-Za-z0-9]{1}";
    NSPredicate *searchTextTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", searchTextRegex];
    if ([searchTextTest evaluateWithObject:searchText]) {
    }
    return [searchTextTest evaluateWithObject:searchText];
    
}


+ (UILabel *)addAlabelForAView:(UIView *)aView
                      withText:(NSString *)labelText
                         frame:(CGRect)labelFrame
                          font:(UIFont *)labelFont
                     textColor:(UIColor *)labelColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = labelText;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.backgroundColor = [UIColor clearColor];
    label.font = labelFont;
    if (labelColor) {
        label.textColor = labelColor;

    }
    if (aView) {
        [aView addSubview:label];
    }
    return label;
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length = 0;
    if (!value) {
        return NO;
    }else {
        length = (unsigned)value.length;
        
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        default:
            return false;
    }
}

+ (UIButton *)getAButtonWithFrame:(CGRect)frame nomalTitle:(NSString *)title1 hlTitle:(NSString *)title2 titleColor:(UIColor *)tColor bgColor:(UIColor *)BgColor nbgImage:(NSString *)image1 hbgImage:(NSString *)image2 action:(SEL)selector target:(id)delegate buttonTpye:(UIButtonType)theButtonTpye
{
    UIButton *button = nil;
    if (theButtonTpye) {
        button = [UIButton buttonWithType:theButtonTpye];

    }else{
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }

    button.frame = frame;
    if (title1) {[button setTitle:title1 forState:UIControlStateNormal];}
    if (title2) {[button setTitle:title1 forState:UIControlStateHighlighted];}
    if (tColor) {
        [button setTitleColor:tColor forState:UIControlStateNormal];
    }
    
    if (BgColor) {
        [button setBackgroundColor:BgColor];
    }
    
    if (image1) {[button setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];}
    if (image2) {[button setImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];}
    if (delegate && selector) {
        [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    }

    return button;
    
}

+ (UITextField *)getATFWithFrame:(CGRect)frame delegate:(id)delegate palceHolder:(NSString *)placeHolder image:(NSString *)imageName
{
    UITextField * textfeild = [[UITextField alloc]initWithFrame:frame];
    textfeild.delegate = delegate;
    [textfeild setBorderStyle:UITextBorderStyleNone];

    textfeild.autocorrectionType = UITextAutocorrectionTypeNo;
    textfeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfeild.returnKeyType = UIReturnKeyDone;
//    textfeild.textAlignment = NSTextAlignmentCenter;
    textfeild.placeholder =placeHolder;
    textfeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (imageName) {
        textfeild.leftViewMode = UITextFieldViewModeAlways;
        textfeild.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        
    }
    return textfeild;
}


+ (UIView *)addLineToCell:(UITableViewCell *)cell frame:(CGRect)frame
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = UIColorFromRGB(0Xd0d0d0);
    [cell.contentView addSubview:line];
    return line;
}

+(NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Text2:(NSString *)text2 Color2:(UIColor *)color2 AllText:(NSString *)allText
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text1) {
        NSRange range1 = [allText rangeOfString:text1];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color1 range:range1];
        
    }
    
    if (text2) {
        NSRange range2 = [allText rangeOfString:text2];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color2 range:range2];
    }
    
    
    [str endEditing];
    
    return str;
}

+(NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Font1:(UIFont *)font1 Text2:(NSString *)text2 Color2:(UIColor *)color2 Font2:(UIFont *)font2 AllText:(NSString *)allText
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text1) {
        NSRange range1 = [allText rangeOfString:text1];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color1 range:range1];
        if (font1) {
            //            CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)font1.fontName,font1.pointSize,NULL);
            //        [str addAttribute:(id)kCTFontAttributeName value:(id)helveticaBold range:range1];
            [str addAttribute:NSFontAttributeName value:font1 range:range1];
            
        }
    }
    
    if (text2) {
        NSRange range2 = [allText rangeOfString:text2];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color2 range:range2];
        if (font2) {
            [str addAttribute:NSFontAttributeName value:font2 range:range2];
            
        }
    }
    
    [str endEditing];
    
    return str;
}

+ (NSArray *)bankArrayList
{
    NSArray *bankList = [[NSArray alloc]initWithObjects:@"工商银行",@"农业银行",@"中国银行",@"建设银行",@"交通银行",@"华夏银行",@"光大银行",@"招商银行",@"中信银行",@"兴业银行",@"民生银行",@"深圳发展银行",@"广东发展银行",@"上海浦东发展银行",@"渤海银行",@"恒丰银行",@"浙商银行",@"北京银行",@"宁波银行",@"徽商银行",@"济南商业银行",@"石家庄商业银行",@"中国邮政储蓄银行", nil];
    return bankList;
}

+(NSArray *)bankCardType
{
    NSArray *cardType = [[NSArray alloc]initWithObjects:@"储蓄卡",@"信用卡",@"存折", nil];
    return cardType;
}

+(void)resignFirstRespoder{

    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *view = [keyWindow performSelector:@selector(firstResponder)];
    MAINBLOCK(^{
        [view resignFirstResponder];

    });
}

- (void)firstResponder{
    
}

+ (UIView *)addLineToView:(UIView *)view frame:(CGRect)frame color:(UIColor *)lineColor
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    if (lineColor) {
        line.backgroundColor = lineColor;

    }else{
        line.backgroundColor =  UIColorFromRGB(0Xffffff);

    }
    [view addSubview:line];
    return line;
}

+(NSString *) macAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return nil;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return nil;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return nil;
        
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (BOOL)checkCanTakePhoto
{
    if (IOS7) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus ==AVAuthorizationStatusRestricted){
            DLog(@"Restricted");
        }else if(authStatus == AVAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的<设置-隐私-相机>中允许此程序访问相机。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
            
        }else if(authStatus == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){
                    DLog(@"Granted access to %@", mediaType);
                    
                }
                else {
                    DLog(@"Not granted access to %@", mediaType);
                }
            }];
        }else {
            DLog(@"Unknown authorization status");
        }
    }
    return YES;
}

#pragma mark 从一段视频中截取一张图片
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    //获取视频中得某帧图片,并压缩
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

#pragma mark 视频压缩
+ (NSURL *) lowQuailtyWithInputURL:(NSURL*)inputURL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:inputURL options:nil];
    
    NSString *appDocumentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSURL *uploadURL = [NSURL fileURLWithPath:[[appDocumentPath stringByAppendingPathComponent:[dateFormatter stringFromDate:[NSDate date]]] stringByAppendingString:@".mp4"]];
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = uploadURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (session.status) {
             case AVAssetExportSessionStatusUnknown:
                 DLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 DLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 DLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 DLog(@"AVAssetExportSessionStatusCompleted.lenght = %lu",(unsigned long)[[NSData dataWithContentsOfURL:uploadURL]length]);
                 
                 break;
             case AVAssetExportSessionStatusFailed:
                 DLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
    DLog(@"uploadURL = %@",uploadURL);
    return uploadURL;
    
}


#pragma mark 字母数
+ (int)countWord:(NSString*)s
{
    int i,n=(unsigned)[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}


#pragma mark 时间戳

+ (NSTimeInterval)getTimeIntervalFromDateString:(NSString *)dateString{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    if ([[dateString substringWithRange:NSMakeRange(4, 1)]isEqualToString:@"-"]) {
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    }else{
        [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];

    }
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* datenow = [NSDate dateWithTimeIntervalSinceNow:0];
    long dd = (long)([datenow timeIntervalSince1970]-[[dateFormatter dateFromString:dateString] timeIntervalSince1970]);
//    DLog(@"dd = %ld",dd);
    
    return dd;
    
}

+ (NSString *) getTimeDiffString:(NSTimeInterval) timestamp
{
    NSString * timeString;
    
    if ((timestamp/3600)<1)
    {
        timeString = [NSString stringWithFormat:@"%.f", timestamp/60];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if ((timestamp/3600)>1 && (timestamp/86400)<1)
    {
        timeString = [NSString stringWithFormat:@"%.f", timestamp/3600];
        
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if ((timestamp/86400)>1)
    {
        timeString = [NSString stringWithFormat:@"%.f", timestamp/86400];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    return timeString;
    
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDate *todate = [NSDate dateWithTimeIntervalSince1970:timestamp];
//    NSDate *today = [NSDate date];//当前时间
//    unsigned int unitFlag = NSDayCalendarUnit | NSHourCalendarUnit |NSMinuteCalendarUnit;
//    NSDateComponents *gap = [cal components:unitFlag fromDate:today toDate:todate options:0];//计算时间差
//    
//    if (ABS([gap day]) > 0)
//    {
//        return [NSString stringWithFormat:@"%d天前", ABS([gap day])];
//    }else if(ABS([gap hour]) > 0)
//    {
//        return [NSString stringWithFormat:@"%d小时前", ABS([gap hour])];
//    }else
//    {
//        return [NSString stringWithFormat:@"%d分钟前",  ABS([gap minute])];
//    }
}

+ (NSString *)getLocalLanguage
{
    NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    return language;
}

#pragma mark 屏幕截图并保存到相册
+ (UIImage*)saveImageFromView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)savePhotosAlbum:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
}

+ (void)saveImageFromToPhotosAlbum:(UIView*)view
{
    UIImage *image = [self saveImageFromView:view];
    [self savePhotosAlbum:image];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    NSString *message;
    NSString *title;
    if (!error) {
        title = @"成功提示";
        message = @"成功保存到相";
    } else {
        title = @"失败提示";
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark 获取本月，本周，本季度第一天的时间戳
+ (unsigned long long)getFirstDayOfWeek:(unsigned long long)timestamp
{
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit| NSMonthCalendarUnit| NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit
                               fromDate:now];
    if (comps.weekday <2)
    {
        comps.week = comps.week-1;
    }
    comps.weekday = 2;
    NSDate *firstDay = [cal dateFromComponents:comps];
    return [firstDay timeIntervalSince1970];
}

+ (unsigned long long)getFirstDayOfQuarter:(unsigned long long)timestamp
{
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                               fromDate:now];
    if (comps.month <=3)
    {
        comps.month =  1;
    }
    else if(comps.month<=6)
    {
        comps.month =  4;
    }
    else if(comps.month<=9)
    {
        comps.month =  7;
    }
    else if(comps.month<=12)
    {
        comps.month =  10;
    }
    
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    return [firstDay timeIntervalSince1970]*1000;
}

+ (unsigned long long)getFirstDayOfMonth:(unsigned long long)timestamp
{
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                               fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    return [firstDay timeIntervalSince1970]*1000;
}


#pragma mark 判断是否越狱

static const char * __jb_app = NULL;

+ (BOOL)isJailBroken
{
	static const char * __jb_apps[] =
	{
		"/Application/Cydia.app",
		"/Application/limera1n.app",
		"/Application/greenpois0n.app",
		"/Application/blackra1n.app",
		"/Application/blacksn0w.app",
		"/Application/redsn0w.app",
		NULL
	};
    
	__jb_app = NULL;
    
	// method 1
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
			__jb_app = __jb_apps[i];
			return YES;
        }
    }
	
    // method 2
	if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
	{
		return YES;
	}
	
	// method 3
	if ( 0 == system("ls") )
	{
		return YES;
	}
	
    return NO;
}

+ (NSString *)jailBreaker
{
	if ( __jb_app )
	{
		return [NSString stringWithUTF8String:__jb_app];
	}
	else
	{
		return @"";
	}
}

@end
