//
//  WCEditTableViewController.h
//  WeChat
//
//  Created by 小蔡 on 16/4/23.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCEditTableViewController;
@protocol WCEditTableViewControllerDelegate <NSObject>

- (void)editDidCommit;

@end


@interface WCEditTableViewController : UITableViewController

@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, weak) id<WCEditTableViewControllerDelegate> delegate;
@end
