//
//  WCMsgViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/24.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCMsgViewController.h"
#import "WCInputView.h"

@interface WCMsgViewController ()

@end

@implementation WCMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView{
    //创建表格视图(UITableView)
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:tableView];
    
    //创建WCInputView
    WCInputView *inputView = [WCInputView inputView];
    [self.view addSubview:inputView];
    
    //自动布局
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //添加约束
    NSDictionary *dict = @{@"tableView":tableView, @"inputView":inputView};
    //水平方向(X 和 宽)
    NSArray *tableViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:dict];
    [self.view addConstraints:tableViewHConstraints];
    
    NSArray *inputViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:dict];
    [self.view addConstraints:inputViewHConstraints];
    
    //竖直方向(Y 和 高)
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:dict];
    [self.view addConstraints:vConstraints];
    
}






@end
