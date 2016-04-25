//
//  WCMsgCell.m
//  WeChat
//
//  Created by 小蔡 on 16/4/25.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCMsgCell.h"

@implementation WCMsgCell

+ (instancetype)createMsgCell:(UITableView *)tableView{
    static NSString *ID = @"cell";
    WCMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WCMsgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
}

- (void)setText:(NSString *)text{
    _text = [text copy];
    //设置cell显示字体的font
    UIFont *textFont = [UIFont systemFontOfSize:17];
    self.textLabel.font = textFont;
    //允许换行
    self.textLabel.numberOfLines = 0;
    //计算文本高度
    CGSize textSize = [text sizeWithTextFont:textFont maxW:self.width];
    CGFloat height = textSize.height;

    self.heightCell = height;
}

@end
