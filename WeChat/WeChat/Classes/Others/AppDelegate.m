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
    
    //设置状态栏颜色
    //[application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

#pragma mark - 私有方法
#pragma mark - 初始化XMPPStream
- (void)setupXMPPStream{
    WCLog(@"初始化XMPPStream");
    _stream = [[XMPPStream alloc] init];
    
    //设置代理
    [_stream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark - 连接到服务器[传一个JID]
- (void)connectToHost{
    WCLog(@"开始连接服务器");
    
    if (!_stream) {
        [self setupXMPPStream];
    }
    
    // 设置登录用户JID
    //resource 标识用户登录的客户端 iphone android
    //从沙盒取出用户名
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name"];
    
    XMPPJID *myJID = [XMPPJID jidWithUser:name domain:@"xiaocai.local" resource:@"iphone"];
    _stream.myJID = myJID;
    
    // 设置服务器域名
    _stream.hostName = @"xiaocai.local";//不仅可以是域名，还可是IP地址
    
    // 设置端口 如果服务器端口是5222，可以省略
    _stream.hostPort = 5222;
    
    //连接
    NSError *err = nil;
    if (![_stream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        WCLog(@"%@",err);
    }
    
}

#pragma mark - 发送密码授权
- (void)sendPwdToHost{
    WCLog(@"再发送密码授权");
    //从沙盒取出密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pwd = [defaults objectForKey:@"pwd"];
    
    NSError *err = nil;
    [_stream authenticateWithPassword:pwd error:&err];
    
    if (err) {
        WCLog(@"%@",err);
    }
}

#pragma mark - 授权成功后，发送"在线" 消息
- (void)sendOnlineToHost{
    WCLog(@"发送\"在线\" 消息");
    XMPPPresence *predicate = [XMPPPresence presence];
    [_stream sendElement:predicate];
}

#pragma mark - XMPPStreamDelegate代理方法

#pragma mark - 与主机连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    WCLog(@"与主机连接成功");
    
    //连接到服务成功后，再发送密码授权
    [self sendPwdToHost];
}

#pragma mark - 与主机断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    WCLog(@"与主机断开连接 %@", error);
    
    if (error && _resultBlock) {
        _resultBlock(resultBlockTypeNetOut);
    }
   
    
}

#pragma mark - 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WCLog(@"授权成功");
    
    if (_resultBlock) {
        _resultBlock(resultBlockTypeSuccess);
    }
    
    //授权成功后，发送"在线" 消息
    [self sendOnlineToHost];
}

#pragma mark - 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WCLog(@"授权失败");
    
    if (_resultBlock) {
        _resultBlock(resultBlockTypeFailed);
    }
}

#pragma mark - 公共方法
#pragma make - 退出登陆
- (void)XMPPLogout{
    //发送离线信息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_stream sendElement:offline];
    
    //与服务器断开连接
    [_stream disconnect];
    
    // 3. 回到登录界面
    //跳转控制器
    //dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
    //});
}

#pragma make - 开始登陆
- (void)XMPPLogin:(resultBlock)resultBlock{
    _resultBlock = resultBlock;
    
    //每次登录的时候,断开上一次的登录
    //否则有:Error Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo={NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    [_stream disconnect];
    
    //连接服务器
    [self connectToHost];
    
}



@end