//
//  NSString+Extension.h
//  WeChat
//
//  Created by 小蔡 on 16/4/25.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/** 根据文本内容计算文本占的高度 */
- (CGSize)sizeWithTextFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithTextFont:(UIFont *)font;
@end
