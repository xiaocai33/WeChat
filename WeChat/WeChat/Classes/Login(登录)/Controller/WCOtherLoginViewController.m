//
//  WCOtherLoginViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/14.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCOtherLoginViewController.h"

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
}


@end
