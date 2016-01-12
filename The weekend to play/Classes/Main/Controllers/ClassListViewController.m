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
#import "JingXuanModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "VOSegmentedControl.h"
#import "ProgressHUD.h"
#import "ActivityViewController.h"

@interface ClassListViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;//定义请求的页码
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
//用来负责展示数据的数组
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) NSMutableArray *touristArray;
@property (nonatomic, strong) NSMutableArray *studyArray;
@property (nonatomic, strong) NSMutableArray *familyArray;
@property (nonatomic, assign) BOOL refreshing;


@property (nonatomic, strong) VOSegmentedControl *segmentedControl;


@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageCount = 1;
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
    [self showBackButton];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.segmentedControl];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JingXuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
//    [self.tableView launchRefreshing];
    
    //第一次进入列表，请求全部的接口数据
    [self chooseRequest];
    
    //根据上一页选择的按钮，确定显示第几页数据
    [self showPreviousSelectButton];
}
//在页面将要消失的时候去掉
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}




#pragma mark --------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JingXuanTableViewCell *jingxuanCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    jingxuanCell.jignxuanModel = self.showDataArray[indexPath.row];
    
    return jingxuanCell;
}


#pragma mark ---------- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityDetilVC"];
    //活动id
    JingXuanModel *model = self.showDataArray[indexPath.row];
    activityVC.activityId = model.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];
}



#pragma mark -------- PullingRefreshTableViewDelegate
//tableView开始刷新的时候调用
//上拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
    _pageCount = 1;
}
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
    _pageCount += 1;
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
}

//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}
#pragma mark --------  Custom Method

- (void)getShowRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    
    //typeid = 6  //演出剧目
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClass, _pageCount, @(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [ProgressHUD showSuccess:@"数据加载完成"];
       
        QJZLog(@"responseObject = %@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                JingXuanModel *model = [[JingXuanModel alloc] initWithDictionary:dict];
                QJZLog(@"model = %@",model);
                [self.showArray addObject:model];
                
            }
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QJZLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    
}
- (void)getTouristRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    
    //typeid = 23  // 景点场馆
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClass, _pageCount, @(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        QJZLog(@"responseObject = %@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }
            
            for (NSDictionary *dict in acDataArray) {
                JingXuanModel *model = [[JingXuanModel alloc] initWithDictionary:dict];
                QJZLog(@"model = %@",model);
                [self.touristArray addObject:model];
                
            }
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QJZLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    
}
- (void)getStudyRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    
    //typeid = 22  // 学习益智
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClass, _pageCount, @(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        QJZLog(@"responseObject = %@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }
            
            for (NSDictionary *dict in acDataArray) {
                JingXuanModel *model = [[JingXuanModel alloc] initWithDictionary:dict];
                QJZLog(@"model = %@",model);
                [self.studyArray addObject:model];
                
            }
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QJZLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    
}
- (void)getFamilyRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    
    //typeid = 21  // 亲子旅游
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClass, _pageCount, @(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        QJZLog(@"responseObject = %@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.familyArray.count > 0) {
                    [self.familyArray removeAllObjects];
                }
            }
            
            for (NSDictionary *dict in acDataArray) {
                JingXuanModel *model = [[JingXuanModel alloc] initWithDictionary:dict];
                QJZLog(@"model = %@",model);
                [self.familyArray addObject:model];
            }
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QJZLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    
}
- (void)showPreviousSelectButton{
    if (self.refreshing) {//下拉删除原来的数据
        if (self.showDataArray.count > 0) {
            [self.showDataArray removeAllObjects];
        }
    }
    switch (self.classifyListType) {
            
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;
        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;
        case ClassifyListTypeTravel:
        {
            self.showDataArray = self.familyArray;
        }
            break;
            
        default:
            break;
    }
    
    //完成加载
    [self.tableView reloadData];

}
- (void)chooseRequest{
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getShowRequest];
            break;
        case ClassifyListTypeTouristPlace:
            [self getTouristRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getStudyRequest];
            break;
        case ClassifyListTypeTravel:
            [self getFamilyRequest];
            break;
            
        default:
            break;
    }
}

#pragma mark -------Lazyloading

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64 + 64, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.rowHeight = 120;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}

- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}

- (NSMutableArray *)touristArray{
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}
- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}
- (NSMutableArray *)familyArray{
    if (_familyArray == nil) {
        self.familyArray =[NSMutableArray new];
    }
    return _familyArray;
}

- (VOSegmentedControl *)segmentedControl{
    if (_segmentedControl == nil) {
        self.segmentedControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"演出剧目"}, @{VOSegmentText: @"景点场馆"}, @{VOSegmentText: @"学习益智"}, @{VOSegmentText: @"亲子旅游"}]];
        self.segmentedControl.contentStyle = VOContentStyleTextAlone;
        self.segmentedControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentedControl.backgroundColor = [UIColor whiteColor];
        self.segmentedControl.selectedBackgroundColor = self.segmentedControl.backgroundColor;
        self.segmentedControl.allowNoSelection = NO;
        self.segmentedControl.frame = CGRectMake(0, 64, kWidth, 44);
        self.segmentedControl.indicatorThickness = 4;
        self.segmentedControl.selectedSegmentIndex = self.classifyListType -1;
        
//        //返回点击的是哪个按钮
        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"1: block --> %@", @(index));
        }];
        [self.segmentedControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}


- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
    self.classifyListType = segmentCtrl.selectedSegmentIndex + 1;
    [self chooseRequest];
    
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
