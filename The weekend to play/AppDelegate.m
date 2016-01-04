//
//  AppDelegate.m
//  The weekend to play
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    //UITableBarController
    UITabBarController *tablBarVC = [[UITabBarController alloc] init];
    //创建被tabBarVC管理的视图控制器
    
    //主页
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *mainNav = mainStoryBoard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic.png"];
    
    UIImage *mainselectImage = [UIImage imageNamed:@"ft_home_selected_ic"];
    //tabBar设置选中图片按照图片原始状态显示
    mainNav.tabBarItem.selectedImage = [mainselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //调整tabBar图片显示位置：按照上，下，左，右的顺序设置
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    //发现
    UIStoryboard *discoverStoryBoard = [UIStoryboard storyboardWithName:@"DiscoverStoryboard" bundle:nil];
    UINavigationController *discoverNav = discoverStoryBoard.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic.png"];
    
    UIImage *discoverselectImage = [UIImage imageNamed:@"ft_found_selected_ic"];
    //tabBar设置选中图片按照图片原始状态显示
    discoverNav.tabBarItem.selectedImage = [discoverselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    //我的
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    UINavigationController *mineNav = mineStoryBoard.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic.png"];
    
    UIImage *mineselectImage = [UIImage imageNamed:@"ft_person_selected_ic"];
    //tabBar设置选中图片按照图片原始状态显示
    mineNav.tabBarItem.selectedImage = [mineselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tablBarVC.tabBar.barTintColor = [UIColor whiteColor];
    
    
    
    //添加被管理的试图控制器
    tablBarVC.viewControllers = @[mainNav,discoverNav,mineNav];
    self.window.rootViewController = tablBarVC;
    
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
