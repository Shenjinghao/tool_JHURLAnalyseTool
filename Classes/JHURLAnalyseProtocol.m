//
//  JHURLAnalyseProtocol.m
//  JHURLAnalyseTool
//
//  Created by Shenjinghao on 2017/2/9.
//  Copyright © 2017年 JHModule. All rights reserved.
//

#import "JHURLAnalyseProtocol.h"
#import "JHURLAnalyseManager.h"

//参考http://blog.csdn.net/xanxus46/article/details/51946432 ||  http://www.cocoachina.com/ios/20141225/10765.html

@interface JHURLAnalyseProtocol ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSMutableDictionary *urlInfo;

@end

@implementation JHURLAnalyseProtocol

#pragma mark 定义拦截请求的URL规则
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //处理https和http,进行拦截处理
    NSString *scheme = [[request URL] scheme];
    //比较两个字符串 (忽略大小写)
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        //防止无限循环，因为一个请求在被拦截处理过程中，也会发起一个请求，这样又会走到这里，如果不进行处理，就会造成无限循环
        if ([NSURLProtocol propertyForKey:JHUrlProtocolHandledKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark 如果需要对请求进行重定向，添加指定头部等操作，可以在该方法中进行
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

#pragma mark 用于判断你的自定义reqeust是否相同，这里返回默认实现即可。它的主要应用场景是某些直接使用缓存而非再次请求网络的地方。
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

#pragma mark 对于拦截的请求，系统创建一个NSURLProtocol对象执行startLoading方法开始加载请求
- (void)startLoading
{
    _startDate = [NSDate date];
    _urlInfo = [NSMutableDictionary dictionary];
    
    //记录UUID
    _urlInfo[JHUrlRequestUUID] = [NSUUID UUID].UUIDString;
    
    //表示该请求已经被处理，防止无限循环
    NSMutableURLRequest *request = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@(YES) forKey:JHUrlProtocolHandledKey inRequest:request];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //测试
    [self urlComposition];
}

#pragma mark 对于拦截的请求，NSURLProtocol对象在停止加载时调用该方法
- (void)stopLoading
{
    //时间
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_startDate];
    _urlInfo[JHUrlResponseTime] = @(timeInterval);
    
    //httpbody
    NSString *requestHttpBody = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
    _urlInfo[JHUrlRequestHttpBody] = requestHttpBody ? : @"";
    
    _urlInfo[JHUrlRequestUrl] = self.request.URL.absoluteString;
    _urlInfo[JHUrlRequestHttpMethod] = self.request.HTTPMethod;
    _urlInfo[JHUrlRequestHttpHeaderFields] = self.request.allHTTPHeaderFields;
    
    //将数据传入管理类中统一展示
    [[JHURLAnalyseManager defaultManager] addObjectToUrlArray:_urlInfo];
    
    [_connection cancel];
}

#pragma mark delegate and data delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSString *body = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
    _urlInfo[JHUrlResponseHttpBody] = body ? : @"";
    
    _urlInfo[JHUrlResponseUrl] = response.URL.absoluteString;
    _urlInfo[JHUrlResponseMIMEType] = response.MIMEType;
    
    //只有NSHTTPURLResponse有statusCode属性，此处强转下类型
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        _urlInfo[JHUrlRequestStatusCode] = @(((NSHTTPURLResponse *)response).statusCode);
        _urlInfo[JHUrlResponseHttpHeaderFields] = ((NSHTTPURLResponse *)response).allHeaderFields;
    }
    
    //因为NSURLProtocol是由一系列的回调函数构成的（注册函数除外),而要对URL的data进行各种操作时就到了调用NSURLProtocolClient实例的时候了，这就实现了一个钩子，去操作URL data。
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _urlInfo[JHUrlRequestConnetcionErrorInfo] = error.userInfo;
    [self.client URLProtocol:self didFailWithError:error];
}

/**
 url组成元素
 */
