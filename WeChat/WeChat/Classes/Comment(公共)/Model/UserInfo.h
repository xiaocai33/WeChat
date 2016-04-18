//
//  UserInfo.h
//  WeChat
//
//  Created by 小蔡 on 16/4/18.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserInfo : NSObject
/** 单例 */
SingletonH(UserInfo)

/** 用户名 */
@property (nonatomic, copy) NSString *user;
/** 密码 */
@property (nonatomic, copy) NSString *pwd;

/** 保存用户数据到沙盒 */
-(void)saveUserInfoToSanbox;

/** 从沙盒里获取用户数据 */
-(void)loadUserInfoFromSanbox;

@end
