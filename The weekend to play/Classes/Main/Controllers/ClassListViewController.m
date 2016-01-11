//
//  ClassListViewController.m
//  The weekend to play
//  分类列表
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "ClassListViewController.h"
#import "PullingRefreshTableView.h"
#import "JingXuanTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface ClassListViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;//定义请求的页码
}
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *JingxuanArray;

@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
//    self.view.backgroundColor = [UIColor colorWithRed:92/255.0 green:159/255.0 blue:107/255.0 alpha:1.0];
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"演出剧目", @"景点场馆", @"学习益智", @"亲子旅游"]];
    self.segmentControl.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    //给segment设置方法
    [self.segmentControl addTarget:self action:@selector(segmentTapAction:) forControlEvents:UIControlEventTouchUpInside];
    //添加视图
    [self.view addSubview:self.segmentControl];
    
    
    
    [self showBackButton];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"JingXuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    

    [self.tableView launchRefreshing];
    
}
//分段显示
- (void)segmentTapAction:(UISegmentedControl *)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:
        self.btnId = @"6";
            break;
            case 1:
            self.btnId = @"23";
            break;
            case 2:
            self.btnId = @"22";
            break;
            case 3:
            self.btnId = @"21";
            break;
        default:
            break;
    }
}


- (NSMutableArray *)jignxuanArray{
    if (_JingxuanArray == nil) {
        self.JingxuanArray = [NSMutableArray new];
    }
    return _JingxuanArray;
}

#pragma mark --------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jignxuanArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JingXuanTableViewCell *jingxuanCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //    jingxuanCell.backgroundColor = [UIColor brownColor];
    tableView.rowHeight = 100;
    jingxuanCell.jignxuanModel = self.jignxuanArray[indexPath.row];
    return jingxuanCell;
}


#pragma mark ---------- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



#pragma mark -------- PullingRefreshTableViewDelegate
//tableView开始刷新的时候调用
//上拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount = 1;
}
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount += 1;
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
}


- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&typeid=%ld",kYanchujumu,(long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        QJZLog(@"downloadProgress = %@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        QJZLog(@"responseObject = %@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
            for (NSDictionary *dict in acDataArray) {
                JingXuanModel *model = [[JingXuanModel alloc] initWithDictionary:dict];
                QJZLog(@"model = %@",model);
                [self.jignxuanArray addObject:model];
                
            }
            [self.tableView reloadData];
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
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64 + 64, kWidth, kHeight - 64) pullingDelegate:self];
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