- (void)urlComposition
{
    NSURL *url = [NSURL URLWithString:  @"http://www.sjh.cn/query/regism.html?method=login"];
    
    NSLog(@"absoluteString: %@", [url absoluteString]);
    NSLog(@"absoluteURL: %@", [url absoluteURL]);
    NSLog(@"baseURL: %@", [url baseURL]);
    NSLog(@"dataRepresentation: %@", [url dataRepresentation]);
    NSLog(@"hasDirectoryPath: %d", [url hasDirectoryPath]);
    //const char类型的输出标识符是s！！！
    NSLog(@"fileSystemRepresentation: %s", [url fileSystemRepresentation]);
    NSLog(@"filePathURL: %@", [url filePathURL]);
    
    //任何url由两部分组成    [myURL scheme], ':', [myURL resourceSpecifier]
    NSLog(@"Scheme: %@", [url scheme]);
    NSLog(@"ResourceSpecifier: %@", [url resourceSpecifier]);
    
    NSLog(@"Host: %@", [url host]);
    NSLog(@"Port: %@", [url port]);
    NSLog(@"Path: %@", [url path]);
    NSLog(@"Relative path: %@", [url relativePath]);
    NSLog(@"Path components as array: %@", [url pathComponents]);
    NSLog(@"Parameter string: %@", [url parameterString]);
    NSLog(@"Query: %@", [url query]);
    NSLog(@"Fragment: %@", [url fragment]);
    NSLog(@"User: %@", [url user]);
    NSLog(@"Password: %@", [url password]);
    /*
     JHURLAnalyseTool[2640:1186468] absoluteString: http://www.sjh.cn/query/regism.html?method=login
     2017-02-09 17:59:27.542240 JHURLAnalyseTool[2640:1186468] absoluteURL: http://www.sjh.cn/query/regism.html?method=login
     2017-02-09 17:59:27.542322 JHURLAnalyseTool[2640:1186468] baseURL: (null)
     2017-02-09 17:59:27.542458 JHURLAnalyseTool[2640:1186468] dataRepresentation: <68747470 3a2f2f77 77772e73 6a682e63 6e2f7175 6572792f 72656769 736d2e68 746d6c3f 6d657468 6f643d6c 6f67696e>
     2017-02-09 17:59:27.542505 JHURLAnalyseTool[2640:1186468] hasDirectoryPath: 0
     2017-02-09 17:59:27.542587 JHURLAnalyseTool[2640:1186468] fileSystemRepresentation: /query/regism.html
     2017-02-09 17:59:27.542656 JHURLAnalyseTool[2640:1186468] filePathURL: (null)
     2017-02-09 17:59:27.542719 JHURLAnalyseTool[2640:1186468] Scheme: http
     2017-02-09 17:59:27.542811 JHURLAnalyseTool[2640:1186468] ResourceSpecifier: //www.sjh.cn/query/regism.html?method=login
     2017-02-09 17:59:27.542881 JHURLAnalyseTool[2640:1186468] Host: www.sjh.cn
     2017-02-09 17:59:27.544533 JHURLAnalyseTool[2640:1186468] Port: (null)
     2017-02-09 17:59:27.544625 JHURLAnalyseTool[2640:1186468] Path: /query/regism.html
     2017-02-09 17:59:27.544696 JHURLAnalyseTool[2640:1186468] Relative path: /query/regism.html
     2017-02-09 17:59:27.547397 JHURLAnalyseTool[2640:1186468] Path components as array: (
     "/",
     query,
     "regism.html"
     )
     2017-02-09 17:59:27.547554 JHURLAnalyseTool[2640:1186468] Parameter string: (null)
     2017-02-09 17:59:27.547636 JHURLAnalyseTool[2640:1186468] Query: method=login
     2017-02-09 17:59:27.547701 JHURLAnalyseTool[2640:1186468] Fragment: (null)
     2017-02-09 17:59:27.547763 JHURLAnalyseTool[2640:1186468] User: (null)
     2017-02-09 17:59:27.547831
     */
}

@end
