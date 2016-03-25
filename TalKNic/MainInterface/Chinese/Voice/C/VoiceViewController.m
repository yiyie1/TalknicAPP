//
//  VoiceViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/20.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "VoiceViewController.h"
#import "VoiceCell.h"
#import "VoiceCell.h"
#import "Voice.h"
#import "ChatViewController.h"
#import "EaseMobSDK.h"
#import "AFNetworking.h"
#define EaseMobb @"https://a1.easemob.com/bws/talknic"
#import "EMMessage.h"
#import "EMConversation.h"
#import "EaseMessageViewController.h"
#import "solveJsonData.h"
#import "ViewControllerUtil.h"
#import "MBProgressHUD+MJ.h"

@interface VoiceViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,IChatManagerDelegate>
{
    //时间
    NSString * _dateTime;
    //星期
    NSString * _weeK;
    NSString * _dateTim;
    NSString * _weekDateTime;
    NSString *fUid;
    NSDictionary *dic;
    UIImageView *picImage;
    UIImage *photo;
    NSMutableArray *_teacher_array;
    NSArray* _order_array;
    NSMutableArray *_reordered_order_array;
    NSMutableArray *_array;
    NSMutableArray *_userName;
    NSMutableArray *_strPic;
    ViewControllerUtil *_vcUtil;
    AFHTTPSessionManager *_manager;
}
@property (nonatomic,strong)UINavigationBar *bar;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *dateTimm;
@property (nonatomic,strong)UISearchDisplayController *searchController;
@property (nonatomic,strong)UISearchBar *searchBar;
@end

@implementation VoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    _vcUtil = [[ViewControllerUtil alloc]init];
    self.navigationItem.titleView = [_vcUtil SetTitle:@"Audio Message"];
    //self.bar = [_vcUtil ConfigNavigationBar:@"Audio Message" NavController: self.navigationController NavBar:self.bar];
    //[self.view addSubview:self.bar];
    //[self GetForeignerInformation];
    
    [self messageView];
    //[self searchBarView];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"chineseNewMessage" object:nil];
}

-(void)allocArray
{
    if(!_array)
        _array = [[NSMutableArray alloc]init];
    else
        [_array removeAllObjects];
    
    if(!_userName)
        _userName = [[NSMutableArray alloc]init];
    else
        [_userName removeAllObjects];
    
    if(!_strPic)
        _strPic = [[NSMutableArray alloc]init];
    else
        [_strPic removeAllObjects];
    
    if(!_teacher_array)
        _teacher_array = [[NSMutableArray alloc]init];
    else
        [_teacher_array removeAllObjects];
    
    if(!_reordered_order_array)
        _reordered_order_array = [[NSMutableArray alloc]init];
    else
        [_reordered_order_array removeAllObjects];
    
}

-(void)GetForeignerInformation
{
    [self allocArray];
    
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    dicc[@"cmd"] = @"32";
    dicc[@"role"] = [_vcUtil CheckRole];
    dicc[@"user_student_id"] = _uid;
    [_manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"all orders info -- %@",responseObject);
        dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
        {
            _order_array = [dic objectForKey:@"result"];
            //FIXME the sequence of chat should be in order
            for(NSDictionary *d in _order_array)
            {
                if(![_array containsObject:[d objectForKey:@"user_teacher_id"]])
                {
                    [_array addObject: [d objectForKey:@"user_teacher_id"]];
                    
                    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                    dicc[@"cmd"] = @"19";
                    dicc[@"user_id"] = [d objectForKey:@"user_teacher_id"];
                    [_manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        TalkLog(@"teacher info -- %@",responseObject);
                        dic = [solveJsonData changeType:responseObject];
                        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
                        {
                            NSDictionary *dict = [dic objectForKey:@"result"];
                            [_userName addObject:[dict objectForKey:@"username"]];
                            [_strPic addObject:[dict objectForKey:@"pic"]];
                            [_teacher_array addObject:[dict objectForKey:@"uid"]];
                            
                            //FIXME better algorithm to order the order array
                            for(int i = 0; i < [_array count]; ++i)
                            {
                                if([[dict objectForKey:@"uid"] isEqualToString:_array[i]])
                                {
                                    [_reordered_order_array addObject:_order_array[i]];
                                }
                            }
                            
                            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
                            [picImage sd_setImageWithURL:url placeholderImage:nil];
                            photo = picImage.image;
                            [self.tableView reloadData];
                        }
                        else
                        {
                            [MBProgressHUD showError:kAlertdataFailure];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"error%@",error);
                        self.tableView.hidden = YES;
                        self.searchBar.hidden = YES;
                        [MBProgressHUD showError:kAlertNetworkError];
                    }];
                }
            }

        }
        self.tableView.hidden = ([_array count] == 0);
        self.searchBar.hidden = ([_array count] == 0);
        if([_array count] == 0)
            [MBProgressHUD showError:@"No history message"];
        //else
        //    [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    
    [self GetForeignerInformation];
}

