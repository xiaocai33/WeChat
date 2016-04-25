//
//  WCMsgViewController.m
//  WeChat
//
//  Created by 小蔡 on 16/4/24.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "WCMsgViewController.h"
#import "WCInputView.h"
#import "XMPPJID.h"

@interface WCMsgViewController ()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSFetchedResultsController *_resultController;
}
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation WCMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //布局界面
    [self setupView];
    
    //监听键盘改变的通知
    //键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘即将隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    //加载数据
    [self loadMsg];
}

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 键盘即将出现 */
- (void)keyboardWillShow:(NSNotification *)info{
    //获取键盘的高度
    CGRect endKeyborad = [info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat heightKeyborad = endKeyborad.size.height;
    
    //竖屏{{0, 0}, {768, 264}
    //横屏{{0, 0}, {352, 1024}}
    // 如果是ios7以下的，当屏幕是横屏，键盘的高底是size.with
    //UIInterfaceOrientationIsLandscape(self.interfaceOrientation)是否为横屏
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        heightKeyborad = endKeyborad.size.width;
    }
    
    self.bottomConstraint.constant = heightKeyborad;
    
    //表格滚动到底部
    [self scrollToBottom];
}

/** 键盘即将隐藏 */
- (void)keyboardWillHide{
    self.bottomConstraint.constant = 0;
}

/** 初始化控件界面 */
- (void)setupView{
    //创建表格视图(UITableView)
    UITableView *tableView = [[UITableView alloc] init];
    //tableView.backgroundColor = [UIColor greenColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //创建WCInputView
    WCInputView *inputView = [WCInputView inputView];
    [self.view addSubview:inputView];
    
    //自动布局
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //添加约束
    NSDictionary *dict = @{@"tableView":tableView, @"inputView":inputView};
    //水平方向(X 和 宽)
    NSArray *tableViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:dict];
    [self.view addConstraints:tableViewHConstraints];
    
    NSArray *inputViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:dict];
    [self.view addConstraints:inputViewHConstraints];
    
    //竖直方向(Y 和 高)
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:dict];
    [self.view addConstraints:vConstraints];
    self.bottomConstraint = [vConstraints lastObject];
    
}

#pragma mark - 加载XMPPMessageArchiving数据库的数据显示在表格
/**
 *  加载数据
 */
- (void)loadMsg{
    //获取上下文
    NSManagedObjectContext *context = [XMPPTool sharedXMPPTool].msgCoreData.mainThreadManagedObjectContext;
    
    //查询数据
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //设置过滤条件
    // 1.当前登录用户的JID的消息
    // 2.好友的Jid的消息
    NSString *jid = [UserInfo sharedUserInfo].jid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@", jid, self.friendJid.bare];
    request.predicate = predicate;
    
    //设置排序(时间升序)
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    //查询结果
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _resultController.delegate = self;
    
    NSError *err = nil;
    [_resultController performFetch:&err];
    if (err) {
        WCLog(@"%@",err);
    }
    
}

#pragma mark - NSFetchedResultsControllerDelegate代理方法
#pragma mark 当数据的内容发生改变后，会调用 这个方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //刷新数据
    [self.tableView reloadData];
    //表格滚动到底部
    [self scrollToBottom];
}

#pragma mark - UITableViewDataSouce数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultController.fetchedObjects[indexPath.row];
    //显示消息
    if ([msg.outgoing boolValue]) {//自己发
        cell.textLabel.text = [NSString stringWithFormat:@"Me: %@", msg.body];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"Other: %@", msg.body];
    }
    return cell;
}

#pragma mark 滚动到底部
/** 当数据超出文本框的时候,上移 */
- (void)scrollToBottom{
    NSInteger lastIndex = _resultController.fetchedObjects.count - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastIndex inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


@end
