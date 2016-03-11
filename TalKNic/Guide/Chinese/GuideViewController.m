//
//  GuideViewController.m
//  TalkNic
//
//  Created by ldy on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"

#import "CreateViewController.h"
#import "Header.h"
@interface GuideViewController ()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIButton *signUp;
@property (nonatomic,strong)UIButton *login;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
    [self guideView];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)guideView
{
    self.navigationController.navigationBar.hidden = YES;
    self.imageView = [[UIImageView alloc]initWithFrame:kCGRectMake(kZEro, kZEro, kThreehundredandseventyfive, kSixhundredandsixtyseven)];
    self.imageView.image = [UIImage imageNamed:kLoginBg];
    [self.view addSubview:_imageView];
    
    
    
    self.signUp = [[UIButton alloc]init];
    _signUp.frame = kCGRectMake( 37 , 603 , 140, 55);
    [_signUp setBackgroundImage:[UIImage imageNamed:kChooseBtn] forState:(UIControlStateNormal)];
    [_signUp setBackgroundImage:[UIImage imageNamed:kChooseBtnHigh]
                       forState:(UIControlStateHighlighted)];
    [_signUp setTitle:@"Sign up" forState:(UIControlStateNormal)];
    [_signUp setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    _signUp.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:20.0];
    [_signUp addTarget:self action:@selector(signupAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_signUp];
    
    self.login = [[UIButton alloc]init];
    _login.frame =kCGRectMake( 198, 603 , 140, 55) ;
    [_login setBackgroundImage:[UIImage imageNamed:kChooseBtn] forState:(UIControlStateNormal)];
    [_login setBackgroundImage:[UIImage imageNamed:kChooseBtnHigh] forState:(UIControlStateHighlighted)];
    [_login setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [_login addTarget:self action:@selector(loginAction) forControlEvents:(UIControlEventTouchUpInside)];
    _login.titleLabel.font= [UIFont fontWithName:kHelveticaLight size:20.0];
    [_login setTitle:@"Log in" forState:(UIControlStateNormal)];
    
    
    [self.view addSubview:_login];
}
-(void)signupAction
{
    CreateViewController *creatVC= [[CreateViewController alloc]init];
    
    creatVC.identitt =  _identity;
    TalkLog(@"身份信息 -- %@",creatVC.identitt);
    [self.navigationController pushViewController:creatVC animated:NO];
    
    
}
-(void)loginAction
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
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
