//
//  ForeignerVoiceViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "ForeignerVoiceViewController.h"
#import "FVoice.h"
#import "FVoiceCell.h"
#import "EaseMobSDK.h"
#import "AFNetworking.h"
#define EaseMobb @"https://a1.easemob.com/bws/talknic"
#import "EMMessage.h"
#import "EMConversation.h"
#import "solveJsonData.h"
@interface ForeignerVoiceViewController ()<UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate>
{
    
    //时间
    NSString * _dateTime;
    //星期
    NSString * _weeK;
    NSString * _dateTim;
    
    NSString * _weekDateTime;
    
    NSString *_uid;
    NSDictionary *dic;
    
    NSString *userNam;
    
    UIImageView *picImage;
    UIView *vieww;
    UIImage *photo;
    NSString *strPic;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *uid;
@end

@implementation ForeignerVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"Audio Message";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    self.navigationItem.titleView = title;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"FNewMessage" object:nil];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self messageView];
    [self afnusername];
     //[self dateTIme];
}
- (void)newMessage:(NSNotification *)notification
{
    TalkLog(@"接受新消息");
    if ([notification.object isEqualToString:@""]) {
        self.navigationController.tabBarItem.badgeValue = nil;
    }else{
        self.navigationController.tabBarItem.badgeValue = @"";
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self afnusername];
    [self.tableView reloadData];
    
}
-(void)didReceiveMessage:(EMMessage *)message
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    _uid =  message.from;
    NSString *messageCount = [NSString stringWithFormat:@"%lu",(unsigned long)message.messageBodies.count];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FNewMessage" object:messageCount];

    [self afnusername];
    [self.tableView reloadData];

    TalkLog(@"发送 ------ %@",_uid);
    TalkLog(@"聊天列表 -- %@",conversations);
    
}
-(void)afnusername
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    dicc[@"cmd"] = @"19";
    dicc[@"user_id"] = _uid;
    [manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"发送消息的ID -- %@",responseObject);
        dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2)) {
            NSDictionary *dict = [dic objectForKey:@"result"];
            userNam = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            strPic =[dict objectForKey:@"pic"];
            
            
            TalkLog(@"头像1 ---- %@",strPic);
            [self.tableView reloadData];
            
        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
    TalkLog(@"%@",_uid);
   

}
-(void)messageView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    [self.tableView registerNib:[UINib nibWithNibName:@"FVoiceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
   // _tableView.backgroundColor = [UIColor blueColor];
    [self afnusername];
    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(void)viewDidDisappear:(BOOL)animated
{
   // [self dateTIme];
}
-(void)dateTIme
{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSData *data = [userD objectForKey:@"currDate"];
    if (![data isEqual:@""]){
    _dateTim = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    TalkLog(@"取出时间 -- %@",_dateTim);
    if (_dateTim.length < 1) {
        TalkLog(@"asdasdasdasdasdasdas------");
        vieww = [[UIView alloc]init];
        vieww.frame = kCGRectMake(0, 0, 375, 667);
//        vieww.backgroundColor = [UIColor yellowColor];
        
        [self.tableView addSubview:vieww];
        
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:kAlertPointStr message:kAlertNoNews delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil];
        
        [alert show];
    }else
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
        
    }else if(week==2){
        
        weekStr=@"Mon";
        
        
        
    }else if(week==3){
        
        weekStr=@"Tue";
        
        
        
    }else if(week==4){
        
        weekStr=@"Wed";
        
        
        
    }else if(week==5){
        
        weekStr=@"Thu";
        
        
        
    }else if(week==6){
        
        weekStr=@"Fri";
        
        
        
    }else if(week==7){
        
        weekStr=@"Sat";
        
        
        
    }
    
    return weekStr;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        FVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.userFName.text = userNam;
        cell.date.text = _weekDateTime;
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:strPic]];
        TalkLog(@"cell头像 -- %@",cell.userImage);
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_select_area_bg.png"]];
        TalkLog(@"qweqweqweqweqweq--- %@",cell);
        return cell;
    }else
    {
        UITableViewCell *cell =[[UITableViewCell alloc]init];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KHeightScaled(88.5);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [EaseMobSDK createOneChatViewWithConversationChatter:_uid Name:userNam onNavigationController:self.navigationController];
    self.navigationController.tabBarItem.badgeValue = nil;
    TalkLog(@"聊天界面  -  %@",_uid);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
