//
//  JHURLAnalyseDetailViewController.m
//  JHURLAnalyseTool
//
//  Created by Shenjinghao on 2017/2/9.
//  Copyright © 2017年 JHModule. All rights reserved.
//

#import "JHURLAnalyseDetailViewController.h"
#import "JHURLAnalyseManager.h"

@interface JHURLAnalyseDetailViewController ()

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, copy) NSString *requestUrl;

@end

@implementation JHURLAnalyseDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _urlInfo = [NSDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"URL 详细信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBarButtonItem];
    
    [self createUrlInfoView];
    
}

- (void)setBarButtonItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"嘿嘿嘿" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark 嘿嘿嘿是为了copy
- (void)rightBarButtonDidClicked
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"嘿嘿嘿" message:@"select" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"copy url" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //使用粘贴板功能copy url
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setString:self.requestUrl];
    }];
    
    [alertController addAction:alert1];
    [alertController addAction:alert2];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)createUrlInfoView
{
    if (_scrollView) {
        return;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    
    //request内容
    NSMutableString *requestString = [NSMutableString stringWithFormat:@"Request:\n\n"];
    [requestString appendFormat:@"URL:\n%@\n\n",_urlInfo[JHUrlRequestUrl]];
    [requestString appendFormat:@"HttpBody:\n%@\n\n",_urlInfo[JHUrlRequestHttpBody]];
    [requestString appendFormat:@"HeaderFields:\n"];
    if ([_urlInfo[JHUrlRequestHttpHeaderFields] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *headerFields = _urlInfo[JHUrlRequestHttpHeaderFields];
        [headerFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [requestString appendFormat:@"%@ : %@\n",key, obj];
        }];
    }
    
    UILabel *requestLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width - 30, 0)];
//    requestLabel.backgroundColor = [UIColor redColor];
    requestLabel.text = requestString;
    requestLabel.numberOfLines = 0;
    [requestLabel sizeToFit];
    [_scrollView addSubview:requestLabel];
    
    //划线
    CGRect lineFrame = CGRectMake(requestLabel.frame.origin.x, requestLabel.frame.origin.y + requestLabel.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 30, 1);
    [self createLineViewWithFrame:lineFrame];
    
    //response内容
    NSMutableString *responseString = [NSMutableString stringWithFormat:@"Response:\n\n"];
    [responseString appendFormat:@"URL:\n%@\n\n",_urlInfo[JHUrlResponseUrl]];
    [responseString appendFormat:@"HttpBody:\n%@\n\n",_urlInfo[JHUrlResponseHttpBody]];
    [responseString appendFormat:@"HttpMethod:%@\n\nStatusCode:%@\n\n",_urlInfo[JHUrlRequestHttpMethod],_urlInfo[JHUrlRequestStatusCode]];
    [responseString appendFormat:@"Responsetime:\n%@\n\n",_urlInfo[JHUrlResponseTime]];
    [responseString appendFormat:@"MIMEType:\n%@\n\n",_urlInfo[JHUrlResponseMIMEType]];
    [responseString appendFormat:@"HeaderFields:\n"];
    
    if ([_urlInfo[JHUrlRequestHttpHeaderFields] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *headerFields = _urlInfo[JHUrlRequestHttpHeaderFields];
        [headerFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [responseString appendFormat:@"%@ : %@\n",key, obj];
        }];
    }
    
    UILabel *responseLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineFrame.origin.x, lineFrame.origin.y + lineFrame.size.height + 10, lineFrame.size.width, 0)];
//    responseLabel.backgroundColor = [UIColor blueColor];
    responseLabel.text = responseString;
    responseLabel.numberOfLines = 0;
    [responseLabel sizeToFit];
    [_scrollView addSubview:responseLabel];
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, responseLabel.frame.origin.y + responseLabel.frame.size.height + 20);
    
}

#pragma mark 分割线
- (void)createLineViewWithFrame:(CGRect)frame
{
    UILabel *line = [[UILabel alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
