//
//  WCMsgCell.h
//  WeChat
//
//  Created by 小蔡 on 16/4/25.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCMsgCell : UITableViewCell
/** 创建cell */
+ (instancetype)createMsgCell:(UITableView *)tableView;
/** 每个cell的高度 */
@property (nonatomic, assign) CGFloat heightCell;

@property (nonatomic, copy) NSString *text;
@end
