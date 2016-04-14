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
    self.navigationController.title = @"其他登录方式";
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.nameText.text forKey:@"name"];
    [defaults setObject:self.pwdText.text forKey:@"pwd"];

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
    //modal出来的控制器,在跳转的时候,一定要注销掉 否则会引起循环引用
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 登录成功来到主界面
    // 此方法是在子线程补调用，所以在主线程刷新UI
    UIStoryboard *mainStroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = mainStroy.instantiateInitialViewController;
}

@end
