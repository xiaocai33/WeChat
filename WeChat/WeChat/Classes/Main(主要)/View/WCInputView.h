//
//  WCInputView.h
//  WeChat
//
//  Created by 小蔡 on 16/4/25.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCInputView : UIView
/** 输入框 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/** 返回xib创建的View */
+ (instancetype)inputView;
@end
