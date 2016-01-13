//
//  DiscoverViewController.m
//  The weekend to play
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "DiscoverModel.h"
#import "ActivityViewController.h"
#import "HWTool.h"

@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate>

@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *discoverArray;
@property (nonatomic, assign) BOOL refreshing;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    
    
    
}



#pragma mark ------------UITbleViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.discoverArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.discoverModel = self.discoverArray[indexPath.row];
    return cell;
}


#pragma mark ------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverModel *model = self.discoverArray[indexPath.row];
    UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityViewController *activityVC = [mainStroyBoard instantiateViewControllerWithIdentifier:@"ActivityDetilVC"];
    activityVC.hidesBottomBarWhenPushed = YES;
    activityVC.activityId = model.discoverId;
    [self.navigationController pushViewController:activityVC animated:YES];
}
    
#pragma mark --------- PullingRefreshTableViewDelegate
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
}


- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
}
//手指开始拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];

}

-(void)viewWillAppear:(BOOL)animated{
    [self viewDidAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark --------  Custom Method


#pragma mark ------------- Lazy Loading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 44) pullingDelegate:self];
        self.tableView.backgroundColor = [UIColor cyanColor];
        //只有上边的下拉刷新
        [self.tableView setHeaderOnly:YES];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.rowHeight = 120;
        
    }
    return _tableView;
}


- (NSMutableArray *)discoverArray{
    if (_discoverArray == nil) {
        self.discoverArray = [NSMutableArray new];
    }
    return _discoverArray;
}
- (void)loadData{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManger GET:[NSString stringWithFormat:@"%@",kDiscover] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        QJZLog(@"downloadProgress = %@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        QJZLog(@"responseObject = %@",responseObject);
        [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *like = dict[@"like"];
            for (NSDictionary *likeDic in like) {
                DiscoverModel *model = [[DiscoverModel alloc] initWithDictionary:likeDic];
                [self.discoverArray addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QJZLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
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
