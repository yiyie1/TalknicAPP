//
//  ChoosePeopleViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/4.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//


#import "ChoosePeopleViewController.h"
#import "ForeignerViewController.h"
#import "LoginViewController.h"
#import "Header.h"
#import "EaseMobSDK.h"
#define kEaseKey @"bws#talknic"

@interface ChoosePeopleViewController ()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIButton *chineSe;
@property (nonatomic,strong)UIButton *foreiGner;
@property (nonatomic,assign)BOOL chooseBtn;

@end

@implementation ChoosePeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self chooseView];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    self.chooseBtn = YES;
}
-(void)chooseView
{
    self.navigationController.navigationBar.hidden = YES;
    self.imageView = [[UIImageView alloc]initWithFrame:kCGRectMake(0, 0, 375, 667)];
    self.imageView.image = [UIImage imageNamed:kLoginBg];
    [self.view addSubview:_imageView];
    
    self.chineSe = [[UIButton alloc]init];
    _chineSe.frame = kCGRectMake( 37 , 602.5 , 140, 55.5);
    [_chineSe setBackgroundImage:[UIImage imageNamed:kChooseBtn] forState:(UIControlStateNormal)];
    [_chineSe setBackgroundImage:[UIImage imageNamed:kChooseBtnHigh]forState:(UIControlStateHighlighted)];
    [_chineSe setTitle:AppChinese forState:(UIControlStateNormal)];
    [_chineSe setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    _chineSe.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0];
    [_chineSe addTarget:self action:@selector(chineseAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_chineSe];
    
    self.foreiGner = [[UIButton alloc]init];
    _foreiGner.frame =kCGRectMake(198, 602.5 , 140, 55.5) ;
    [_foreiGner setBackgroundImage:[UIImage imageNamed:kChooseBtn] forState:(UIControlStateNormal)];
    [_foreiGner setBackgroundImage:[UIImage imageNamed:kChooseBtnHigh] forState:(UIControlStateHighlighted)];
    [_foreiGner setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [_foreiGner addTarget:self action:@selector(foreignerAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _foreiGner.titleLabel.font= [UIFont fontWithName:kHelveticaLight size:20.0];
    [_foreiGner setTitle:AppForeigner forState:(UIControlStateNormal)];
    
    
    [self.view addSubview:_foreiGner];
}
-(void)chineseAction
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
    if (str) {
        [ud removeObjectForKey:kChooese_ChineseOrForeigner];
    }
    [ud setObject:@"Chinese" forKey:kChooese_ChineseOrForeigner];
//    //登录
//    [EaseMobSDK easeMobLoginAppWithAccount:@"1233" password:@"1234" isAutoLogin:YES HUDShowInView:self.view];
    
    LoginViewController *loginVC =[[LoginViewController alloc]init];
    loginVC.identity = CHINESEUSER ;
    [self.navigationController pushViewController:loginVC animated:NO];
}

-(void)foreignerAction:(UIButton *)button
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
    if (str) {
        [ud removeObjectForKey:kChooese_ChineseOrForeigner];
    }
    [ud setObject:@"Foreigner" forKey:kChooese_ChineseOrForeigner];
    
    LoginViewController *loginVC =[[LoginViewController alloc]init];
    loginVC.identity = FOREINERUSER;
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
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
