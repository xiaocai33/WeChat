//
//  XMPPTool.h
//  WeChat
//
//  Created by 小蔡 on 16/4/21.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 用于处理xmpp相关的交互

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"
extern NSString *const WCLoginStatusChangeNotification;

typedef enum{
    resultBlockTypeSuccess = 0,//登录成功
    resultBlockTypeFailed,//登录失败
    resultBlockTypeNetOut, //登录超时
    resultBlockTypeRegisterSuccess, //注册成功
    resultBlockTypeRegisterFailed, //注册失败
    resultBlockTypeConnet //正在连接中...
} resultBlockType;

typedef void (^resultBlock)(resultBlockType type);

@interface XMPPTool : NSObject
SingletonH(XMPPTool);
/**
 *  当前的操作  注册or登录
 */
@property (nonatomic, assign, getter=isRegister) BOOL registerStatus;

/** 电子名片模块 */
@property (nonatomic, strong) XMPPvCardTempModule *vCardModule;
/** 花名册模块 */
@property (nonatomic, strong) XMPPRoster *roster;
@property (nonatomic, strong)XMPPRosterCoreDataStorage *rosterCoreData;
/** 消息模块 */
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *msgCoreData;

@property (nonatomic, strong) XMPPStream *stream;
/**
 *  退出登录
 */
- (void)XMPPLogout;

/**
 *  开始登录
 */
- (void)XMPPLogin:(resultBlock)resultBlock;

/**
 *  开始注册
 */
- (void)XMPPRegister:(resultBlock)resultBlock;
@end
