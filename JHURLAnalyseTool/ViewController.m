//
//  ViewController.m
//  JHURLAnalyseTool
//
//  Created by Shenjinghao on 2017/2/8.
//  Copyright © 2017年 JHModule. All rights reserved.
//

#import "ViewController.h"
#import "JHURLAnalyseManager.h"
#import "JHURLAnalyseProtocol.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    [self registerAnalyseTool];
    
}

- (void)createView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(15, 300, self.view.bounds.size.width - 30, 45);
    [button setTitle:@"测试" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(didClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didClicked:(id)sender
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [self.view addSubview:webView];
}

#pragma mark 注册工具
- (void)registerAnalyseTool
{
    
    [NSURLProtocol registerClass:[JHURLAnalyseProtocol class]];
    [[JHURLAnalyseManager defaultManager] registerUrlAnalyse];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
