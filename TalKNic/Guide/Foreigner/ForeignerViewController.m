//
//  ForeignerViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/20.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "ForeignerViewController.h"
#import "Foreigner2ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
@interface ForeignerViewController ()
@property (nonatomic,strong)UILabel *labelTitle;
@property (nonatomic,strong)UILabel *labelTitle2;
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)NSMutableArray *clickArr;

@end

@implementation ForeignerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = @"Information (2/3)";
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    self.navigationItem.titleView = title;

    [self labeltitleView];
    [self layoutBtn];
    
}
-(void)labeltitleView
{
    self.labelTitle = [[UILabel alloc]init];
    _labelTitle.frame = CGRectMake(15, 84, kWidth-30, 20);
    _labelTitle.text = @"First time for your topic choosing:";
    _labelTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    _labelTitle.numberOfLines =0;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_labelTitle];
    
    self.labelTitle2 = [[UILabel alloc]init];
    _labelTitle2.frame =CGRectMake(15, 104, kWidth-30, 15);
    _labelTitle2.text =@"(maximum 3 chosen)";
    _labelTitle2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    _labelTitle2.textAlignment = NSTextAlignmentCenter;
    _labelTitle2.numberOfLines =0;
    [self.view addSubview:_labelTitle2];
    
    
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 0, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)
     ];
    [_leftBT addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftit = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftit;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)layoutBtn
{
    if (!self.clickArr) {
        self.clickArr = [NSMutableArray array];
        
        
    }
    NSArray *arr = FOREIGNER_TOPIC;
    
    for (int i = 0; i < arr.count ;i ++) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(30 + ((kWidth-90)/2+30 )* (i % 2), 135 + 70 * (i / 2), (kWidth-90)/2, 55)];
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

-(void)rightAction
{
    NSArray *arr = FOREIGNER_TOPIC;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.clickArr.count; i ++) {
        // 被选中的Btn 下标i
        if ([self.clickArr[i] isEqualToString:@"1"]) {
            [parames setObject:arr[i] forKey:[NSString stringWithFormat:@"%@",arr[i]]];
        }
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"cmd"] = @"7";
    parame[@"user_id"] = _usID;
    parame[@"identity"] = @"1";
    parame[@"user_name"] = _usName;
    parame[@"user_sex"] = _sex;
    parame[@"user_level"] = parames;
    parame[@"nationality"] = _nation;
    parame[@"occupation"]  = _occup;
    parame[@"biography"]  = _biogra;
    
    [session POST:PATH_GET_LOGIN parameters:parame progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        TalkLog(@"上传成功 -- %@",str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TalkLog(@"上传失败 -- %@",error);
    }];
    Foreigner2ViewController *foreigner2VC =[[Foreigner2ViewController alloc]init];
    foreigner2VC.iD = _usID;
    [self.navigationController pushViewController:foreigner2VC animated:NO];
    
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
