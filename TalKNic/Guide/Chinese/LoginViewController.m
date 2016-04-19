//
//  LoginViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "Information1ViewController.h"
#import "SignupViewController.h"
#import "Foreigner1ViewController.h"
#import "Check.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "MBProgressHUD+MJ.h"
#import "TalkTabBarViewController.h"
#import "Information3ViewController.h"
#import "ScrollViewController.h"
#import "NSString+Hash.h"
#import "EaseMobSDK.h"
#import "AppDelegate+ShareSDK.h"
#import "AFHTTPSessionManager.h"
#import "ChoosePeopleViewController.h"
#import "ViewControllerUtil.h"

#define kMobilewF 275

@interface LoginViewController ()
{
    NSDictionary *dic;
    NSDictionary *_weibo;
    NSString *_weiboId;
    ViewControllerUtil *_vcUtil;
}

@property (nonatomic,strong)UIButton *loginBT, *signupBT,*forgetPasspord,*emailBT,*facebookBT,*weixinBT,*weiboBT;
@property (nonatomic,strong)UIImageView *image1;
@property (nonatomic,strong)UIImageView *image2;
@property (nonatomic,strong)UIButton *leftBt;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mobile = YES;
    _vcUtil = [[ViewControllerUtil alloc]init];
    
    //增加背景色，防止push到当前页会卡
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = AppLogin;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    self.navigationItem.titleView = title;
    
    [self loginvieww];
    
    self.view.userInteractionEnabled = YES;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    _loginmobileTF.placeholder = _mobile ? AppCellNum : AppEmail;
}

-(void)loginvieww
{
    [self loginmobile];
    [self passpord];
    [self loginbtt];
    [self signupbtt];
    [self forgetpass];
    [self imagee];
    [self fxBt];
}

-(void)loginmobile
{
    self.loginmobileTF = [[UITextField alloc]init];
    _loginmobileTF.frame = CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y + 84, self.view.frame.size.width/1.36, 50);
    _loginmobileTF.placeholder = _mobile ? AppCellNum : AppEmail;
    _loginmobileTF.textAlignment = NSTextAlignmentCenter;
    [_loginmobileTF setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    [self.view addSubview:_loginmobileTF];
}

-(void)passpord
{
    self.passwordTF = [[UITextField alloc]init];
    _passwordTF.frame = CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y +144, self.view.frame.size.width /1.36, 50);
    _passwordTF.secureTextEntry = YES;
    _passwordTF.layer.cornerRadius = 25;
    _passwordTF.textAlignment = NSTextAlignmentCenter;
    [_passwordTF setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    // _passwordTF.backgroundColor = [UIColor redColor];
    [self.view addSubview:_passwordTF];
    
    _passwordTF.placeholder=AppPassword;
}

-(void)loginbtt
{
    self.loginBT =  [[UIButton alloc]init];
    _loginBT.frame = CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y +204, self.view.frame.size.width /1.36, 50);
    [_loginBT setTitle:AppLogin forState:(UIControlStateNormal)];
    //_loginBT.tintColor = [UIColor blackColor];
    [_loginBT setBackgroundImage:[UIImage imageNamed:@"login_btn_lg_a.png"] forState:(UIControlStateNormal)];
    [_loginBT addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_loginBT];
    
    self.leftBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _leftBt.frame =kCGRectMake(0, 0, 7, 11.5);
    [_leftBt setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBt addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBt];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

-(void)signupbtt
{
    self.signupBT = [[UIButton alloc]init];
    _signupBT.frame = kCGRectMake(40, 300, self.view.frame.size.width /5, 20);
    [_signupBT setTitle:AppSignup forState:(UIControlStateNormal)];
    [_signupBT setTitleColor:[UIColor colorWithRed:kColorvalue/255.0 green:kColorvalue/255.0 blue:kColorvalue/255.0 alpha:1.0] forState:UIControlStateNormal];
    // _signupBT.backgroundColor = [UIColor grayColor];
    _signupBT.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:14.0];
    [_signupBT addTarget:self action:@selector(signUP) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_signupBT];
}

