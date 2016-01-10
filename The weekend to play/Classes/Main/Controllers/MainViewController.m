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

#import "PrefixHeader.pch"
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityViewController.h"
#import "ThemeViewController.h"
#import "ClassListViewController.h"
#import "JingXuanViewController.h"
#import "HotActivityViewController.h"


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
@property (nonatomic, strong) UIScrollView *carouselView;
@property(nonatomic, retain) UIPageControl *pageControl;
//定时器用于播放轮播图
@property(nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIButton *activityBtn;
@property (nonatomic, retain) UIButton *themeBtn;
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
    //启动定时器
    [self startTimer];
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"背景" style:UIBarButtonItemStylePlain target:self action:@selector(selectcCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchActivity:)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

//隐藏tabBar
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}




#pragma mark --------- UITableViewDataSouce
//每一个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;//活动
    }
    return self.themeArray.count;//专题
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //活动id
    MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ActivityViewController *activityVC = [mainStroyBoard instantiateViewControllerWithIdentifier:@"ActivityDetilVC"];
        
       
        activityVC.activityId = mainModel.activityId;
        [self.navigationController pushViewController:activityVC animated:YES];
        
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        themeVC.themeid = mainModel.activityId;
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    
}


#pragma mark --------Custom Method
//选择城市
- (void)selectcCityAction:(UIButton *)btn{
    SelectCityViewController *selectVC = [[SelectCityViewController alloc] init];
    [self presentViewController:selectVC animated:YES completion:nil];
}

//搜索关键字
- (void)searchActivity:(UIButton *)btn{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark --------- configTableViewHeaderView
- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
//    tableViewHeaderView.backgroundColor = [UIColor cyanColor];
    
    //添加轮播图
    self.carouselView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186)];
    self.carouselView.delegate = self;
    //整屏滑动
    self.carouselView.pagingEnabled = YES;
    //不要水平滚动条
    self.carouselView.showsHorizontalScrollIndicator = NO;
    self.carouselView.contentSize = CGSizeMake(self.adArray.count * [UIScreen mainScreen].bounds.size.width, 186);
    
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        
        [self.carouselView addSubview:imageView];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
        [self.carouselView addSubview:touchBtn];
        
        
        
        
        
        
    }
    
    //创建一个pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100 , 186-30, kWidth - 200, 30)];
    
    self.pageControl.numberOfPages= self.adArray.count;
    [self.pageControl  addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    
    [tableViewHeaderView addSubview:self.carouselView];
    [tableViewHeaderView addSubview:self.pageControl ];
    
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
    
    //懒加载
    [tableViewHeaderView addSubview:self.activityBtn];
    [tableViewHeaderView addSubview:self.themeBtn];
    self.tableView.tableHeaderView = tableViewHeaderView;

}

#pragma mark --------- 精选活动，热门活动
//精选活动&精选主题
- (UIButton *)activityBtn{
    if (_activityBtn == nil) {
        self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.activityBtn.frame = CGRectMake(0, 186 +[UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4);
        
        [self.activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
        self.activityBtn.tag = 110;
        [self.activityBtn addTarget:self action:@selector(mainJingXuanActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _activityBtn;
}


- (UIButton *)themeBtn{
    if (_themeBtn == nil) {
        self.themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.themeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 186 +[UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4);
        
        [self.themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
        self.themeBtn.tag = 111;
        [self.themeBtn addTarget:self action:@selector(mainHotActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _themeBtn;
}




#pragma mark --------- 轮播图方法
- (void)pageControlAction:(UIPageControl *)pageControl{
    //第一步：获取pageControl在第几页
    NSInteger pageNum = pageControl.currentPage;
    //第二步获取当前页宽度
    CGFloat pageWidth  = self.carouselView.frame.size.width;
    //到达页
    self.carouselView.contentOffset = CGPointMake(pageNum * pageWidth, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //第一步：获取scrollView页面的宽度
    CGFloat pageWidth = self.carouselView.frame.size.width;
    //第二步：获取scrollView停止时候的偏移量
    
    CGPoint offset = self.carouselView.contentOffset;
    //第三步：通过偏移量和页面宽度计算出来当前页面
    NSInteger pageNum = offset.x / pageWidth;
    self.pageControl.currentPage = pageNum;
    
    
}
//热门专题
- (void)mainHotActivityButtonAction{
    HotActivityViewController *hotVC = [[HotActivityViewController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];
}
//精选活动
- (void)mainJingXuanActivityButtonAction{
    JingXuanViewController *jingxuanVC = [[JingXuanViewController alloc] init];
    [self.navigationController pushViewController:jingxuanVC animated:YES];
    
}

//点击广告
- (void)touchAdvertisement:(UIButton *)adButton{
    //从数组中的字典里取出type类型
    NSString *type = self.adArray[adButton.tag - 100][@"type"];
    if ([type integerValue] == 1) {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        ActivityViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityDetilVC"];
        //活动id
        activityVC.activityId = self.adArray[adButton.tag - 100][@"id"];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        
        themeVC.themeid = self.adArray[adButton.tag - 100][@"id"];
        
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    
}





#pragma mark-------轮播图
- (void)startTimer{
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(rollAnimation) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
//每两秒执行一次，图片自动轮播
- (void)rollAnimation{
    //方法1.
//    NSInteger page = self.pageControl.currentPage;
//    if (page == self.pageControl.numberOfPages - 1) {
//        page = 0;
//    }else{
//        page = page + 1;
//    }
//    self.pageControl.currentPage = page;
    //方法2.
    //把page当前页+1
    //self.adArray.count数组元素个数可能为0，当对0取余没有意义
    if (self.adArray.count > 0) {
        NSInteger rollPage = (self.pageControl.currentPage + 1) % self.adArray.count;
        self.pageControl.currentPage = rollPage;
        //计算scrollView应该滚动的x轴坐标
        CGFloat offsetX = self.pageControl.currentPage * kWidth;
        [self.carouselView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}
//当动手去滑动scrollView的时候，定时器依然在计算时间，可能我们刚刚滑动到下一页，定时器时间刚好促发，导致在当前页面停留的时间不够2秒。
//解决方案在scrollView开始移动的时候结束定时器
//在scrollView移动完毕的时候再启动定时器
/*
 scrollView将要开始拖拽
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器
    [self.timer invalidate];
    self.timer = nil;//停止定时器后并置为nil，再次启动定时器才能保证正常执行
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //启动定时器
    [self startTimer];
}
#pragma mark --------- 四个按钮
//四个按钮
- (void)mainActivityButtonAction:(UIButton *)btn{
    ClassListViewController *classListVC = [[ClassListViewController alloc] init];
    [self.navigationController pushViewController:classListVC animated:YES];
    
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
//                NSLog(@"model = %@",model);
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
                NSDictionary *dict = @{@"url":dic[@"url"],@"type":dic[@"type"],@"id":dic[@"id"]};
                                      
                                      
                [self.adArray addObject:dict];
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
