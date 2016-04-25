//
//  WCTongXunTableViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/23.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 通讯录模块

#import "WCTongXunTableViewController.h"
#import "WCMsgViewController.h"

@interface WCTongXunTableViewController () <NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_resultsContrl;
}
@property (nonatomic, strong) NSArray *friends;

@end

@implementation WCTongXunTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友列表";
    
    //获取用户好友
    [self loadFriendTwo];
    
}

- (void)loadFriendTwo{
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
    
    //查找
    _resultsContrl = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:mgeContext sectionNameKeyPath:nil cacheName:nil];
    
    _resultsContrl.delegate = self;
    
    NSError *err = nil;
    [_resultsContrl performFetch:&err];
    if (err != nil) {
        WCLog(@"%@", err);
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultsContrl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //cell.detailTextLabel.text = self.friends[indexPath.row];
    //XMPPUserCoreDataStorageObject *friend =self.friends[indexPath.row];
    XMPPUserCoreDataStorageObject *friend = _resultsContrl.fetchedObjects[indexPath.row];
    
    //    sectionNum
    //    “0”- 在线
    //    “1”- 离开
    //    “2”- 离线
    switch ([friend.sectionNum intValue]) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = friend.jidStr;
    return cell;
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
    WCLog(@"%@",self.friends);
}

#pragma mark - NSFetchedResultsControllerDelegate代理方法
#pragma mark 当数据的内容发生改变后，会调用 这个方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    WCLog(@"数据发生改变");
    //刷新表格
    [self.tableView reloadData];
}

//实现这个方法，cell往左滑就会有个delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WCLog(@"删除好友");
        XMPPUserCoreDataStorageObject *friend = _resultsContrl.fetchedObjects[indexPath.row];
        
        XMPPJID *freindJid = friend.jid;
        [[XMPPTool sharedXMPPTool].roster removeUser:freindJid];
    }
}

#pragma mark - 聊天控制器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPUserCoreDataStorageObject *friend = _resultsContrl.fetchedObjects[indexPath.row];
    
    XMPPJID *freindJid = friend.jid;

    //跳转到聊天消息界面
    [self performSegueWithIdentifier:@"MsgSegue" sender:freindJid];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[WCMsgViewController class]]) {
        
        WCMsgViewController *msgVc = (WCMsgViewController *)destVc;
        
        msgVc.friendJid = sender;
    }
}

@end
