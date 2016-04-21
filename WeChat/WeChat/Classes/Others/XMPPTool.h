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
typedef enum{
    resultBlockTypeSuccess = 0,//登录成功
    resultBlockTypeFailed,//登录失败
    resultBlockTypeNetOut, //登录超时
    resultBlockTypeRegisterSuccess, //注册成功
    resultBlockTypeRegisterFailed //注册失败
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
