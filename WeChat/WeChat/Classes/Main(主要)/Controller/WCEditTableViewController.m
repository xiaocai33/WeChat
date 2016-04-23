//
//  WCEditTableViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/23.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCEditTableViewController.h"

@interface WCEditTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


@end

@implementation WCEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题和TextField的默认值
    self.title = self.cell.textLabel.text;
    
    self.nameTextField.text = self.cell.detailTextLabel.text;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    
}

- (void)btnClick{
    // 1.更改Cell的detailTextLabel的text
    self.cell.detailTextLabel.text = self.nameTextField.text;
    
    [self.cell layoutSubviews];
    
    //销毁控制器
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(editDidCommit)]) {
        [self.delegate editDidCommit];
    }
}





@end
