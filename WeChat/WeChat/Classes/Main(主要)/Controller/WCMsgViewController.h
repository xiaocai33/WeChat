//
//  WCMsgViewController.h
//  WeChat
//
//  Created by 小蔡 on 16/4/24.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPJID;
@interface WCMsgViewController : UIViewController
/** 好友的JID */
@property (nonatomic, strong) XMPPJID *friendJid;

@end
