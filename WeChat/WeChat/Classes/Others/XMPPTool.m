//
//  XMPPTool.m
//  WeChat
//
//  Created by 小蔡 on 16/4/21.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "XMPPTool.h"
#import "XMPPFramework.h"
NSString *const WCLoginStatusChangeNotification = @"WCLoginStatusNotification";
/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */

@interface XMPPTool() <XMPPStreamDelegate>{
    
    resultBlock _resultBlock;
    /** 电子名片存储 */
    XMPPvCardCoreDataStorage *_vCardCoreData;
    /** 电子名片头像模块 */
    XMPPvCardAvatarModule *_vCardAvatarModule;
    //自动连接模块
    XMPPReconnect *_reconnect;
    //消息模块
    XMPPMessageArchiving *_msgArchiving;
    
    
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


@implementation XMPPTool
SingletonM(XMPPTool);

#pragma mark - 私有方法
#pragma mark - 初始化XMPPStream
- (void)setupXMPPStream{
    WCLog(@"初始化XMPPStream");
    _stream = [[XMPPStream alloc] init];
    
#warning 每一个模块添加后都要激活
    //创建电子名片模块
    _vCardCoreData = [XMPPvCardCoreDataStorage sharedInstance];
    _vCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardCoreData];
    //激活
    [_vCardModule activate:_stream];
    
    //创建头像模块并激活
    _vCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCardModule];
    [_vCardAvatarModule activate:_stream];
    
    //自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_stream];
    
    //花名册模块
    _rosterCoreData = [XMPPRosterCoreDataStorage sharedInstance];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterCoreData];
    [_roster activate:_stream];
    
    //消息模块
    _msgCoreData = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgCoreData];
    [_msgArchiving activate:_stream];
    
    //设置代理
    [_stream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}


#pragma mark 释放xmppStream相关的资源
- (void)teardownXmpp{
    
    // 移除代理
    [_stream removeDelegate:self];
    
    //停止模块
    [_vCardModule deactivate];
    [_vCardAvatarModule deactivate];
    [_reconnect deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    
    // 断开连接
    [_stream disconnect];
    
    //清空资源
    _vCardModule = nil;
    _vCardCoreData = nil;
    _vCardAvatarModule = nil;
    _reconnect = nil;
    _roster = nil;
    _rosterCoreData = nil;
    _msgArchiving = nil;
    _msgCoreData = nil;
    _stream = nil;
}



#pragma mark - 连接到服务器[传一个JID]
- (void)connectToHost{
    WCLog(@"开始连接服务器");
    
    [self setupNotification:resultBlockTypeConnet];
    
    if (!_stream) {
        [self setupXMPPStream];
    }
    
    // 设置登录用户JID
    //resource 标识用户登录的客户端 iphone android
    //从沙盒取出用户名
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *name = [defaults objectForKey:@"name"];
    
    //从单例中获取用户名
    NSString *name = nil;
    
    if (self.registerStatus) {//注册的环境下,发送注册的名字
        name = [UserInfo sharedUserInfo].registerName;
    }else{
        name = [UserInfo sharedUserInfo].user;
    }
    
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
    //    //从沙盒取出密码
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *pwd = [defaults objectForKey:@"pwd"];
    
    //从单例取出密码
    NSString *pwd = [UserInfo sharedUserInfo].pwd;
    
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
    
    //连接到服务成功后,判断当前的环境
    if (self.registerStatus) {
        NSString *registerPwd = [UserInfo sharedUserInfo].registerPwd;
        [_stream registerWithPassword:registerPwd error:nil];
    }else{
        //连接到服务成功后，再发送密码授权
        [self sendPwdToHost];
    }
}

#pragma mark - 与主机断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    WCLog(@"与主机断开连接 %@", error);
    
    if (error && _resultBlock) {
        _resultBlock(resultBlockTypeNetOut);
    }
    
    [self setupNotification:resultBlockTypeNetOut];
}

#pragma mark - 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WCLog(@"授权成功");
    
    
    if (_resultBlock) {
        _resultBlock(resultBlockTypeSuccess);
    }
    
    //授权成功后，发送"在线" 消息
    [self sendOnlineToHost];
    
    [self setupNotification:resultBlockTypeSuccess];

}

#pragma mark - 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WCLog(@"授权失败");
    
    if (_resultBlock) {
        _resultBlock(resultBlockTypeFailed);
    }
    
    [self setupNotification:resultBlockTypeFailed];

}

#pragma mark - 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    WCLog(@"注册成功");
    if (_resultBlock) {
        _resultBlock(resultBlockTypeRegisterSuccess);
    }
}
#pragma mark - 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    WCLog(@"注册失败--%@", error);
    if (_resultBlock) {
        _resultBlock(resultBlockTypeRegisterFailed);
    }
}

#pragma mark - 接收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    WCLog(@"接收到消息%@", message);
    //程序在后台的时候,需要通知
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        WCLog(@"在后台");
        
        //注册本地通知
        UILocalNotification *localNote = [[UILocalNotification alloc] init];
        
        //指定通知发送的时间
        localNote.fireDate = [NSDate date];
        
        //声音
        localNote.soundName = @"default";
        
        //内容
        localNote.alertBody = [NSString stringWithFormat:@"%@\n%@", message.fromStr, message.body];
        
        //执行通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    }
}

#pragma mark - 添加通知
/**
 * 通知 WCHistoryViewControllers 登录状态
 *
 */
- (void)setupNotification:(resultBlockType)type{
    // 将登录状态放入字典，然后通过通知传递
    NSDictionary *userInfo = @{@"loginStatus":@(type)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WCLoginStatusChangeNotification object:nil userInfo:userInfo];
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
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //self.window.rootViewController = storyboard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //4.更新用户的登录状态
    UserInfo *user = [UserInfo sharedUserInfo];
    user.isLogin = NO;
    [user saveUserInfoToSanbox];
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

#pragma make - 开始注册
- (void)XMPPRegister:(resultBlock)resultBlock{
    _resultBlock = resultBlock;
    
    //每次登录的时候,断开上一次的登录
    //否则有:Error Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo={NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    [_stream disconnect];
    
    //连接服务器
    [self connectToHost];
}

- (void)dealloc{
    [self teardownXmpp];
}


@end
