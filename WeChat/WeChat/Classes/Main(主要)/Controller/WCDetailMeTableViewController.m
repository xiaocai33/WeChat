//
//  WCDetailMeTableViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/22.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCDetailMeTableViewController.h"
#import "XMPPvCardTemp.h"
#import "WCEditTableViewController.h"

@interface WCDetailMeTableViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, WCEditTableViewControllerDelegate>
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
#pragma mark - UITableViewDelegate代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取单元cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 2) {
        WCLog(@"不做处理");
        return;
    }else if (cell.tag == 0){
        WCLog(@"换头像");
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
        
    }else if (cell.tag == 1){
        WCLog(@"切换控制器");
        [self performSegueWithIdentifier:@"EditedSegue" sender:cell];
    }
}

#pragma mark - UIActionSheetDelegate代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==2) {
        return;
    }
    
    UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
    
    // 设置代理
    pickController.delegate =self;
    
    // 设置允许编辑
    pickController.allowsEditing = YES;
    
    if (buttonIndex==0) {//照相
        pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
     // 显示图片选择器
    [self presentViewController:pickController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 获取图片,摄住图片
    self.headImageView.image = info[UIImagePickerControllerEditedImage];
    
    // 隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
//    //提交到服务器
    [self editDidCommit];
//    XMPPvCardTemp *myVCard = [XMPPTool sharedXMPPTool].vCardModule.myvCardTemp;
//    //头像
//    myVCard.photo = UIImagePNGRepresentation(self.headImageView.image);
//    //提交到服务器
//    [[XMPPTool sharedXMPPTool].vCardModule updateMyvCardTemp:myVCard];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id presentVc = segue.destinationViewController;
    if ([presentVc isKindOfClass:[WCEditTableViewController class]]) {
        WCEditTableViewController *editVc = (WCEditTableViewController *)presentVc;
        editVc.cell = sender;
        editVc.delegate = self;
    }
}

#pragma mark - WCEditTableViewController代理方法
- (void)editDidCommit{
    XMPPvCardTemp *myVCard = [XMPPTool sharedXMPPTool].vCardModule.myvCardTemp;
    //头像(有问题)
//    NSData *data = UIImagePNGRepresentation(self.headImageView.image);
//    //WCLog(@"%@", [data class]);
//    myVCard.photo = data;
    //昵称
    myVCard.nickname = self.nikeNameLabel.text;
    //公司
    myVCard.orgName = self.companyLabel.text;
    //部门
    if (self.orgunitLabel.text.length >0) {
        myVCard.orgUnits = @[self.orgunitLabel.text];
    }
    //职位
    myVCard.title = self.titleLabel.text;
    
    //电话
    myVCard.note = self.phoneLabel.text;
    //邮件
    myVCard.mailer = self.emailLabel.text;
    
    //提交到服务器
    [[XMPPTool sharedXMPPTool].vCardModule updateMyvCardTemp:myVCard];
    
}





@end
