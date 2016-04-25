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
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@end

@implementation WCMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    //监听键盘改变的通知
    //键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘即将隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 键盘即将出现 */
- (void)keyboardWillShow:(NSNotification *)info{
    //获取键盘的高度
    CGRect endKeyborad = [info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat heightKeyborad = endKeyborad.size.height;
    
    //竖屏{{0, 0}, {768, 264}
    //横屏{{0, 0}, {352, 1024}}
    // 如果是ios7以下的，当屏幕是横屏，键盘的高底是size.with
    //UIInterfaceOrientationIsLandscape(self.interfaceOrientation)是否为横屏
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        heightKeyborad = endKeyborad.size.width;
    }
    
    self.bottomConstraint.constant = heightKeyborad;
    
}

/** 键盘即将隐藏 */
- (void)keyboardWillHide{
    self.bottomConstraint.constant = 0;
}

/** 初始化控件界面 */
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
    self.bottomConstraint = [vConstraints lastObject];
    
}






@end
