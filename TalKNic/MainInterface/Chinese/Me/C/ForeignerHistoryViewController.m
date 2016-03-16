//
//  ForeignerHistoryViewController.m
//  TalKNic
//
//  Created by ldy on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "ForeignerHistoryViewController.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "VoiceCell.h"
@interface ForeignerHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
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
@property (nonatomic,strong)UIButton *leftBT;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *uid;

@end

@implementation ForeignerHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppHistory;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;

    
    [self layoutLeftBT];
    
    [self layoutTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self afnusername];
    [self.tableView reloadData];
    
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 45) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"VoiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"VoiceCell"];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"VoiceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
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
    if (![data isEqual:@""]) {
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
        
//        FVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
#warning 6教师端修改开始
        VoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell){
            cell = [[VoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
#warning 6教师端修改结束
        cell.userName.text = userNam;
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
    
    [self dateTIme];
    
    TalkLog(@"聊天界面  -  %@",_uid);
}


-(void)leftAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
