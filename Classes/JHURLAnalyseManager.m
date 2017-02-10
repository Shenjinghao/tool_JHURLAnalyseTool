//
//  JHURLAnalyseManager.m
//  JHURLAnalyseTool
//
//  Created by Shenjinghao on 2017/2/8.
//  Copyright © 2017年 JHModule. All rights reserved.
//

#import "JHURLAnalyseManager.h"
#import <CoreMotion/CoreMotion.h>
#import "JHURLAnalyseListViewController.h"

NSString *const JHUrlAnalyseChangeKey = @"JHUrlAnalyseChangeKey";
NSString *const JHUrlProtocolHandledKey = @"JHUrlProtocolHandledKey";

NSString *const JHUrlRequestConnetcionErrorInfo = @"JHUrlRequestConnetcionErrorInfo";
NSString *const JHUrlRequestUUID = @"JHUrlRequestUUID";
NSString *const JHUrlRequestStatusCode = @"JHUrlRequestStatusCode";
NSString *const JHUrlRequestHttpBody = @"JHUrlRequestHttpBody";
NSString *const JHUrlRequestHttpMethod = @"JHUrlRequestHttpMethod";
NSString *const JHUrlRequestHttpHeaderFields = @"JHUrlRequestHttpHeaderFields";
NSString *const JHUrlRequestUrl = @"JHUrlRequestUrl";

NSString *const JHUrlResponseUrl = @"JHUrlResponseUrl";
NSString *const JHUrlResponseHttpBody = @"JHUrlResponseHttpBody";
NSString *const JHUrlResponseHttpMethod = @"JHUrlResponseHttpMethod";
NSString *const JHUrlResponseTime = @"JHUrlResponseTime";
NSString *const JHUrlResponseMIMEType = @"JHUrlResponseMIMEType";
NSString *const JHUrlResponseHttpHeaderFields = @"JHUrlResponseHttpHeaderFields";

@interface JHURLAnalyseManager ()

//http://justsee.iteye.com/blog/1933099参考
@property (nonatomic, strong) CMMotionManager *cmManager;   //引入陀螺仪管理工具


@end

@implementation JHURLAnalyseManager

+ (instancetype)defaultManager
{
    static JHURLAnalyseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JHURLAnalyseManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _urlArray = [NSMutableArray array];
        _hasShow = NO;
    }
    return self;
}

- (void)registerUrlAnalyse
{
    if (_cmManager) {
        return;
    }
    _cmManager = [[CMMotionManager alloc] init];
    
    if (_cmManager.accelerometerAvailable) {
        NSLog(@"CMMotionManager 传感器可用");
    }else{
        NSLog(@"CMMotionManager 传感器不可用");
    }
    
    _cmManager.accelerometerUpdateInterval = 0.1;   //更新数据的时间间隔
    
    [_cmManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        double x = accelerometerData.acceleration.x;
        double y = accelerometerData.acceleration.y;
        double z = accelerometerData.acceleration.z;
        //绝对值
        if (fabs(x) > 2.0 || fabs(y) > 2.0 || fabs(z) > 2.0) {
            //调用view生成界面
            [self performSelectorOnMainThread:@selector(showAnalyseTool:) withObject:nil waitUntilDone:nil];
        }
    }];
}

- (void)unregisterUrlAnalyse
{
    if (_cmManager) {
        [_cmManager stopAccelerometerUpdates];
    }
}

#pragma mark 展示分析页面
- (void)showAnalyseTool:(id)sender
{
    if (_hasShow) {
        return;
    }
    
    JHURLAnalyseListViewController *controller = [[JHURLAnalyseListViewController alloc] init];
    //将url分析工具控制器加入navigation栈中
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
    //在window层创建一个rootVC
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    //将navigation控制器模态show出
    [rootViewController presentViewController:naviController animated:YES completion:nil];
    _hasShow = YES;
}

- (void)addObjectToUrlArray:(NSDictionary *)infoDict
{
    //只展示30条信息
    if (_urlArray.count > 30) {
        [_urlArray removeObjectAtIndex:29];
    }
    //插入最新数据
    [_urlArray insertObject:infoDict atIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JHUrlAnalyseChangeKey object:nil userInfo:nil];
}

- (void)cleanAllObjects
{
    [_urlArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:JHUrlAnalyseChangeKey object:nil userInfo:nil];
}


@end
