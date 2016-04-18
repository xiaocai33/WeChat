//
//  WCLoginViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/18.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCLoginViewController.h"

@interface WCLoginViewController ()
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



@end
