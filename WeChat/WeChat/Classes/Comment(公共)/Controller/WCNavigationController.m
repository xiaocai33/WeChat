//
//  WCNavigationController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/14.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 设置全局的导航栏样式

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置所有导航控制器,导航栏的样式
+ (void)setupNav{
    
    //设置所有导航栏的背景
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    //设置导航栏上字体样式
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    [bar setTitleTextAttributes:dict];
    
    // 设置状态栏的样式
    // xcode5以上，创建的项目，默认的话，这个状态栏的样式由控制器决定
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}


////结果，如果控制器是由导航控制管理，设置状态栏的样式时，要在导航控制器里设置
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}


@end
