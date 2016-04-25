//
//  AppDelegate.m
//  WeChat
//
//  Created by 小蔡 on 16/4/14.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "WCNavigationController.h"
/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */

@interface AppDelegate () <XMPPStreamDelegate>{
    XMPPStream *_stream;
    resultBlock _resultBlock;
}

// 初始化XMPPStream
- (void)setupXMPPStream;

// 连接到服务器[传一个JID]
- (void)connectToHost;

// 连接到服务成功后，再发送密码授权
- (void)sendPwdToHost;

// 授权成功后，发送"在线" 消息
- (void)sendOnlineToHost;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置所有导航控制器的样式
    [WCNavigationController setupNav];
    
    //从沙盒中加载数据到单例中
    UserInfo *user = [UserInfo sharedUserInfo];
    [user loadUserInfoFromSanbox];
    
    //判断当前的登录状态 YES的话直接跳转到主界面
    if (user.isLogin) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = story.instantiateInitialViewController;
        
        // 自动登录服务
        // 1秒后再自动登录
#warning 一般情况下，都不会马上连接，会稍微等等
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[XMPPTool sharedXMPPTool] XMPPLogin:nil];
        });
    }
    
    //设置状态栏颜色
    //[application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}



@end