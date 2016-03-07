//
//  Information2ViewController.m
//  TalkNic
//
//  Created by ldy on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "Information2ViewController.h"
#import "Information3ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Header.h"
#import "solveJsonData.h"
@interface Information2ViewController ()
{
    NSString *_level;
}
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *beninner;
@property (nonatomic,strong)UIButton *junior;
@property (nonatomic,strong)UIButton *senior;
@property (nonatomic,strong)UIButton *professor;

@end

@implementation Information2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppInformation2;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
    [self inforView];
    
}
-(void)inforView
{
    self.label = [[UILabel alloc]init];
    _label.frame = kCGRectMake(0,88,self.view.frame.size.width,17);
    _label.text = @"Choose your level:";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
    _label.font = [UIFont fontWithName:kHelveticaLight size:17.0];
    
    _label.numberOfLines = 0;
    [self.view addSubview:_label];
    
    self.beninner = [[UIButton alloc]init];
    _beninner.frame = kCGRectMake(37, 114.5, 140, 55);
    _beninner.enabled = YES;
    [_beninner setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    //    [_beninner setBackgroundImage:[UIImage imageNamed:@"login_btn_50%_a.png"] forState:(UIControlStateHighlighted)];
    
    [_beninner setTitle:AppBeginner forState:(UIControlStateNormal)];
    [_beninner setTitle:AppBeginner forState:(UIControlStateHighlighted)];
    _beninner.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0];
    _beninner.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_beninner addTarget:self action:@selector(beninnerAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_beninner];
    
    self.junior = [[UIButton alloc]init];
    _junior.frame = kCGRectMake(197, 114.5, 140, 55);
    
    [_junior setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    [_junior setTitle:AppJunior forState:(UIControlStateNormal)];
    [_junior addTarget:self action:@selector(juniorAction) forControlEvents:(UIControlEventTouchUpInside)];
    _junior.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0];
    _junior.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_junior];
    
    self.senior = [[UIButton alloc]init];
    _senior.frame = kCGRectMake(37 , 179, 140, 55);
    
    [_senior setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    [_senior setTitle:AppSenior forState:(UIControlStateNormal)];
    [_senior addTarget:self action:@selector(seniorAction) forControlEvents:(UIControlEventTouchUpInside)];
    _senior.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0];
    _senior.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_senior];
    
    self.professor = [[UIButton alloc]init];
    _professor.frame = kCGRectMake(197, 179, 140 , 55);
    
    [_professor setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    [_professor setTitle:AppProfessor forState:(UIControlStateNormal)];
    [_professor addTarget:self action:@selector(professorAction) forControlEvents:(UIControlEventTouchUpInside)];
    _professor.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0];
    _professor.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_professor];
    
    
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


-(void)beninnerAction
{
    _level = @"beginner";
    [_beninner setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
    [_senior setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    
    [_junior setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:
     (UIControlStateNormal)];
    [_professor setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
}
-(void)juniorAction
{
    _level = @"junior";
    [_beninner setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    [_senior setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    
    [_junior setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:
     (UIControlStateNormal)];
    
    [_professor setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
}
-(void)seniorAction
{
    _level = @"senior";
    [_beninner setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    [_senior setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
    
    [_junior setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:
     (UIControlStateNormal)];
    [_professor setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
}
-(void)professorAction
{
    _level = @"professor";
    [_beninner setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    [_senior setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:(UIControlStateNormal)];
    
    [_junior setBackgroundImage:[UIImage imageNamed:@"login_btn_50%.png"] forState:
     (UIControlStateNormal)];
    [_professor setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateNormal)];
}
-(void)rightAction
{
    if(_level == nil)
    {
        [MBProgressHUD showError:kAlertEnglishLevel];
        return;
    }
 
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cmd"] = @"7";
    params[@"user_id"] = _usID;
    params[@"identity"] = @"0";
    params[@"user_name"] = _nameID;
    params[@"user_sex"] = _sexID;
    params[@"user_level"] = _level;
    
    TalkLog(@"ID -- %@ NAME -- %@ SEX -- %@  LEVEL  -- %@",_usID,_nameID,_sexID,_level);
    [session POST:PATH_GET_LOGIN parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
        NSString *str =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         TalkLog(@"上传资料成功 --%@",str);
        Information3ViewController *inforView3 = [[Information3ViewController alloc]init];
        inforView3.userID = _usID;
        
        
        [self.navigationController pushViewController:inforView3 animated:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TalkLog(@"上传失败 ---%@",error);
    }];
    
}

-(void)popAction
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
