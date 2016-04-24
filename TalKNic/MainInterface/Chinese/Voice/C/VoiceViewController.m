//
//  VoiceViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/20.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "VoiceViewController.h"
#import "LoginViewController.h"
#import "Voice.h"
#import "ChatViewController.h"
#import "EaseMobSDK.h"
#import "AFNetworking.h"
#import "EMMessage.h"
#import "EMConversation.h"
#import "EaseMessageViewController.h"
#import "solveJsonData.h"
#import "ViewControllerUtil.h"
#import "MBProgressHUD+MJ.h"
#import "VoiceCellModel.h"
#import "VoiceChatCell.h"
#import "CompletedChatViewController.h"
#import "MJRefresh.h"

@interface VoiceViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,IChatManagerDelegate>
{
    NSString *_myRole;
    NSString *_chatterRole;
    UIImageView *picImage;
    UIImage *photo;
    NSMutableArray *_chatter_array;
//    NSArray* _order_array;
    NSMutableArray *_array;
    NSMutableArray *_userName;
    NSMutableArray *_strPic;
    AFHTTPSessionManager *_manager;
    NSString *_chatterUid;
    
    BOOL _isOpen; //当前页是否打开
    

}
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UINavigationBar *bar;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *dateTimm;
@property (nonatomic,strong)UISearchDisplayController *searchController;
@property (nonatomic,strong)UISearchBar *searchBar;

@property (nonatomic, strong)NSMutableArray *chatListCellsArr;//聊天列表数据
@property (nonatomic, strong)NSMutableArray *userTeacherIdArr;
@end

@implementation VoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self allocArray];
    self.view.backgroundColor = [UIColor whiteColor];
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    self.navigationItem.titleView = [ViewControllerUtil SetTitle:_titleStr];
    //self.bar = [ViewControllerUtil ConfigNavigationBar:@"Audio Message" NavController: self.navigationController NavBar:self.bar];
    //[self.view addSubview:self.bar];
    
    
    [self initTableView];
    
    if(_needBack)
       [self layoutLeftBtn];
    
    //[self searchBarView];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"chineseNewMessage" object:nil];
}


-(void)layoutLeftBtn
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 10, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
}


-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  初始化数组
 */
-(void)allocArray
{
    self.chatListCellsArr = [NSMutableArray arrayWithCapacity:0];
    self.userTeacherIdArr = [NSMutableArray arrayWithCapacity:0];
}


-(void)GetChatterInformation
{
    [self.tableView.header endRefreshing];
    
    //清空数据
    if (self.chatListCellsArr != nil) {
        [self.chatListCellsArr removeAllObjects];
    }
    if (self.userTeacherIdArr != nil) {
        [self.userTeacherIdArr removeAllObjects];
    }
    
    if([[ViewControllerUtil CheckRole] isEqualToString:CHINESEUSER])
    {
        _myRole = @"user_student_id";
        _chatterRole = @"user_teacher_id";
    }
    else
    {
        _myRole = @"user_teacher_id";
        _chatterRole = @"user_student_id";
    }
    
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    dicc[@"cmd"] = @"32";
    dicc[@"role"] = [ViewControllerUtil CheckRole];
    dicc[_myRole] = _uid;
    
    //[MBProgressHUD showHUDAddedTo:self.tableView animated:NO];
    [_manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
        
        TalkLog(@"all orders info -- %@",responseObject);
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
        {
            NSArray *resultArr = [dic objectForKey:@"result"];
            for(NSDictionary *d in resultArr)
            {
                if(![self.userTeacherIdArr containsObject:[d objectForKey:_chatterRole]])
                {
                    //填充数据模型
                    VoiceCellModel *chatCellModel = [[VoiceCellModel alloc]init];
                    [chatCellModel setVoiceCellModelWith:d chatterRole:_chatterRole badgeNumber:[self getUnreadMessageCountWithUid:d[@"uid"]]];
                    
                    [self.chatListCellsArr addObject:chatCellModel];
                    
                    //记录所有聊天对象的user_teacher_id,防止数据模型里有重复数据
                    #warning FixMe 是否应根据最新支付时间筛选出最新的数据
                    [self.userTeacherIdArr addObject:[d objectForKey:_chatterRole]];
                }
            }
        }
        self.tableView.hidden = ([self.chatListCellsArr count] == 0);
        self.searchBar.hidden = ([self.chatListCellsArr count] == 0);
        if([self.chatListCellsArr count] == 0)
            [MBProgressHUD showError:@"No history message"];
        else
            [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
        NSLog(@"error%@",error);
        self.tableView.hidden = YES;
        self.searchBar.hidden = YES;
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    if(_uid.length == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAlertNotLogin message:kAlertPlsLogin preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:AppCancel style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:AppSure style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            LoginViewController* login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    if ([_titleStr isEqualToString:AppInboxMessage])
    {
        [self GetInboxMessage];
    }
    else
    {
        _isOpen = true; //记录当前页面是否打开
        [self GetChatterInformation];
    }
}

-(void)GetInboxMessage
{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    _isOpen = false;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}


/**
 *  初始化tableView
 */
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:(UITableViewStylePlain)];
//    [self.tableView registerNib:[UINib nibWithNibName:@"VoiceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self.view addSubview:_tableView];
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        //FIXME use other words than featured
        [self GetChatterInformation];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];

}


