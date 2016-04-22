//
//  WCDetailMeTableViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/22.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCDetailMeTableViewController.h"
#import "XMPPvCardTemp.h"

@interface WCDetailMeTableViewController ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLabel;
/** 微信号 */
@property (weak, nonatomic) IBOutlet UILabel *weixinNum;
/** 公司 */
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
/** 部门 */
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;
/** 职称 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 电话 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/** 邮箱 */
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation WCDetailMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    //显示人个信息
    
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard = [XMPPTool sharedXMPPTool].vCardModule.myvCardTemp;
    //头像
    if (myVCard.photo) {
        self.headImageView.image = [UIImage imageWithData:myVCard.photo];
    }
    //昵称
    self.nikeNameLabel.text = myVCard.nickname;
    //微信号
    self.weixinNum.text = [UserInfo sharedUserInfo].user;
    //公司
    self.companyLabel.text = myVCard.orgName;
    //部门
    if (myVCard.orgUnits.count > 0) {
        self.orgunitLabel.text = [myVCard.orgUnits firstObject];
    }
    //职位
    self.titleLabel.text = myVCard.title;
    //电话
#warning myVCard.telecomsAddresses 这个get方法，没有对电子名片的xml数据进行解析
    // 使用note字段充当电话
    self.phoneLabel.text = myVCard.note;
    
    //邮件
    // 用mailer充当邮件
    self.emailLabel.text = myVCard.mailer;
    

}





@end
