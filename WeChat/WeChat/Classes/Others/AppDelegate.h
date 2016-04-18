//
//  AppDelegate.h
//  WeChat
//
//  Created by 小蔡 on 16/4/14.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    resultBlockTypeSuccess = 0,//登录成功
    resultBlockTypeFailed,//登录失败
    resultBlockTypeNetOut, //登录超时
    resultBlockTypeRegisterSuccess, //注册成功
    resultBlockTypeRegisterFailed //注册失败
} resultBlockType;

typedef void (^resultBlock)(resultBlockType type);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign, getter=isRegister) BOOL registerStatus;

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

