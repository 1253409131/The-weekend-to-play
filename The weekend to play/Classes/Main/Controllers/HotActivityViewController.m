//
//  HotActivityViewController.m
//  The weekend to play
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "HotActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "HotActivityTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HotActivityModel.h"
#import "ThemeViewController.h"
@interface HotActivityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;//定义请求的页码
}
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotActivityArray;


@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"热门专题";
    self.view.backgroundColor = [UIColor greenColor];
    //在热门专题页面隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButton];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView launchRefreshing];
}

- (NSMutableArray *)hotActivityArray{
    if (_hotActivityArray == nil) {
        self.hotActivityArray = [NSMutableArray new];
    }
    return _hotActivityArray;
}

#pragma mark --------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotActivityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotActivityTableViewCell *hotActivityCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//        hotActivityCell.backgroundColor = [UIColor brownColor];
    hotActivityCell.hotActivityModel = self.hotActivityArray[indexPath.row];
    tableView.rowHeight = 240;
   
    return hotActivityCell;
}

#pragma mark ---------- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotActivityModel *hotModel = self.hotActivityArray[indexPath.row];
    ThemeViewController *themeVC = [[ThemeViewController alloc] init];
    themeVC.themeid = hotModel.hotId;
    [self.navigationController pushViewController:themeVC animated:YES];
}

#pragma mark -------- PullingRefreshTableViewDelegate
//tableView开始刷新的时候调用
//上拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount += 1;
}
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount = 1;
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
}

//加载数据
- (void)loadData{
    QJZLog(@"12312");
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld",KHotActivity,(long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        QJZLog(@"downloadProgress = %@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        QJZLog(@"responseObject = %@",responseObject);
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"status"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *rcDataArray = dict[@"rcData"];
            
            if (self.refreshing) {
                if (self.hotActivityArray.count > 0) {
                    [self.hotActivityArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in rcDataArray) {
                HotActivityModel *model = [[HotActivityModel alloc] initWithDictionary:dict];
                [self.hotActivityArray addObject:model];
            }
            [self.tableView reloadData];
        }else{
            
        }
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QJZLog(@"error = %@",error);
    }];
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}





//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark -------Lazyloading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
