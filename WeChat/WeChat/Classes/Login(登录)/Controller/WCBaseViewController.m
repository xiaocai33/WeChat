//
//  WCBaseViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/18.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCBaseViewController.h"
#import "AppDelegate.h"

@interface WCBaseViewController ()

@end

@implementation WCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) login{
    //提示用户正在登录
    [MBProgressHUD showMessage:@"正在登录..." toView:self.view];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    [app XMPPLogin:^(resultBlockType type) {
        [weakSelf handWithResultType:type];
    }];

}

/**
 *  根据返回结果,处理
 */
- (void)handWithResultType:(resultBlockType)type{
    // 主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //移除蒙版
        [MBProgressHUD hideHUDForView:self.view];
        
        switch (type) {
            case resultBlockTypeSuccess:
                WCLog(@"登录成功");
                [self enterMainController];
                break;
            case resultBlockTypeFailed:
                [MBProgressHUD showError:@"用户名或密码错误"];
                WCLog(@"登录失败");
                break;
            case resultBlockTypeNetOut:
                WCLog(@"网络超时");
                [MBProgressHUD showError:@"网络超时"];
                break;
                
            default:
                break;
        }
    });
}
/**
 *  跳转到主控制器
 */
- (void)enterMainController{
    //登录成功存沙盒
    UserInfo *user = [UserInfo sharedUserInfo];
    // 更改用户的登录状态为YES
    user.isLogin = YES;
    //登录成功存沙盒
    [user saveUserInfoToSanbox];
    
    //modal出来的控制器,在跳转的时候,一定要dismiss掉 否则会引起循环引用
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 登录成功来到主界面
    // 此方法是在子线程补调用，所以在主线程刷新UI
    UIStoryboard *mainStroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = mainStroy.instantiateInitialViewController;
}

@end
