//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/18.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCRegisterViewController.h"
#import "AppDelegate.h"

@interface WCRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    //判断当前设备
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){//IPhone设备
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
    }
    
    //设置textField的背景图片
    self.nameText.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdText.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    //设置button的背景图片
    [self.registerBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}


- (IBAction)registerBtnClick {
    [self.view endEditing:YES];
    
    // 判断用户输入的是否为手机号码
    if (![self.nameText isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
        self.nameText.text = nil;
        self.pwdText.text = nil;
        return;
    }
    
    //保存单例
    UserInfo *user = [UserInfo sharedUserInfo];
    user.registerName = self.nameText.text;
    user.registerPwd = self.pwdText.text;
    
    XMPPTool *tool = [XMPPTool sharedXMPPTool];
    tool.registerStatus = YES;
    
    //添加蒙版
    [MBProgressHUD showMessage:@"正在注册..." toView:self.view];
    
    __weak typeof(self) weakSelf = self;
    [tool XMPPRegister:^(resultBlockType type) {
        [weakSelf handWithResultType:type];
    }];
    
}

/**
 *  根据返回结果,处理
 */
- (void)handWithResultType:(resultBlockType)type{
    //在主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //移除蒙版
        [MBProgressHUD hideHUDForView:self.view];
        
        switch (type) {
            case resultBlockTypeRegisterSuccess:
                WCLog(@"注册成功");
                //回到上一个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                //实现代理
                if ([self.delegate respondsToSelector:@selector(registerViewControllerDidFinishRegister)]) {
                    [self.delegate registerViewControllerDidFinishRegister];
                }
                
                break;
            case resultBlockTypeRegisterFailed:
                [MBProgressHUD showError:@"用户名已存在"];
                WCLog(@"注册失败");
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textChange {
    
    BOOL status = (self.nameText.text.length != 0 && self.pwdText.text.length != 0);
    self.registerBtn.enabled = status;
}


@end
