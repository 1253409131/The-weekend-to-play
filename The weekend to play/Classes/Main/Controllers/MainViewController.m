//
//  MainViewController.m
//  The weekend to play
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property (nonatomic, strong) NSMutableArray *themeArray;
//广告
@property (nonatomic, strong) NSMutableArray *adArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
//    //导航栏颜色
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96.0/255.0 green:185.0/255.0 blue:191.0/255.0 alpha:1.0];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //
    [self configTableViewHeaderView];
    
    //请求网络数据
    [self requestModel];
    
    
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"背景" style:UIBarButtonItemStylePlain target:self action:@selector(selectcCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchActivity:)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    
    


    
}




#pragma mark --------- UITableViewDataSouce
//每一个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.themeArray.count;
}
//重用机制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.mainModel = array[indexPath.row];
    
    return mainCell;
}



#pragma mark ---------- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}
//自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 160, 5, 320, 16)];
    
    if (section == 0) {
        
        sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
        
        
    }else{
        sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
        
    }
    
    [view addSubview:sectionView];
    return view;
}



#pragma mark --------Custom Method
//选择城市
- (void)selectcCityAction:(UIButton *)btn{
    
}

//搜索关键字
- (void)searchActivity:(UIButton *)btn{
    
}

- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
//    tableViewHeaderView.backgroundColor = [UIColor cyanColor];
    
    //添加轮播图
    UIScrollView *carouselView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186)];
    carouselView.contentSize = CGSizeMake(self.adArray.count * [UIScreen mainScreen].bounds.size.width, 186);
    
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i]] placeholderImage:nil];
        [carouselView addSubview:imageView];
    }
    

    [tableViewHeaderView addSubview:carouselView];
    
    
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width / 4, 186, [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d",i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
    }
    
    //精选活动&精选主题
    
    UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activityBtn.frame = CGRectMake(0, 186 +[UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4);
    
    [activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
    activityBtn.tag = 110;
    [activityBtn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:activityBtn];
    
    
    UIButton *themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    themeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 186 +[UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4);
    
    [themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
    themeBtn.tag = 111;
    [themeBtn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:themeBtn];
    
    
    
    self.tableView.tableHeaderView = tableViewHeaderView;
}


- (void)mainActivityButtonAction:(UIButton *)btn{
    
}

//网络请求
- (void)requestModel{
    
    NSString *str = [NSString stringWithFormat:@"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"];
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [sessionManger GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress = %lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status" ];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            for (NSDictionary *dict in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                NSLog(@"model = %@",model);
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            //刷新tableView数据
            [self.tableView reloadData];
            
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic in adDataArray) {
                [self.adArray addObject:dic[@"url"]];
            }
            //拿到数据之后重新刷新
            [self configTableViewHeaderView];
            
            
            //以请求回来的城市作为导航栏按钮标题
            NSString *cityName = dic[@"cityname"];
            self.navigationItem.leftBarButtonItem.title = cityName;
            
            
        }else{
            
        }
        
        
        
        
//        NSLog(@"success = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error = %@",error);
    }];
}

#pragma mark -------- Lazing
//懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}

- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}

- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
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
