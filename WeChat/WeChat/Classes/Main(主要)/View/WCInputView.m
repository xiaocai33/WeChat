//
//  WCInputView.m
//  WeChat
//
//  Created by 小蔡 on 16/4/25.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCInputView.h"

@implementation WCInputView

+ (instancetype)inputView{
    //返回xib创建的view
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:nil options:nil] lastObject];
}

@end
