//
//  JHURLAnalyseListViewController.m
//  JHURLAnalyseTool
//
//  Created by Shenjinghao on 2017/2/9.
//  Copyright © 2017年 JHModule. All rights reserved.
//

#import "JHURLAnalyseListViewController.h"
#import "JHURLAnalyseManager.h"
#import "JHURLAnalyseListTableViiewCell.h"
#import "JHURLAnalyseDetailViewController.h"

@interface JHURLAnalyseListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *analyseTableView;

@end

@implementation JHURLAnalyseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"URL 分析工具";
    
    [self createViews];
    
    [self setBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:JHUrlAnalyseChangeKey object:nil];
}

- (void)createViews
{
    if (_analyseTableView) {
        return;
    }
    
    _analyseTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _analyseTableView.delegate = self;
    _analyseTableView.dataSource = self;
    [self.view addSubview:_analyseTableView];
}

- (void)setBarButtonItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Bye~~" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBarButtonDidClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [JHURLAnalyseManager defaultManager].hasShow = NO;
}

#pragma mark delegate and data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 不加此句时，在二级栏目点击返回时，此行会由选中状态慢慢变成非选中状态。
    // 加上此句，返回时直接就是非选中状态。
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHURLAnalyseDetailViewController *controller = [[JHURLAnalyseDetailViewController alloc] init];
    controller.urlInfo = [JHURLAnalyseManager defaultManager].urlArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [JHURLAnalyseManager defaultManager].urlArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //覆用
    static NSString *cellIndentifier = @"UrlAnalyseCell";
    JHURLAnalyseListTableViiewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[JHURLAnalyseListTableViiewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    //获取cell信息
    NSDictionary *cellInfo = [JHURLAnalyseManager defaultManager].urlArray[indexPath.row];
    //创建||更新cell
    [cell updateCellInfo:cellInfo];
    
    return cell;
}

#pragma mark 收到通知，更新数据
- (void)refreshTableView
{
    [_analyseTableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
