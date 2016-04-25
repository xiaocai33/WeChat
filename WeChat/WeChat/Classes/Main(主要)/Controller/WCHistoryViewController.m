//
//  WCHistoryViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/25.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCHistoryViewController.h"

@interface WCHistoryViewController()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activutyIndicatorView;

@end

@implementation WCHistoryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:WCLoginStatusChangeNotification object:nil];
}

- (void)loginStatusChange:(NSNotification *)noti{
    //回到主线程刷新界面
    dispatch_async(dispatch_get_main_queue(), ^{
        WCLog(@"%@", noti.userInfo);
        
        resultBlockType type = [noti.userInfo[@"loginStatus"] intValue];
        
        switch (type) {
            case resultBlockTypeConnet://正在连接
                [self.activutyIndicatorView startAnimating];
                self.title = @"正在连接...";
                break;
                
            case resultBlockTypeSuccess://连接成功
                [self.activutyIndicatorView stopAnimating];
                self.title = @"连接成功";
                break;
                
            case resultBlockTypeFailed://连接失败
                [self.activutyIndicatorView stopAnimating];
                self.title = @"连接失败";
                break;
                
            case resultBlockTypeNetOut://网络超时
                [self.activutyIndicatorView stopAnimating];
                self.title = @"网络超时,稍后再试";
                break;
                
            default:
                break;
        }

    });
}

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
