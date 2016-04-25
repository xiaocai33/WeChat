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
#import "WCMsgCell.h"

@interface WCMsgViewController ()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>{
    NSFetchedResultsController *_resultController;
}
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

@property (nonatomic, strong) NSLayoutConstraint *inputViewHeightConstraint;

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
    inputView.textView.delegate = self;
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
    self.inputViewHeightConstraint = vConstraints[2];
    
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
    WCMsgCell *cell = [WCMsgCell createMsgCell:tableView];
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultController.fetchedObjects[indexPath.row];
    //显示消息
    NSString *text = nil;
    if ([msg.outgoing boolValue]) {//自己发
        text = [NSString stringWithFormat:@"Me: %@", msg.body];
    }else{
        text = [NSString stringWithFormat:@"Other: %@", msg.body];
    }
    cell.text = text;
    
    cell.textLabel.text = text;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultController.fetchedObjects[indexPath.row];
    return [msg.body sizeWithTextFont:[UIFont systemFontOfSize:17] maxW:self.view.width].height +15;
}

#pragma mark 滚动到底部
/** 当数据超出文本框的时候,上移 */
- (void)scrollToBottom{
    NSInteger lastIndex = _resultController.fetchedObjects.count - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastIndex inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITextView的代理方法(发消息)
- (void)textViewDidChange:(UITextView *)textView{
    //设置字体
    textView.font = [UIFont systemFontOfSize:16];
    NSString *text = textView.text;
    //计算高度
    CGFloat contentH = [text sizeWithTextFont:[UIFont systemFontOfSize:16] maxW:textView.width].height;
    
    // 大于33，超过一行的高度/ 小于68 高度是在三行内
    if (contentH > 33 && contentH < 64 ) {
        self.inputViewHeightConstraint.constant = contentH + 18;
    }
    
    
    
    if ([textView.text containsString:@"\n"]) {//发送消息

        // 去除换行字符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //发送消息
        [self sendMsg:text withType:@"text"];
        //清空文本框
        textView.text = nil;
        self.inputViewHeightConstraint.constant = 50;
    }
}
#pragma marl - 发送消息
- (void)sendMsg:(NSString *)text withType:(NSString *)type{
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    [msg addAttributeWithName:@"bodyType" stringValue:type];
    
    [msg addBody:text];
    
    [[XMPPTool sharedXMPPTool].stream sendElement:msg];
}


@end
