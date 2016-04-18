//
//  WCRegisterViewController.h
//  WeChat
//
//  Created by 小蔡 on 16/4/18.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCRegisterViewController;
@protocol WCRegisterViewControllerDelegate <NSObject>

/**
 *  完成注册
 */
-(void)registerViewControllerDidFinishRegister;

@end

@interface WCRegisterViewController : UIViewController

@property (nonatomic, weak) id<WCRegisterViewControllerDelegate> delegate;

@end
