//
//  HistoryViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/16.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "HistoryViewController.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "VoiceCell.h"
#import "ViewControllerUtil.h"
#import "MBProgressHUD+MJ.h"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
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
@property (nonatomic,copy)NSString *dateTimm;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)UIButton *leftBT;

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ViewControllerUtil *vcUtil = [[ViewControllerUtil alloc]init];
    self.navigationItem.titleView = [vcUtil SetTitle:AppHistory];
    [self layoutTableView];
    [self layoutLeftBT];
    self.array = [NSMutableArray array];
    
    [self dateTIme];
    [self foreignerId];
}

-(void)foreignerId
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:@"ForeignerID"];
    if ([data isEqual:@""])
        return;
    
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
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
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
        vieww.frame = CGRectMake(0, 0, kWidth, kHeight);
        vieww.backgroundColor = [UIColor grayColor];
        
        [self.tableView addSubview:vieww];
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertSee delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
    _dateTim = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    TalkLog(@"取出时间 -- %@",_dateTim);
    if (_dateTim.length < 1) {
        vieww = [[UIView alloc]init];
        vieww.frame = CGRectMake(0, 0, kWidth, kHeight);
        vieww.backgroundColor = [UIColor grayColor];
        
        [self.tableView addSubview:vieww];
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertSee delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil];
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


-(void)layoutLeftBT
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0,10, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
    self.view.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];

}

-(void)layoutTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:(UITableViewStylePlain)];
    [self.tableView registerNib:[UINib nibWithNibName:@"VoiceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    
    [self foreignerId];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KHeightScaled(88.5);
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
