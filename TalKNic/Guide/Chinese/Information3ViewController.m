//
//  Information3ViewController.m
//  TalkNic
//
//  Created by ldy on 15/11/2.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "Information3ViewController.h"
#import "ScrollViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Header.h"
#import "LoginViewController.h"
@interface Information3ViewController ()
{
    NSString *user;
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
    NSArray *arr = @[AppTravel,AppFilm,AppSports,AppTech,AppDesign,AppArts,AppCooking,AppBook];
    
    for (int i = 0; i < 8 ;i ++) {
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
    NSArray *arr = @[@"travel",@"film",@"sports",@"tech",@"design",@"arts",@"cooking",@"book"];
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.clickArr.count; i ++) {
        // 被选中的Btn 下标i
        if ([self.clickArr[i] isEqualToString:@"1"]) {
            [parames setObject:arr[i] forKey:[NSString stringWithFormat:@"%@",arr[i]]];
        }
    }
    TalkLog(@"选中的btn -- %@",parames);
    if(parames.count == 0)
    {
        [MBProgressHUD showError:kAlertTopic];
        return;
    }

    user = _userID;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parame ;
    parame = @{@"cmd":@"8",@"user_id":user,@"identity":@"0",@"start_time":@"nil",@"end_time":@"nil",@"favorite":parames};
//    parame[@"cmd"] = @"8";
//    parame[@"user_id"] = user;
//    parame[@"identity"] = @"0";
//    parame[@"start_time"] = nil;
//    parame[@"end_time"] = nil;
//    parame[@"favorite"] = parames;
    
    [session POST:PATH_GET_LOGIN parameters:parame progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"上传成功 -- %@",responseObject);
        ScrollViewController *scroll = [[ScrollViewController alloc]init];
        scroll.uid = user;
        [self.navigationController pushViewController:scroll animated:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