-(void)searchBarView
{
    UISearchBar *searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 129.0/2, KWidthScaled(375),KHeightScaled(44))];
    UITextField *searchField = [searchbar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor colorWithRed:125/255.0 green:194/255.0 blue:232/255.0 alpha:0.5f];
    [searchField setValue:[UIColor colorWithRed:125/255.0 green:194/255.0 blue:232/255.0 alpha:0.5f] forKeyPath:@"_placeholderLabel.textColor"];
    searchbar.delegate = self;
    searchbar.placeholder = AppSearch;
    
    self.searchBar.delegate = self;
    self.searchBar = searchbar;
    [self.view addSubview:searchbar];

    self.searchController = [[UISearchDisplayController alloc]initWithSearchBar:searchbar contentsController:self];
    self.searchController.searchResultsTableView.tableFooterView = [[UIView alloc]init];
    _searchController.searchResultsDataSource =self;
    _searchController.searchResultsDelegate =self;
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.frame = CGRectMake(0, 129.0 / 2, KWidthScaled(375), KHeightScaled(44));
    self.searchBar.alpha = 1.0f;
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.frame = CGRectMake(0, 129.0 / 2, KWidthScaled(375), KHeightScaled(44));
    self.searchBar.alpha = 1.0f;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chatListCellsArr.count ? _chatListCellsArr.count : 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        
        static NSString *voiceCellId = @"voiceCellId";
        VoiceChatCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceCellId];
        if (!voiceCell)
        {
            voiceCell = (VoiceChatCell *)[[VoiceChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceCellId];
        }
        TalkLog(@"%@", indexPath);
        if([self.chatListCellsArr count ] > indexPath.row)
            [voiceCell creatVoiceChatCellWithData:self.chatListCellsArr[indexPath.row]];
        
        return voiceCell;
        
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (80.0f);
}