-(void)forgetpass
{
    self.forgetPasspord = [[UIButton alloc]init];
    _forgetPasspord.frame = kCGRectMake( 220,  300, 130 , 14);
    [_forgetPasspord setTitle:AppForgetPassword forState:(UIControlStateNormal)];
    [_forgetPasspord setTitleColor:[UIColor colorWithRed:kColorvalue/255.0 green:kColorvalue/255.0 blue:kColorvalue/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    _forgetPasspord.titleLabel.font = [UIFont fontWithName:kHelveticaLight size:14.0];
    [_forgetPasspord addTarget:self action:@selector(forgetPassword) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_forgetPasspord];
}

-(void)imagee
{
    UILabel *label1 = [[UILabel alloc ]init];
    label1.frame = kCGRectMake(40, 348, 70, 2);
    [label1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_line_side_a.png"]]];
    [self.view addSubview:label1];
    UILabel *label2 = [[UILabel alloc]init];
    label2.frame = kCGRectMake(130, 332.5 , 140, 24);
    label2.text = AppOtherFastSignup;
    label2.font = [UIFont fontWithName:kHelveticaLight size:14];

    
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.frame = kCGRectMake( 270, 348, 70, 2);
    [label3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_line_side_a.png"]]];
    [self.view addSubview:label3];
}

-(void)fxBt
{
    self.emailBT = [[UIButton alloc]init];
    _emailBT.frame = kCGRectMake(50, 390, 60, 60);
    [_emailBT setBackgroundImage:[UIImage imageNamed:@"login_mail.png"] forState:(UIControlStateNormal)];
    [_emailBT addTarget:self action:@selector(emileBt) forControlEvents:UIControlEventTouchUpInside];
    [_emailBT setBackgroundImage:[UIImage imageNamed:@"login_mail_a.png"] forState:(UIControlStateHighlighted)];
    [self.view addSubview:_emailBT];
    
    self.facebookBT = [[UIButton alloc]init];
    _facebookBT.frame = kCGRectMake(125,390, 60, 60);
    [_facebookBT setBackgroundImage:[UIImage imageNamed:@"login_fb.png"] forState:(UIControlStateNormal)];
    [_facebookBT setBackgroundImage:[UIImage imageNamed:@"login_fb.png"] forState:(UIControlStateHighlighted)];
    [self.view addSubview:_facebookBT];
    
    self.weixinBT = [[UIButton alloc]init];
    _weixinBT.frame = kCGRectMake(200,  390, 60, 60);
    _weixinBT.tag = 0;
    [_weixinBT setBackgroundImage:[UIImage imageNamed:@"login_wechat.png"] forState:(UIControlStateNormal)];
    [_weixinBT setBackgroundImage:[UIImage imageNamed:@"login_wechat_a.png"] forState:(UIControlStateHighlighted)];
    [_weixinBT addTarget:self action:@selector(loginFrom3rdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_weixinBT];
    
    self.weiboBT = [[UIButton alloc]init];
    _weiboBT.frame = kCGRectMake(275,390, 60, 60);
    _weiboBT.tag = 1;
    [_weiboBT setBackgroundImage:[UIImage imageNamed:@"login_weibo.png"] forState:(UIControlStateNormal)];
    [_weiboBT addTarget:self action:@selector(loginFrom3rdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [_weiboBT setBackgroundImage:[UIImage imageNamed:@"login_weibo_a.png"] forState:(UIControlStateHighlighted)];
    [self.view addSubview:_weiboBT];
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)facebookLogin
{
    //TODO
}

-(void)loginFrom3rdPlatform:(id) sender
{
    UIButton *btn = sender;
    NSUInteger platform;
    if(btn.tag == 1)
        platform = SSDKPlatformTypeSinaWeibo;
    else if (btn.tag == 0)
        platform = SSDKPlatformTypeWechat;
    
    [ShareSDK getUserInfo:(platform) onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            NSString *identity = [_vcUtil CheckRole];
            TalkLog(@"uid = %@ , %@  token = %@ ,nickname = %@",user.uid,user.credential,user.credential.token,user.nickname);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            param[@"cmd"] = @"333";
            param[@"login_type"] = btn.tag == 1 ? @"sina" : @"wechat";
            param[@"unique_identification"] = user.uid;
            param[@"nickname"] = user.nickname;
            param[@"identity"] = identity;
            
            [manager POST:PATH_GET_LOGIN parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                TalkLog(@"3rd platform login -- %@",responseObject);
                _weibo = [solveJsonData changeType:responseObject];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                
                NSDictionary *dict = [_weibo objectForKey:@"result"];
                _weiboId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                
                if ([[_weibo objectForKey:@"code"] isEqualToString: SERVER_SUCCESS])    //Not the first time to login/signup
                {
                    //if (_uid !=nil)
                    //{
                        //注册环信
                    //    [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                    //}

                    if ([_weiboId isEqualToString:CHINESEUSER] && [identity isEqualToString:CHINESEUSER])  // 0 means Chinese account
                    {
                        TalkLog(@"Chinese user -- ID -- %@",_uid);
                    }
                    else if([_weiboId isEqualToString:FOREINERUSER] && [identity isEqualToString:FOREINERUSER])
                    {
                        TalkLog(@"Foreigner user -- ID -- %@",_uid);
                    }
                    else
                    {
                        [ud removeObjectForKey:@"UseApp"];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertAccountNotMatchID delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
                        [alert show];
                        ChoosePeopleViewController *choosePeopleVC = [[ChoosePeopleViewController alloc]init];
                        [self.navigationController pushViewController:choosePeopleVC animated:YES];
                        return;
                    }
                    
                    [ud setObject:@"Done" forKey:@"FinishedInformation"];
                    [ud setObject:_uid forKey:@"userId"];
                    [ud synchronize];
                    
                    TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
                    talkVC.uid = _uid;
                    [self presentViewController:talkVC animated:YES completion:nil];
                    //[EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                }
                else if (([(NSNumber *)[_weibo objectForKey:@"code"] intValue] == 5))   //First time to login
                {
                    if (_uid != nil)
                    {
                        //注册环信
                        [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                    }

                    [ud setObject:_uid forKey:@"userId"];
                    // 修改
                    [ud synchronize];
                    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                    
                    if ([identity isEqualToString:CHINESEUSER])
                    {
                        Information1ViewController *inforVC = [[Information1ViewController alloc]init];
                        inforVC.uID = _uid;
                        [self.navigationController pushViewController:inforVC animated:YES];
                        
                    }
                    else if([identity isEqualToString:FOREINERUSER])
                    {
                        Foreigner1ViewController *foreigVC = [[Foreigner1ViewController alloc]init];
                        foreigVC.uID = _uid;
                        [self.navigationController pushViewController:foreigVC animated:YES];
                    }
                    //[ud setObject:@"Done" forKey:@"FinishedInformation"];
                }
                else
                {
                    [MBProgressHUD showError:kAlertdataFailure];
                    return;
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error%@",error);
                [MBProgressHUD showError:kAlertNetworkError];
                return;
            }];
        }
        else
        {
            [MBProgressHUD showError:kAlertFail];
            TalkLog(@"Share sdk error");
            TalkLog(@"%@",error);
        }
        
    }];
}

#pragma mark - 登陆方式选择
-(void)emileBt
{
    _mobile = !_mobile;
    _loginmobileTF.placeholder = _mobile ? AppCellNum : AppEmail;
}

-(void)signUP
{
    self.telNum = _loginmobileTF.text;
    SignupViewController *signupVC = [[SignupViewController alloc]init];
    signupVC.mobile = self.mobile;
    signupVC.loginVC = self;
    [self.navigationController pushViewController:signupVC animated:YES];
}

-(void)loginAction:(id)sender
{
    if (_mobile == YES)
    {
        Check *checkNum = [[Check alloc]init];
        
        if (_loginmobileTF.text.length == 0 | _passwordTF.text.length ==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertCodeEmpty delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if (![checkNum isMobileNumber:_loginmobileTF.text])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertFalse delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if (_passwordTF.text.length < 6)
        {
            [MBProgressHUD showError:kAlert6];
            return;
            
        }
        else if (_passwordTF.text.length > 16)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlert16 delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [_passwordTF.text md5String];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
        parmas[@"cmd"] = @"3";
        parmas[@"tel"] = _loginmobileTF.text;
        parmas[@"password"] = _passwordTF.text;
        [session POST:PATH_GET_LOGIN parameters:parmas success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dic = [solveJsonData changeType:responseObject];
            NSLog(@"result %@",dic);
            
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 7) )
            {
                [MBProgressHUD showError:kAlertPasswordWrong];
                return ;
            }
            else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4) )
            {
                [MBProgressHUD showError:kAlertPasswordWrong];
                return;
            }
            else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 5)) // First time login
            {

                NSDictionary *dict = [dic objectForKey:@"result"];
                _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];
                
                if (_uid != nil)
                {
                    //注册环信
                    [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                }
                
                if ([[_vcUtil CheckRole] isEqualToString:CHINESEUSER])
                {
                    Information1ViewController *inforVC = [[Information1ViewController alloc]init];
                    inforVC.uID = _uid;

                    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                    TalkLog(@"UID == %@",_uid);
                    [self.navigationController pushViewController:inforVC animated:YES];
                }
                else
                {
                    Foreigner1ViewController *foreigVC = [[Foreigner1ViewController alloc]init];
                    foreigVC.uID = _uid;
                    
                    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                    TalkLog(@"FUID -- %@",_uid);
                    [self.navigationController pushViewController:foreigVC animated:YES];
                }
                
                NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
          
                [uid setObject:_uid forKey:@"userId"];
                [uid synchronize];
            }
            else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2)) // not the first time
            {
                NSDictionary *dict = [dic objectForKey:@"result"];
                _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                NSString *identity = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                //NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
                NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];

                //FIXME ugly code
                //User choice doesn't match with role in server
                if ([[_vcUtil CheckRole] isEqualToString:CHINESEUSER] && [identity isEqualToString:CHINESEUSER])
                {
                    //talkVC.identity = CHINESEUSER;
                }
                else  if ([[_vcUtil CheckRole] isEqualToString:FOREINERUSER] && [identity isEqualToString:FOREINERUSER])
                {
                    //talkVC.identity = FOREINERUSER;
                }
                else
                {
                    [ud removeObjectForKey:@"UseApp"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertAccountNotMatchID delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
                    [alert show];
                    ChoosePeopleViewController *choosePeopleVC = [[ChoosePeopleViewController alloc]init];
                    [self.navigationController pushViewController:choosePeopleVC animated:YES];
                    return;
                }

                [ud setObject:@"Done" forKey:@"FinishedInformation"];
                [ud setObject:_uid forKey:@"userId"];
                [ud synchronize];
                
                TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
                talkVC.uid = _uid;
                TalkLog(@"User ID: %@",talkVC.uid);
                [self presentViewController:talkVC animated:YES completion:nil];
                
                //FIXME refine the login / signup
                [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                //[EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败 ＝＝ %@",error);
            [MBProgressHUD showError:kAlertNetworkError];
            return;
        }];
        
    }
    else
    {
        
#warning 判断邮箱格式
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        // 邮箱登录
        if (![emailTest evaluateWithObject:_loginmobileTF.text])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if (_loginmobileTF.text.length == 0 | _passwordTF.text.length ==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertCodeEmpty delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            [_passwordTF.text md5String];
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSDictionary *dic1 = @{@"cmd":@"14",
                                   @"email":_loginmobileTF.text,
                                   @"password":_passwordTF.text,
                                   
                                   };
            
            [session POST:PATH_GET_CODE parameters:dic1 progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dic = [solveJsonData changeType:responseObject];
                NSLog(@"success:%@",dic);
                if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
                {
                    NSDictionary *dict = [dic objectForKey:@"result"];
                    _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];

                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:@"Done" forKey:@"FinishedInformation"];

                    if ([[_vcUtil CheckRole] isEqualToString:CHINESEUSER])
                    {
                        //talkVC.identity = CHINESEUSER;
                    }
                    else if([[_vcUtil CheckRole] isEqualToString:FOREINERUSER])
                    {
                        //talkVC.identity = FOREINERUSER;
                    }
                    else
                    {
                        [ud removeObjectForKey:@"UseApp"];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertAccountNotMatchID delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
                        [alert show];
                        ChoosePeopleViewController *choosePeopleVC = [[ChoosePeopleViewController alloc]init];
                        [self.navigationController pushViewController:choosePeopleVC animated:YES];
                        return;
                    }
                    
                    [ud setObject:_uid forKey:@"userId"];
                    [ud synchronize];
                    
                    TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
                    talkVC.uid = _uid;
                    [self.navigationController presentViewController:talkVC animated:NO completion:nil];
                    //if (_uid != nil)
                    //{
                        //注册环信
                    //    [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                    //}
                    
                    //登陆环信
                    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];

                }
                else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 5))
                {
                    NSDictionary *dict = [dic objectForKey:@"result"];
                    _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:_uid forKey:@"userId"];
                    [ud synchronize];
                    
                    if (_uid != nil)
                    {
                        [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                    }
                    
                    if ([[_vcUtil CheckRole] isEqualToString:CHINESEUSER])
                    {
                        Information1ViewController *inforVC = [[Information1ViewController alloc]init];
                        inforVC.uID = _uid;
                        [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                        TalkLog(@"UID == %@",_uid);
                        [self.navigationController pushViewController:inforVC animated:YES];
                        
                    }
                    else
                    {
                        Foreigner1ViewController *foreigVC = [[Foreigner1ViewController alloc]init];
                        foreigVC.uID = _uid;
                       
                        [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                        TalkLog(@"FUID -- %@",_uid);
                        [self.navigationController pushViewController:foreigVC animated:YES];
                        
                    }
                    
                }
                else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 7) )
                {
                    [MBProgressHUD showError:kAlertPasswordWrong];
                    return ;
                }
                else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4) )
                {
                    //FIXME to figure out wrong password or id
                    [MBProgressHUD showError:kAlertPasswordWrong];
                    return;
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                [MBProgressHUD showError:kAlertNetworkError];
                return;
            }];
            
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_loginmobileTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}
-(void)forgetPassword
{
    ForgetPasswordViewController *password = [[ForgetPasswordViewController alloc]init];
    password.loginVC = self;
    password.titleText = AppForgetPassword;
    password.telMailNum = self.loginmobileTF.text;
    [self.navigationController pushViewController:password animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//三方登录 post请求上传uid
- (void) postUid
{

//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    //接口
//    NSString *urlStr = SETUPSHOPNAMEANDIMAGE;
//    //
//    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
//
//    //需要的key值
//    paramDic[@"shop_name"] = self.textField.text;
//    NSData* imgData = UIImagePNGRepresentation(self.goBtn.imageView.image);
//    paramDic[@"pic"] =imgData;
//  
//    paramDic[@"merchant_id"] = @"1";
//  
//    paramDic[@"token"] =@"1";
//    NSLog(@"usrStr == %@,paramDic ===> %@",urlStr,paramDic);
//    [session POST:urlStr parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"请求成功 ＝＝＝＝＝ 》%@",responseObject);
//        UIAlertView * alertFailed = [[UIAlertView alloc]initWithTitle:@"注册成功" message:@"" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        
//        [alertFailed show];
//        [self.navigationController pushViewController:[[MyStoreViewController alloc]init] animated:NO];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"请求失败 ＝＝＝＝＝ 》%@",error);
//        UIAlertView * alertFailed = [[UIAlertView alloc]initWithTitle:@"注册失败" message:[NSString stringWithFormat:@"error:%@",error] delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        [alertFailed show];
//    }];
//}

}



@end
