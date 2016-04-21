//
//  WCMeTableController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/14.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCMeTableController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"

@interface WCMeTableController ()
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/** 用户昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 用户账号 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation WCMeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加注销按钮
    UIBarButtonItem *logoutBtn = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logoutBtnClick)];
    self.navigationItem.rightBarButtonItem = logoutBtn;
    
    //设置用户账号名称
    NSString *name = [NSString stringWithFormat:@"微信号:%@",[UserInfo sharedUserInfo].user];
    self.phoneLabel.text = name;
    
    // 显示当前用户个人信息
    
    // 如何使用CoreData获取数据
    // 1.上下文【关联到数据】
    
    // 2.FetchRequest
    
    // 3.设置过滤和排序
    
    // 4.执行请求获取数据
    
    //xmpp提供了一个方法，直接获取个人信息
    //获取电子名片信息
    XMPPvCardTemp *myvCard = [XMPPTool sharedXMPPTool].vCardModule.myvCardTemp;
    self.nameLabel.text = myvCard.nickname;
    
    if (myvCard.photo) {
        self.headImageView.image = [UIImage imageWithData:myvCard.photo];
    }
    
    
}

/**
 *  注销
 */
- (void)logoutBtnClick{
    
    XMPPTool *tool = [XMPPTool sharedXMPPTool];
    
    [tool XMPPLogout];
}





@end
