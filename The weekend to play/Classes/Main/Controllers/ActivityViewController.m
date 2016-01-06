//
//  ActivityViewController.m
//  The weekend to play
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "ActivityViewController.h"
//#import <AFNetworking/AFHTTPSessionManager.h>
#import "AFHTTPSessionManager.h"
#import <MBProgressHUD.h>
@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self showBackButton];

    [self getModel];
    
}


#pragma mark --------  Custom Method
- (void)getModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        QJZLog(@"downloadProgress = %@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        QJZLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        QJZLog(@"error = %@",error);
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
