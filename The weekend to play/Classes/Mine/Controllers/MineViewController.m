//
//  MineViewController.m
//  The weekend to play
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "MineViewController.h"
#import <MessageUI/MessageUI.h>
#import <SDWebImage/SDImageCache.h>
#import "ProgressHUD.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *headImageButton;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UILabel *nikeNameLable;
@property(nonatomic, strong) UIView *blackView;
@property(nonatomic, strong) UIView *shareView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    self.navigationController.navigationBar.barTintColor = kColor;
    
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"清除缓存", @"用户反馈", @"分享给好友", @"给我评分", @"当前版本1.0", nil];
    self.imageArray = @[@"btn_select", @"home", @"qq_normal", @"pc_menu_collect_normal_ic", @"btn_share_selected"];
    [self setUpTableViewHeaderView];
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次当页面将要出现的时候重新计算图片缓存
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    QJZLog(@"%ld",cacheSize);
    NSString *cscheStr = [NSString stringWithFormat:@"缓存大小（%.02fM）",(float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cscheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
}

#pragma mark --------------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //去掉cell选中的颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}




#pragma mark --------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [ProgressHUD show:@"正在为您清理中..."];
            [self performSelector:@selector(clearImage) withObject:nil afterDelay:5.0];
            
            //清除缓存
            QJZLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
            //刷新单行数据
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
            break;
        case 1:
        {
            //发送邮件
            [self sendEmail];
        }
            break;
        case 2:
        {
           //分享
            [self share];
        }
            break;
        case 3:
        {
            //appStore评分
            NSString *str = [NSString stringWithFormat:
                             
                             @"itms-apps://itunes.apple.com/app"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 4:
        {
            //检测当前版本
            [ProgressHUD show:@"正在为您检测中..."];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
        }
            break;
            
        default:
            break;
    }
}

- (void)clearImage{
    [ProgressHUD showSuccess:@"占您的地儿已经挪开"];
    //清除缓存
    QJZLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearDisk];
    [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
    //刷新单行数据
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)setUpTableViewHeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 210)];
    headView.backgroundColor = kColor;
    [headView addSubview:self.headImageButton];
    [headView addSubview:self.nikeNameLable];
    self.tableView.tableHeaderView = headView;
}


- (void)sendEmail{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            //初始化发送邮件类对象
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
            //设置代理
            mailVC.mailComposeDelegate = self;
            //设置主题
            [mailVC setSubject:@"用户反馈"];
            //设置收件人
            NSArray *receive = [NSArray arrayWithObjects:@"1253409131@qq.com", nil];
            [mailVC setToRecipients:receive];
            //设置发送内容
            NSString *text = @"请留下您宝贵的意见";
            [mailVC setMessageBody:text isHTML:NO];
            //推出视图
            [self presentViewController:mailVC animated:YES completion:nil];
        }else{
            QJZLog(@"未配置邮箱账号");
        }
    
    }else{
        QJZLog(@"当前设备不能发送");
    }
}

//邮件发送完成调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled://取消
            QJZLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved://保存
            QJZLog(@"MFMailComposeResultSaved-保存");
            break;
        case MFMailComposeResultSent://发送
            QJZLog(@"MFMailComposeResultSent-发送");
            break;
        case MFMailComposeResultFailed://尝试保存或发送邮件失败
            QJZLog(@"MFMailComposeResultFailed-...");
            break;
            
        default:
            break;
    }
}

- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"恭喜您！目前已是最高版本"];
}
#pragma mark ---------- 分享
//分享
- (void)share{
    //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(50, 40, 70, 70);
    [weiboBtn setImage:[UIImage imageNamed:@"sina_normal"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(WeiBoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weiboBtn];
    
    
    //朋友圈 friend
    UIButton *friendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(130, 40, 70, 70);
    [friendBtn setImage:[UIImage imageNamed:@"wx_normal-1"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendBtn];
    
    //Circle
    UIButton *circleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(210, 40, 70, 70);
    [circleBtn setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(circleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:circleBtn];
    
    //remove
    UIButton *removeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(20, 100, kWidth - 40, 44);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.blackView.alpha = 0.8;
        self.shareView.alpha = 1.0;
    }];
}

- (void)WeiBoAction{
    
}

- (void)friendAction{
    
}
- (void)circleAction{
    
}
- (void)removeAction{
    
}

- (void)login{
    
}

#pragma mark --------------- Lazy Loading
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 44) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        //        self.tableView.backgroundColor = [UIColor yellowColor];
    }
    return _tableView;
}
- (UIButton *)headImageButton{
    if (_headImageButton == nil) {
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.frame = CGRectMake(20, 40, 130, 130);
        [self.headImageButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
        [self.headImageButton setBackgroundColor:[UIColor whiteColor]];
        [self.headImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.headImageButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        self.headImageButton.layer.cornerRadius = 65;
        self.headImageButton.clipsToBounds = YES;
    }
    return _headImageButton;
}

- (UILabel *)nikeNameLable{
    if (_nikeNameLable == nil) {
        self.nikeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(180, 90, kWidth - 200, 60)];
        self.nikeNameLable.numberOfLines = 0;
        self.nikeNameLable.text = @"欢迎来到The weekend to happy";
        self.nikeNameLable.textColor = [UIColor whiteColor];
    }
    return _nikeNameLable;
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
