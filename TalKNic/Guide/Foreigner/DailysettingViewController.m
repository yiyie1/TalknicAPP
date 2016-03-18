//
//  DailysettingViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/25.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "DailysettingViewController.h"
#import "KTSelectDatePicker.h"
#import "ScrollViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"

@interface DailysettingViewController ()
{
    KTSelectDatePicker *_kePicker;
    NSString *_startTime;
    NSString *_endTime;
}
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UILabel *labelAvail;
@property (nonatomic,strong)NSMutableArray *clickArr;

@property (nonatomic,strong)UIButton *starBtn;
@property (nonatomic,strong)UIButton *endBtn;

@property (nonatomic,strong)UILabel *labelTopic;
@property (nonatomic,strong)UILabel *labelTopic2;
@end

@implementation DailysettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = @"Daily setting";
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    self.navigationItem.titleView = title;
    
    [self navigaTitle];
    
    [self layoutDaily];
    
    [self layoutBtn];
}
-(void)navigaTitle
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 0, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)layoutDaily
{
    self.labelAvail = [[UILabel alloc]init];
    _labelAvail.frame = kCGRectMake(0, 84, self.view.frame.size.width, 20);
    _labelAvail.text = @"Available time:";
    _labelAvail.textAlignment = NSTextAlignmentCenter;
    _labelAvail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    [self.view addSubview:_labelAvail];
    
    self.starBtn = [[UIButton alloc]init];
    _starBtn.frame = kCGRectMake(40, 124, 140, 111/2);
    [_starBtn setTitle:@"00:00" forState:(UIControlStateNormal)];
    _starBtn.titleLabel.font = [UIFont fontWithName:@"" size:20];   
    [_starBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    [_starBtn addTarget:self action:@selector(startAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_starBtn];
    
    self.endBtn = [[UIButton alloc]init];
    _endBtn.frame = kCGRectMake(200, 124, 140, 111/2);
    [_endBtn setTitle:@"00:00" forState:(UIControlStateNormal)];
    [_endBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    [_endBtn addTarget:self action:@selector(endAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_endBtn];
    
    
    
    self.labelTopic = [[UILabel alloc]init];
    _labelTopic.frame =kCGRectMake(0, 235, self.view.frame.size.width, 20);
    _labelTopic.text = @"First time for your topic choosing:";
    _labelTopic.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    _labelTopic.textAlignment = NSTextAlignmentCenter;
    _labelTopic.numberOfLines = 0;
    [self.view addSubview:_labelTopic];
    self.labelTopic2 = [[UILabel alloc]init];
    _labelTopic2.frame = kCGRectMake(0, 255, self.view.frame.size.width, 15);
    _labelTopic2.text = @"(maximum 3 chosen)";
    _labelTopic2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    _labelTopic2.textAlignment = NSTextAlignmentCenter;
    _labelTopic2.numberOfLines = 0;
    [self.view addSubview:_labelTopic2];
}
-(void)layoutBtn
{
    if (!self.clickArr) {
        self.clickArr = [NSMutableArray array];
        
        
    }
    NSArray *arr = FOREIGNER_TOPIC;
    
    for (int i = 0; i < arr.count ;i ++) {
   
        UIButton *btn1 = [[UIButton alloc]initWithFrame:kCGRectMake(30 + ((375-90)/2+30 )* (i % 2), 280 + 70 * (i / 2), (375-90)/2, 55)];
        btn1.tag = 100 + i;
        [btn1 setTitle:arr[i]forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        NSString *a = @"0";
        [self.clickArr addObject:a];
        [btn1 addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
        [self.view addSubview:btn1];
        
    }

}
-(void)click:(id)sender
{
    
    UIButton *btn = sender;
    NSInteger count = btn.tag - 100;
    
    if ([_clickArr[count] isEqualToString:@"0"]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
        _clickArr[count] = @"1";
    }else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
        _clickArr[count] = @"0";
        
    }
    
}


-(void)startAction:(id)sender
{
    [_starBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
    _kePicker = [[KTSelectDatePicker alloc] init];
    //    __weak typeof(self) weakSelf = self;
    [_kePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        _startTime = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:3600*8 sinceDate:selectedDate]];
        NSString *textStr = [_startTime substringToIndex:16];
        [_starBtn setTitle:textStr forState:UIControlStateNormal];
        TalkLog(@"---+++%@",_startTime);
    }];
}

-(void)endAction
{
    [_endBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
    _kePicker = [[KTSelectDatePicker alloc] init];
    //    __weak typeof(self) weakSelf = self;
    [_kePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        _endTime = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:3600*8 sinceDate:selectedDate]];
        NSString *textStr = [_endTime substringToIndex:16];
        [_endBtn setTitle:textStr forState:UIControlStateNormal];
        TalkLog(@"---+++%@",_endTime);
    }];
}
-(void)rightAction
{
    NSArray *arr = FOREIGNER_TOPIC;
    NSMutableDictionary *click = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.clickArr.count; i ++) {
        // 被选中的Btn 下标i
        if ([self.clickArr[i] isEqualToString:@"1"]) {
            [click setObject:arr[i] forKey:[NSString stringWithFormat:@"%@",arr[i]]];
        }
    }

    TalkLog(@"Selected btn -- %@",click);
    if(click.count == 0)
    {
        [MBProgressHUD showError:kAlertTopic];
        return;
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cmd"] = @"8";
    dic[@"user_id"] = _iD;
    dic[@"identity"] = @"1";
    dic[@"start_time"] = _startTime;
    dic[@"end_time"]  = _endTime;
    dic[@"favorite"] = click;
    TalkLog(@"字典--%@",dic);
    [session POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        TalkLog(@"上传时间 -- %@",responseObject);
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )
        {
            ScrollViewController *scroviewVC = [[ScrollViewController alloc]init];
            [self.navigationController pushViewController:scroviewVC animated:YES];
        }
        else
        {
            [MBProgressHUD showError:kAlertdataFailure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
    
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *myLabel = nil;
//    myLabel = [[UILabel alloc] init];
//    myLabel.textAlignment = NSTextAlignmentCenter;
//    myLabel.textColor = [UIColor blueColor];
//    myLabel.font = [UIFont systemFontOfSize:14];
//    
//    return myLabel;
//}

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
