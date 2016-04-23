//
//  WCAddTableViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/23.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCAddTableViewController.h"

@interface WCAddTableViewController () <UITextFieldDelegate>

@end

@implementation WCAddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 1.获取好友账号
    NSString *text = textField.text;
    if ([text isEqualToString:[UserInfo sharedUserInfo].user]) {
        //[MBProgressHUD showError:@"不能添加自己" toView:self.view];
        [self showAlert:@"不能添加自己"];
        return YES;
    }
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",text,domain];
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    
    if ([[XMPPTool sharedXMPPTool].rosterCoreData userExistsWithJID:friendJid xmppStream:[XMPPTool sharedXMPPTool].stream]) {
        [self showAlert:@"好友已存在"];
        return YES;
    }
    
    // 2.发送好友添加的请求
    // 添加好友,xmpp有个叫订阅
    [[XMPPTool sharedXMPPTool].roster subscribePresenceToUser:friendJid];
    
    
    return YES;
}

-(void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}





@end
