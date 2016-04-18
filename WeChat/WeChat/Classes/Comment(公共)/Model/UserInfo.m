//
//  UserInfo.m
//  WeChat
//
//  Created by 小蔡 on 16/4/18.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "UserInfo.h"
#define userKey @"user"
#define pwdKey @"pwd"

@implementation UserInfo

SingletonM(UserInfo)

//存数据
- (void)saveUserInfoToSanbox{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.user forKey:userKey];
    [userDefaults setObject:self.pwd forKey:pwdKey];
    [userDefaults synchronize];
}

//取数据
- (void)loadUserInfoFromSanbox{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.user = [userDefaults objectForKey:userKey];
    self.pwd = [userDefaults objectForKey:pwdKey];
}

@end
