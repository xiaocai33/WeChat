//
//  WCLoginViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/18.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCNavigationController.h"
#import "WCRegisterViewController.h"

@interface WCLoginViewController () <WCRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置textField的背景图片
    self.pwdTextField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.pwdTextField addLeftViewWithImage:@"Card_Lock"];
    
    //设置button的背景图片
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    //设置nameLabel的显示
    self.nameLabel.text = [UserInfo sharedUserInfo].user;
    
}

/**
 *  登录
 */
- (IBAction) login{
    
    // 保存数据到单例
    UserInfo *user = [UserInfo sharedUserInfo];
    user.user = self.nameLabel.text;
    user.pwd = self.pwdTextField.text;
    
    //调用父类登录
    [super login];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // 获取注册控制器
    UINavigationController *nav = segue.destinationViewController;
    
    if ([nav.topViewController isKindOfClass:[WCRegisterViewController class]]) {
        WCRegisterViewController *registerVc = (WCRegisterViewController *)nav.topViewController;
        registerVc.delegate = self;
    }
}

#pragma mark - WCRegisterViewControllerDelegate
- (void)registerViewControllerDidFinishRegister{
    WCLog(@"完成注册");
    // 完成注册 nameLabel显示注册的用户名
    self.nameLabel.text = [UserInfo sharedUserInfo].registerName;
    
    // 提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
}


@end
