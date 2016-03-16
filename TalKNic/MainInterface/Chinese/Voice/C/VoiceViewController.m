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

@interface VoiceViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,IChatManagerDelegate>
{
    //时间
    NSString * _dateTime;
    //星期
    NSString * _weeK;
    NSString * _dateTim;
    
    NSString * _weekDateTime;
    
    NSString *uid;
    NSString *fUid;
    NSDictionary *dic;
    
    NSString *userNam;
    
    UIImageView *picImage;
    UIView *vieww;
    UIImage *photo;
    NSString *strPic;
}
@property (nonatomic,strong)UINavigationBar *bar;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *dateTimm;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)UISearchDisplayController *searchController;
@property (nonatomic,strong)UISearchBar *searchBar;
@end

@implementation VoiceViewController

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ViewControllerUtil *vc = [[ViewControllerUtil alloc]init];
    //self.navigationItem.titleView = [vc SetTitle:AppVoice];
    
    ViewControllerUtil *vcUtil = [[ViewControllerUtil alloc]init];
    self.bar = [vcUtil ConfigNavigationBar:AppVoice NavController: self.navigationController NavBar:self.bar];
    [self.view addSubview:self.bar];
    
    self.array = [NSMutableArray array];
    
    [self dateTIme];
    [self foreignerId];
    
    if([vcUtil CheckPaid] == NO)
    {
        self.view.backgroundColor = [UIColor grayColor];
    }
    else
    {
        [self messageView];
        if (self.searchBar == nil) {
            [self searchBarView];
        }
    }
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"chineseNewMessage" object:nil];
    
    //NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //NSData* payData = [user objectForKey:@"payTime"];
    
    //if(payData)
      //  [EaseMobSDK createOneChatViewWithConversationChatter:fUid Name:_fuserName onNavigationController:self.navigationController];
    
}

-(void)foreignerId
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:@"ForeignerID"];
    
    
    if (![data isEqual:@""]) {
        fUid = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        TalkLog(@"取出的外教 ID -- %@",fUid);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
        dicc[@"cmd"] = @"19";
        dicc[@"user_id"] = fUid;
        [manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TalkLog(@"取出外教的资料 -- %@",responseObject);
            dic = [solveJsonData changeType:responseObject];
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2)) {
                NSDictionary *dict = [dic objectForKey:@"result"];
                userNam = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                strPic =[dict objectForKey:@"pic"];
                NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
                [picImage sd_setImageWithURL:url placeholderImage:nil];
                photo = picImage.image;
                TalkLog(@"头像 ---- %@",photo);
                [self.tableView reloadData];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    [self foreignerId];
    [self.tableView reloadData];
}
-(void)dateTIme
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSData *data = [userD objectForKey:@"currDate"];
    if ([data isEqual:@""])
    {
        vieww = [[UIView alloc]init];
        vieww.frame = kCGRectMake(0, 0, kWidth, kHeight);
        vieww.backgroundColor = [UIColor grayColor];
        
        [self.tableView addSubview:vieww];
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertSee delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        _dateTim = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        TalkLog(@"取出时间 -- %@",_dateTim);
        if (_dateTim.length < 1)
        {
            vieww = [[UIView alloc]init];
            vieww.frame = kCGRectMake(0, 0, 375, 667);
            vieww.backgroundColor = [UIColor grayColor];
            
            [self.tableView addSubview:vieww];
            UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertSee delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (vieww) {
                [vieww removeFromSuperview];
            }
            NSString * a = _dateTim;
            TalkLog(@"-----%@",_dateTim);
            _dateTime = [a substringFromIndex:4];
            TalkLog(@"取出时间 -- %@",_dateTime);
            NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
            [dateFor setDateFormat:@"yyyy,MMM dd"];
            NSDate *date = [dateFor dateFromString:_dateTim];
            TalkLog(@"取出的时间 --- %@",date);
            
            NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
            [dateF setDateFormat:@"yyyy,MMM dd"];
            NSString *strDate = [dateF stringFromDate:date];
            TalkLog(@"最后的时间 -- %@",strDate);
            
            
            
            //实例化一个NSDateFormatter对象
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            //设定时间格式,这里可以设置成自己需要的格式
            
            [dateFormatter setDateFormat:@"yyyy-MMM-dd "];
            
            //用[NSDate date]可以获取系统当前时间
            
            NSString *currentDateStr = [dateFormatter stringFromDate:date];
            
            //输出格式为：2010-10-27 10:22:13
            [self GetTime];
            NSLog(@"星期 %@",currentDateStr);
        }
        
    }
    
}
-(void)GetTime

{
    
    //根据字符串转换成一种时间格式 供下面解析
    
    NSString* string = _dateTim;
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy,MMM-dd"];
    
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    
    
    comps = [calendar components:unitFlags fromDate:inputDate];
    
    int week = [comps weekday];
    
    _weeK = [self getweek:week];
    
    TalkLog(@"星期几 %@",_weeK);
    _weekDateTime = [_weeK stringByAppendingString:_dateTime];
    TalkLog(@"完整版时间 -- %@",_weekDateTime);
    
    
}

-(NSString*)getweek:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=@"Sun";
        
    }
    else if(week==2)
    {
        weekStr=@"Mon";
 
    }
    else if(week==3)
    {
        weekStr=@"Tue";
    }
    else if(week==4)
    {
        weekStr=@"Wed";

    }
    else if(week==5)
    {
        weekStr=@"Thu";
        
    }
    else if(week==6)
    {
        weekStr=@"Fri";
    }
    else if(week==7)
    {
        weekStr=@"Sat";
    }
    return weekStr;
}

-(void)messageView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 129.0/2 + KHeightScaled(44), kWidth, kHeight) style:(UITableViewStylePlain)];
    [self.tableView registerNib:[UINib nibWithNibName:@"VoiceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    
    [self foreignerId];
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
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        VoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.userName.text = userNam;
        cell.date.text = _weekDateTime;
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:strPic]];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_select_area_bg.png"]];
        
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
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDate *payDate = [user objectForKey:@"payTime"];
    
    NSDate *dateNow = [NSDate date];
    NSTimeInterval timeBetween = [dateNow timeIntervalSinceDate:payDate];
    
    if (timeBetween > DEFAULT_MAX_CHAT_DURATION) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:AppNotify message:AppConChat delegate:self cancelButtonTitle:AppSure otherButtonTitles:nil];
        [alert show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        //FXIME each chat should have his own chat duration
        //Clear payment and chat duration
        [user removeObjectForKey:@"payTime"];
        [user removeObjectForKey:@"chatDuration"];
    }
    else
    {
        [EaseMobSDK createOneChatViewWithConversationChatter:fUid Name:userNam onNavigationController:self.navigationController];
        self.navigationController.tabBarItem.badgeValue = nil;
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
    [self foreignerId];
    [self.tableView reloadData];
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