-(void)GotoCompletedView:(int)row
{
    VoiceCellModel *chatCellModel = [self.chatListCellsArr objectAtIndex:row];
    NSString* order_id = chatCellModel.order_id;

    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    dicc[@"cmd"] = @"36";
    dicc[@"order_id"] = order_id;
    TalkLog(@"talker dic -- %@",dicc);
    [_manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"responseObject -- %@",responseObject);
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"] isEqualToString: SERVER_SUCCESS])
        {
            NSDictionary* res = [dic objectForKey:@"result"];
            NSString* rate = [res objectForKey:@"teacher_rate"];
            NSString* comment = [res objectForKey:@"teacher_comment"];
            if(rate.length == 0 || comment.length == 0)
            {
                CompletedChatViewController *com = [[CompletedChatViewController alloc]init];
                com.uid = _uid;
                com.chatter_uid = _chatter_array[row];
                com.order_id = order_id;
                [self.navigationController pushViewController:com animated:YES];
            }
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if([_titleStr isEqualToString:AppHistory])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

    VoiceCellModel *cellModel = self.chatListCellsArr[indexPath.row];
    
    if([ViewControllerUtil IsValidChat:cellModel.paytime msg_time: cellModel.time])
    {
        [EaseMobSDK createOneChatViewWithConversationChatter:cellModel.uid Name:cellModel.username onNavigationController:self.navigationController order_id:cellModel.order_id];
    }
    else
    {
        if([[ViewControllerUtil CheckRole] isEqualToString:CHINESEUSER])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:AppNotify message:AppConChat preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:AppCancel style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:AppSure style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //FIXME go to pay details
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            [MBProgressHUD showSuccess:@"Finished"];
        }
        
        [self GotoCompletedView:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


//- (void)newMessage:(NSNotification *)notification
//{
//    TalkLog(@"接受新消息");
//    if ([notification.object isEqualToString:@""]) {
//        self.navigationController.tabBarItem.badgeValue = nil;
//    }else{
//        self.navigationController.tabBarItem.badgeValue = notification.object;
//    }
//}


-(void)didReceiveMessage:(EMMessage *)message
{
    //    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    _chatterUid =  message.from;
    TalkLog(@"%@",_chatterUid);


    // 只有当前页打开时才能获取信息刷新tableView, 否则在其他页面时收到消息刷新tableView会造成数据为空的crash
    if (_isOpen) {
        [self GetChatterInformation];
    }
    
    /*接收到的消息的解析*/
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
            break;
        case eMessageBodyType_Image:
            break;
        case eMessageBodyType_Location:
            break;
        case eMessageBodyType_Voice:
        {
            // 音频sdk会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSInteger  *KDuration = (NSInteger *)[[user objectForKey:@"chatDuration"]integerValue];
            KDuration += body.duration;
            NSString *durationStr = [NSString stringWithFormat:@"%lu",(unsigned long)KDuration];
            [user setObject:durationStr forKey:@"chatDuration"];
        }
            break;
        case eMessageBodyType_Video:
            break;
        case eMessageBodyType_File:
            break;
            
        default:
            break;
    }
}


/**
 *  根据聊天对象的uid获取对应的未读消息数
 *
 *  @param uid 聊天对象的uid
 *
 *  @return int 消息数量
 */
- (NSString *)getUnreadMessageCountWithUid:(NSString *)uid{
    
    NSDictionary *messageDic = [[NSUserDefaults standardUserDefaults] objectForKey:EaseMobUnreaderMessageCount];

    int count = 0;
    if (messageDic && [messageDic objectForKey:uid]) {
        count = [[messageDic objectForKey:uid] intValue];
    }
    
    return [NSString stringWithFormat:@"%d", count >= 0 ? count : 0];
}


//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    self.searchBar.frame = kCGRectMake(0, 20, 375, 44);
//
////    _tableView.frame = kCGRectMake(0, 70, 375, 667 - 70);
//
//
//    self.searchBar.alpha = 1.0f;
//    NSLog(@"_+++++)((");
//}
//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    self.searchBar.frame = kCGRectMake(0, 64, 375, 44);
////    _tableView.frame = kCGRectMake(0, 70, 375, 667 - 70);
//    self.searchBar.alpha = 1.0f;
//
//
//}
//
//- (void)setImage:(nullable UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state
//{
//    [self.searchBar setSearchFieldBackgroundImage:
//     [UIImage imageNamed:@"search_icon.png"]forState:UIControlStateNormal];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
