//
//  WCOtherLoginViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/14.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"


@interface WCOtherLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"其他方式登录";
    
    //判断当前设备
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){//IPhone设备
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
    }
    
    //设置textField的背景图片
    self.nameText.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdText.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    //设置button的背景图片
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
}

- (IBAction)loginWeChat {
    /*
     * 官方的登录实现
     
     * 1.把用户名和密码放在沙盒
     
     
     * 2.调用 AppDelegate的一个login 连接服务并登录
     */
    
    //1.把用户名和密码放在沙盒
    
    // 保存数据到单例
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.user = self.nameText.text;
    userInfo.pwd = self.pwdText.text;
    
    //调用父类登录
    [super login];


}

/**
 *  取消
 */
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    WCLog(@"%s", __func__);
}

//- (IBAction)loginWeChat {
//    /*
//     * 官方的登录实现
//     
//     * 1.把用户名和密码放在沙盒
//     
//     
//     * 2.调用 AppDelegate的一个login 连接服务并登录
//     */
//    
//    //1.把用户名和密码放在沙盒
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:self.nameText.text forKey:@"name"];
//    [defaults setObject:self.pwdText.text forKey:@"pwd"];
//    
//    //提示用户正在登录
//    [MBProgressHUD showMessage:@"正在登录..." toView:self.view];
//    
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    
//    //防止循环引用
//    __weak typeof(self) weakSelf = self;
//    [app XMPPLogin:^(resultBlockType type) {
//        [weakSelf handWithResultType:type];
//    }];
//}

@end
