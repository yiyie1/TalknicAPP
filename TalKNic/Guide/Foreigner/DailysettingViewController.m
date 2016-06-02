//
//  DailysettingViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/25.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "DailysettingViewController.h"
//#import "KTSelectDatePicker.h"
#import "CDPDatePicker.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
#import "LoginViewController.h"
#import "ViewControllerUtil.h"

@interface DailysettingViewController ()<CDPDatePickerDelegate>
{
    CDPDatePicker *_kePicker;
    NSString *_startTime;
    NSString *_endTime;
    NSString *_topics;
}
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UILabel *labelAvail;
@property (nonatomic,strong)NSMutableArray *clickArr;

@property (nonatomic,strong)UIButton *starBtn;
@property (nonatomic,strong)UIButton *endBtn;
@property (nonatomic,strong)UIButton *bgButton;
@property (nonatomic,strong)UILabel *labelTopic;
@property (nonatomic,strong)UILabel *labelTopic2;
@end

@implementation DailysettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ViewControllerUtil verifyFreeUser];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewControllerUtil SetTitle:AppDailySetting];
    
    [self navigaTitle];
    
    [self layoutDaily];

    [self layoutBtn];
}

-(void)navigaTitle
{
    //self.leftBT = [[UIButton alloc]init];
    //_leftBT.frame = CGRectMake(0, 0, 7, 23/2);
    //[_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    //[_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    //UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    //self.navigationItem.leftBarButtonItem = leftI;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:AppDone style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)layoutDaily
{
    self.labelAvail = [[UILabel alloc]init];
    _labelAvail.frame = kCGRectMake(0, 84, 375, 20);
    _labelAvail.text = AppAvailabletime;
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
    _labelTopic.frame =kCGRectMake(0, 235, 375, 20);
    _labelTopic.text = kAlertTopic;
    _labelTopic.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    _labelTopic.textAlignment = NSTextAlignmentCenter;
    _labelTopic.numberOfLines = 0;
    [self.view addSubview:_labelTopic];
}

-(void)layoutBtn
{
    if (!self.clickArr) {
        self.clickArr = [NSMutableArray array];
    }
    NSArray *arr = APP_TOPIC;
    
    for (int i = 0; i < arr.count ;i ++) {
   
        UIButton *btn1 = [[UIButton alloc]initWithFrame:kCGRectMake(30 + ((375-90)/2+30 )* (i % 2), 280 + 70 * (i / 2), (375-90)/2, 55)];
        btn1.tag = 100 + i;
        [btn1 setTitle:arr[i]forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        [self.clickArr addObject:@"0"];
        [btn1 addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
        [self.view addSubview:btn1];
        
    }

}
-(void)click:(id)sender
{
    
    UIButton *btn = sender;
    NSInteger count = btn.tag - 100;
    
    if ([_clickArr[count] isEqualToString:@"0"])
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
        _clickArr[count] = @"1";
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
        _clickArr[count] = @"0";
        
    }
    
}


-(void)startAction:(id)sender
{
    if(_kePicker == nil)
        _kePicker = [[CDPDatePicker alloc] initWithSelectTitle:nil viewOfDelegate:self.view delegate:self];
    _kePicker.isBeforeTime = NO;
    [_starBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
    [_kePicker pushDatePicker];
    _endBtn.enabled = NO;
}

-(void)endAction
{
    if(_kePicker == nil)
        _kePicker = [[CDPDatePicker alloc] initWithSelectTitle:nil viewOfDelegate:self.view delegate:self];
    _kePicker.isBeforeTime = NO;
    [_endBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
    [_kePicker pushDatePicker];
    _starBtn.enabled = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_kePicker popDatePicker];
    _starBtn.enabled = YES;
    _endBtn.enabled = YES;
}

-(void)CDPDatePickerDidConfirm:(NSString *)confirmString
{
    if(_starBtn.enabled)
    {
        _startTime = [NSString stringWithFormat:@"%@",confirmString];
        NSString *textStr = [_startTime substringToIndex:16];
        [_starBtn setTitle:textStr forState:UIControlStateNormal];
        _endBtn.enabled = YES;
    }
    else
    {
        _endTime = [NSString stringWithFormat:@"%@",confirmString];
        NSString *textStr = [_endTime substringToIndex:16];
        [_endBtn setTitle:textStr forState:UIControlStateNormal];
        _starBtn.enabled = YES;
    }
}

//FIXME need to end time > start time
-(void)rightAction
{
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
    _topics = @"";
    NSArray *arr = APP_TOPIC;
    for (int i = 0; i < self.clickArr.count; i ++)
    {
        // 被选中的Btn 下标i
        if ([self.clickArr[i] isEqualToString:@"1"])
        {
            _topics = [_topics stringByAppendingString:arr[i]];
        }
    }
    
    if([_topics isEqualToString:@""])
    {
        [MBProgressHUD showError:kAlertTopic];
        return;
    }
    
    if(_startTime.length == 0 || _endTime.length == 0)
    {
        [MBProgressHUD showError:@"Please choose your available time"];
        return;
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cmd"] = @"8";
    dic[@"user_id"] = _uid;
    dic[@"identity"] = @"1";
    dic[@"start_time"] = _startTime;
    dic[@"end_time"]  = _endTime;
    dic[@"favorite"] = _topics;
    TalkLog(@"dic--%@",dic);
    [session POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        TalkLog(@"上传时间 -- %@",responseObject);
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )
        {
            [MBProgressHUD showSuccess:kAlertdataSuccess];
            //ScrollViewController *scroviewVC = [[ScrollViewController alloc]init];
            //[self.navigationController pushViewController:scroviewVC animated:YES];
        }
        else
        {
            [MBProgressHUD showError:kAlertdataFailure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ViewControllerUtil showNetworkErrorMessage: error];
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

//-(void)leftAction
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
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