-(void)messageView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0/*129.0/2 + KHeightScaled(44)*/, kWidth, kHeight) style:(UITableViewStylePlain)];
    [self.tableView registerNib:[UINib nibWithNibName:@"VoiceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
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
    
    //    [self.searchBar setSearchFieldBackgroundImage:
    //     [UIImage imageNamed:@"search_icon.png"]forState:UIControlStateNormal];
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
    return [_userName count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        VoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.userName.text = _userName[indexPath.row];
        TalkLog(@"%@: %@", indexPath, _userName[indexPath.row]);
        
        cell.userMessage.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];

        cell.uid = _teacher_array[indexPath.row];
        NSString* strPic = _strPic[indexPath.row];
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:strPic]];
        cell.backgroundColor = [UIColor whiteColor];
        
        NSDictionary *order_dic = _reordered_order_array[indexPath.row];
        if([_vcUtil IsValidChat:[order_dic objectForKey:@"paytime"] msg_time: [order_dic objectForKey:@"time"]])
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
            cell.date.text = dateString;
            cell.date.textColor = [UIColor blackColor];
            
            cell.userName.textColor = [UIColor blackColor];
            cell.userMessage.textColor = [UIColor blackColor];
            cell.userMessage.text = @"Audio message!";
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_select_area_bg.png"]];
        }
        else
        {
            cell.userName.textColor = [UIColor grayColor];
            cell.userMessage.text = @"Overtime!";
            cell.userMessage.textColor = [UIColor grayColor];
        }
        return cell;
        
    }else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KHeightScaled(88.5);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSDictionary *order_dic = _reordered_order_array[indexPath.row];
    if([_vcUtil IsValidChat:[order_dic objectForKey:@"paytime"] msg_time: [order_dic objectForKey:@"time"]])
    {
        [EaseMobSDK createOneChatViewWithConversationChatter:_teacher_array[indexPath.row] Name:_userName[indexPath.row] onNavigationController:self.navigationController order_id:[order_dic objectForKey:@"order_id"]];
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:AppNotify message:AppConChat delegate:self cancelButtonTitle:AppSure otherButtonTitles:nil];
        [alert show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)newMessage:(NSNotification *)notification
{
    TalkLog(@"接受新消息");
    if ([notification.object isEqualToString:@""]) {
        self.navigationController.tabBarItem.badgeValue = nil;
    }else{
        self.navigationController.tabBarItem.badgeValue = notification.object;
    }
}

-(void)didReceiveMessage:(EMMessage *)message
{
    //    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    NSString *uid =  message.from;
    TalkLog(@"%@",uid);
    
    
    NSString *messageCount = [NSString stringWithFormat:@"%lu",(unsigned long)message.messageBodies.count];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chineseNewMessage" object:messageCount];
    [self GetForeignerInformation];
    //[self.tableView reloadData];
    //    TalkLog(@"聊天列表 -- %@",conversations);
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
    
    
    //调用环信接口
    //  https://a1.easemob.com/bws/talknic
    
    
    //    AFHTTPSessionManager *posts = [AFHTTPSessionManager manager];
    //    posts.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    [posts GET:EaseMobb parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    //
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        TalkLog(@"环信接口 -- %@",responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        TalkLog(@"环信接口失败 -- %@",error);
    //    }];
    
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
