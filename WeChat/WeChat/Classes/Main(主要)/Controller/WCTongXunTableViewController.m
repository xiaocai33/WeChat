//
//  WCTongXunTableViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/23.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 通讯录模块

#import "WCTongXunTableViewController.h"

@interface WCTongXunTableViewController ()
@property (nonatomic, strong) NSArray *friends;

@end

@implementation WCTongXunTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友列表";
    
    //获取用户好友
    [self loadFriend];
    
}
/**
 *  获取好友通讯录
 */
- (void)loadFriend{
    //获取数据上下文
    NSManagedObjectContext *mgeContext = [XMPPTool sharedXMPPTool].rosterCoreData.mainThreadManagedObjectContext;
    
    //查询数据
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //设置过滤条件,查找登录的好友列表
    NSString *jid = [UserInfo sharedUserInfo].jid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", jid];
    fetchRequest.predicate = predicate;
    
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    //逐个查找
    self.friends = [mgeContext executeFetchRequest:fetchRequest error:nil];
    NSLog(@"%@",self.friends);
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //cell.detailTextLabel.text = self.friends[indexPath.row];
    XMPPUserCoreDataStorageObject *friend =self.friends[indexPath.row];
    cell.textLabel.text = friend.jidStr;
    return cell;
}


@end
