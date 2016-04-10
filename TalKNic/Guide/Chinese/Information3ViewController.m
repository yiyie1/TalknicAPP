//
//  Information3ViewController.m
//  TalkNic
//
//  Created by Talknic on 15/11/2.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "Information3ViewController.h"
#import "ScrollViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "LoginViewController.h"
#import "solveJsonData.h"

@interface Information3ViewController ()
{
    NSString *user;
    NSString *_topics;
}

@property (nonatomic,strong)UILabel *informationLabel;
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UIButton *btn1;
@property (nonatomic,strong)UIButton *btn2;
@property (nonatomic,assign)BOOL clickBtn;
@property (nonatomic,strong)NSMutableArray *clickArr;
@end

@implementation Information3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppInformation3;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
    [self informationView];
    [self layoutBt];
}
-(void)informationView
{
    
    self.informationLabel = [[UILabel alloc]init];
    _informationLabel.text = @"Choose your favorite:";
    _informationLabel.frame  = CGRectMake(self.view.frame.size.width /3.5, self.view.frame.size.height / 10, self.view.frame.size.width /2, 50);
    _informationLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    _informationLabel.font = [UIFont fontWithName:kHelveticaLight size:17.0];
    [self.view addSubview:_informationLabel];
    
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
-(void)layoutBt
{
    if (!self.clickArr) {
        self.clickArr = [NSMutableArray array];
        
        
    }
    NSArray *arr = APP_TOPIC;
    
    for (int i = 0; i < arr.count ;i ++) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:kCGRectMake(35 + 170 * (i % 2), 110 + 70 * (i / 2), 140, 55)];
        btn1.tag = 100 + i;
        [btn1 setTitle:arr[i]forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0];
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

-(void)rightAction
{
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
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parame ;
    parame = @{@"cmd":@"8",@"user_id":_userID,@"identity":@"0",@"start_time":@"nil",@"end_time":@"nil",@"favorite":_topics};
    
    [session POST:PATH_GET_LOGIN parameters:parame progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSString *str =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        TalkLog(@"return value ---- %@",responseObject);
        NSDictionary* dic = [solveJsonData changeType:responseObject];

        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )
        //if ([str containsString:@"2"])
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:@"Done" forKey:@"FinishedInformation"];
            ScrollViewController *scroll = [[ScrollViewController alloc]init];
            scroll.uid = _userID;
            [self.navigationController pushViewController:scroll animated:YES];
        }
        else
        {
            [MBProgressHUD showError:kAlertModifyDataFailure];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
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
