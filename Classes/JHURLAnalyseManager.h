//
//  JHURLAnalyseManager.h
//  JHURLAnalyseTool
//
//  Created by Shenjinghao on 2017/2/8.
//  Copyright © 2017年 JHModule. All rights reserved.
//

#import <UIKit/UIKit.h>

//static一般定义在实现文件中。.m中，如果有const修饰符修饰，改变数值编译器会报错。
//extern  const  一个常量，这个常量是指针，指向NSString对象，此类常量必须要定义，并且只能定义一次

extern NSString *const JHUrlAnalyseChangeKey;  //url数据更新标记，发通知使用
extern NSString *const JHUrlProtocolHandledKey;   //标记请求

extern NSString *const JHUrlRequestConnetcionErrorInfo;  //connection出现error
extern NSString *const JHUrlRequestUUID;  //UUID
extern NSString *const JHUrlRequestStatusCode;  //状态码
extern NSString *const JHUrlRequestHttpBody;  //HTTPBody
extern NSString *const JHUrlRequestHttpMethod;  //HTTPMethod
extern NSString *const JHUrlRequestHttpHeaderFields;  //request all header fields
extern NSString *const JHUrlRequestUrl;  //request url string

extern NSString *const JHUrlResponseUrl;  //response url
extern NSString *const JHUrlResponseHttpBody;  //response body
extern NSString *const JHUrlResponseHttpMethod;  //response method
extern NSString *const JHUrlResponseTime;  //time
extern NSString *const JHUrlResponseMIMEType;  //MIMEType 传输的数据类型 text image 等等
extern NSString *const JHUrlResponseHttpHeaderFields;  ////response all header fields


/**
 url列表的管理类
 */

@interface JHURLAnalyseManager : NSObject

@property (nonatomic, strong) NSMutableArray *urlArray;  //url数据源信息

@property (nonatomic) BOOL hasShow;  //确定是否已展示url分析工具页面

/**
 单例

 @return self
 */
+ (instancetype) defaultManager;

/**
 注册工具
 */
- (void) registerUrlAnalyse;

/**
 注销工具
 */
- (void) unregisterUrlAnalyse;

/**
 加入数据源urlArray中

 @param infoDict protocol截获的url信息，包括上面定义的各种常量的数据
 */
- (void) addObjectToUrlArray:(NSDictionary *)infoDict;

/**
 清空数据源
 */
- (void) cleanAllObjects;
@end
