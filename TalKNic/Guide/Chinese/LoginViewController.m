//
//  LoginViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "InformationViewController.h"
#import "SignupViewController.h"
#import "Foreigner0ViewController.h"
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
#define kMobilewF 275

#define KHuanxin @"12345678"
@interface LoginViewController ()
{
    NSDictionary *dic;
    BOOL mobile;//是否是手机登陆
    NSDictionary *_weibo;
    NSString *_weiboId;
    
    NSString *_oldId;
}
@property (nonatomic,strong)UITextField *loginmobileTF;
@property (nonatomic,strong)UITextField *passpordTF;
@property (nonatomic,strong)UIButton *loginBT, *signupBT,*forgetPasspord,*emailBT,*facebookBT,*weixinBT,*weiboBT;
@property (nonatomic,strong)UIImageView *image1;
@property (nonatomic,strong)UIImageView *image2;
@property (nonatomic,strong)UIButton *leftBt;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mobile = YES;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppLogin;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
    [self loginvieww];
    
    self.view.userInteractionEnabled = YES;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data =  [user objectForKey:@"ccUID"];
    _oldId = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [user setBool:YES forKey:@"FirstUseApp"];
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
    _loginmobileTF.text = _telNum;
    _loginmobileTF.placeholder =AppCellNum;
    _loginmobileTF.textAlignment = NSTextAlignmentCenter;
    [_loginmobileTF setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    [self.view addSubview:_loginmobileTF];
    
    
}
-(void)passpord
{
    self.passpordTF = [[UITextField alloc]init];
    _passpordTF.frame = CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y +144, self.view.frame.size.width /1.36, 50);
    _passpordTF.secureTextEntry = YES;
    _passpordTF.layer.cornerRadius = 25;
    _passpordTF.textAlignment = NSTextAlignmentCenter;
    [_passpordTF setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    // _passpordTF.backgroundColor = [UIColor redColor];
    [self.view addSubview:_passpordTF];
    
    _passpordTF.placeholder=AppPassword;
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
    [_weixinBT setBackgroundImage:[UIImage imageNamed:@"login_wechat.png"] forState:(UIControlStateNormal)];
    [_weixinBT setBackgroundImage:[UIImage imageNamed:@"login_wechat_a.png"] forState:(UIControlStateHighlighted)];
    [_weixinBT addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_weixinBT];
    
    self.weiboBT = [[UIButton alloc]init];
    _weiboBT.frame = kCGRectMake(275,390, 60, 60);
    [_weiboBT setBackgroundImage:[UIImage imageNamed:@"login_weibo.png"] forState:(UIControlStateNormal)];
    [_weiboBT addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
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

-(void)weixinLogin
{
    [ShareSDK getUserInfo:(SSDKPlatformTypeWechat) onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSString *identety;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
            if ([str isEqualToString:@"Chinese"]) {
                identety = @"0";
            }else{
                identety = @"1";
            }
            TalkLog(@"uid = %@ , %@  token = %@ ,nickname = %@",user.uid,user.credential,user.credential.token,user.nickname);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSMutableDictionary *weixin = [NSMutableDictionary dictionary];
            weixin[@"cmd"] = @"333";
            weixin[@"login_type"] =@"wechat";
            weixin[@"unique_identification"] = user.uid;
            
            weixin[@"identity"] = identety;
//            NSLog(@"----------->>>>>>>>>>%@",user.uid);
            [manager POST:PATH_GET_LOGIN parameters:weixin progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                TalkLog(@"Wechat login -- %@",responseObject);
                _weibo = [solveJsonData changeType:responseObject];
                if (([(NSNumber *)[_weibo objectForKey:@"code"] intValue] == 2))
                {
                    NSDictionary *dict = [_weibo objectForKey:@"result"];
                    _weiboId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                    _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    if (_uid !=nil) {
                        //注册环信
                        [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                    }

                    if([self initTalkViewControllerByThirdPlatform] == -1)
                        return;
                    
                    NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
                    if (![_oldId isEqualToString:@""]) {
                        if (_oldId != _uid) {
                            [uid setObject:@"" forKey:@"ForeignerID"];
                            [uid setObject:@"" forKey:@"currDate"];
                        }
                    }
                    [uid setObject:_uid forKey:@"userId"];
                    [uid setObject:usData forKey:@"ccUID"];
                    [uid synchronize];
                    
                }
                else if (([(NSNumber *)[_weibo objectForKey:@"code"] intValue] == 5))
                {
                    NSDictionary *dict = [_weibo objectForKey:@"result"];
                    _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    _weiboId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                    if (_uid !=nil)
                    {
                        NSLog(@"uid = %@",_uid);
                        //注册环信
                        [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                    }
                    
                    NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];
                    NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
                    [uid setObject:usData forKey:@"ccUID"];
                     [uid setObject:_uid forKey:@"userId"];
                    [uid synchronize];
                    
                    // 修改
                    [[NSUserDefaults standardUserDefaults] setObject:_uid forKey:@"my_id"];

                    [self initInformation];
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
        }else
        {
            TalkLog(@"WetChat");
            TalkLog(@"%@",error);
        }
        
    }];
}

-(void)weiboLogin
{
    [ShareSDK getUserInfo:(SSDKPlatformTypeSinaWeibo) onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
            NSString *idtent;
            if ([str isEqualToString:@"Chinese"]) {
                idtent = @"0";
            }else{
                idtent = @"1";
            }
            TalkLog(@"uid = %@ , %@  token = %@ ,nickname = %@",user.uid,user.credential,user.credential.token,user.nickname);
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSMutableDictionary *dica = [NSMutableDictionary dictionary];
            dica[@"cmd"] = @"333";
            dica[@"login_type"] = @"sina";
            dica[@"unique_identification"] = user.uid ;
             dica[@"identity"] = idtent;
            [session POST:PATH_GET_LOGIN parameters:dica progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                TalkLog(@"Login Wiebo -- %@",responseObject);
                _weibo = [solveJsonData changeType:responseObject];
                if (([(NSNumber *)[_weibo objectForKey:@"code"] intValue] == 2))    //2 means already login
                {
                    NSDictionary *dict = [_weibo objectForKey:@"result"];
                    _weiboId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                    _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    if (_uid !=nil) {
                        //注册环信
                        [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                    }

                    if([self initTalkViewControllerByThirdPlatform] == -1)
                        return;
                    
                    NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];
                    NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
                    if (![_oldId isEqualToString:@""]) {
                        if (_oldId != _uid) {
                            [uid setObject:@"" forKey:@"ForeignerID"];
                            [uid setObject:@"" forKey:@"currDate"];
                        }
                    }
                    [uid setObject:_uid forKey:@"userId"];
                    [uid setObject:usData forKey:@"ccUID"];
                    [uid synchronize];
                    
                }
                else if (([(NSNumber *)[_weibo objectForKey:@"code"] intValue] == 5))   //5 means 1st time to login
                {
                    
                    NSDictionary *dict = [_weibo objectForKey:@"result"];
                    _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    _weiboId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                    if (_uid !=nil) {
                        NSLog(@"uid = %@",_uid);
                        //注册环信
                        [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                        
                    }
                    
                    NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];
                    NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
                    [uid setObject:usData forKey:@"ccUID"];
                    [uid setObject:_uid forKey:@"userId"];
                    [uid synchronize];
                    
                    // 修改
                    [[NSUserDefaults standardUserDefaults] setObject:_uid forKey:@"my_id"];
                    [self initInformation];
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }else
        {
            TalkLog(@"Weibo Failure");
            TalkLog(@"%@",error);
        }
    }];
}

-(int) initTalkViewControllerByThirdPlatform
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];

    if ([_weiboId isEqualToString:@"0"] && [str isEqualToString:@"Chinese"])  // 0 means Chinese account
    {
        //talkVC.identity = CHINESEUSER;
        //TalkLog(@"Chinese Home -- ID -- %@",talkVC.uid);
    }
    else if([_weiboId isEqualToString:@"1"] && [str isEqualToString:@"Foreigner"])
    {
        //talkVC.identity = FOREINERUSER;
        //TalkLog(@"Foreigner Home -- ID -- %@",talkVC.uid);
    }
    else
    {
        [ud removeObjectForKey:@"FirstUseApp"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertAccountNotMatchID delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
        [alert show];
        //ChoosePeopleViewController *choosePeopleVC = [[ChoosePeopleViewController alloc]init];
        return -1;
    }
    
    TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
    talkVC.uid = _uid;
    [self presentViewController:talkVC animated:YES completion:nil];
    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
    
    return 0;
}

-(void) initInformation
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
    
    if ([str isEqualToString:@"Chinese"])
    {
        InformationViewController *inforVC = [[InformationViewController alloc]init];
        inforVC.uID = _uid;
        [self.navigationController pushViewController:inforVC animated:NO];
        
    }
    else
    {
        Foreigner0ViewController *foreigVC = [[Foreigner0ViewController alloc]init];
        foreigVC.uID = _uid;
        [self.navigationController pushViewController:foreigVC animated:NO];
    }
}

#pragma mark - 登陆方式选择
-(void)emileBt
{
    mobile = !mobile;
    _loginmobileTF.placeholder = mobile == YES ? AppCellNum : AppEmail;
}

-(void)signUP
{
    SignupViewController *createVC = [[SignupViewController alloc]init];
    createVC.identitt = self.identity;
    [self.navigationController pushViewController:createVC animated:NO];
}

-(void)loginAction:(id)sender
{
    
    if (mobile == YES) {
        Check *checkNum = [[Check alloc]init];
        
        if (_loginmobileTF.text.length == 0 | _passpordTF.text.length ==0) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertCodeEmpty delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }else if (![checkNum isMobileNumber:_loginmobileTF.text])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertFalse delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if (_passpordTF.text.length < 6) {
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码长度不能小于6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            [MBProgressHUD showError:kAlert6];
            return;
            
        }
        if (_passpordTF.text.length > 16) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlert16 delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [_passpordTF.text md5String];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
        parmas[@"cmd"] = @"3";
        parmas[@"tel"] = _loginmobileTF.text;
        parmas[@"password"] = _passpordTF.text;
        [session POST:PATH_GET_LOGIN parameters:parmas success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TalkLog(@"denglu成功 == %@",responseObject);
            dic = [solveJsonData changeType:responseObject];
            NSLog(@"登陆%@",dic);
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 7) ){
                [MBProgressHUD showError:kAlertPasswordWrong];
                return ;
            }
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4) ){
                [MBProgressHUD showError:kAlertPasswordWrong];
                return;
            }
            
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 5))
            {

                NSDictionary *dict = [dic objectForKey:@"result"];
                _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                //NSString *identity = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];

                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
                
                if ([str isEqualToString:@"Chinese"]) {
                    InformationViewController *inforVC = [[InformationViewController alloc]init];
                    inforVC.uID = _uid;
                    
                    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                    TalkLog(@"UID == %@",_uid);
                    [self.navigationController pushViewController:inforVC animated:NO];
                    
                }
                else
                {
                    Foreigner0ViewController *foreigVC = [[Foreigner0ViewController alloc]init];
                    foreigVC.uID = _uid;
                    
                    [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                    TalkLog(@"FUID -- %@",_uid);
                    [self.navigationController pushViewController:foreigVC animated:NO];
                }
                
                NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
                if (![_oldId isEqualToString:@""]) {
                    if (_oldId != _uid) {
                        [uid setObject:@"" forKey:@"ForeignerID"];
                        [uid setObject:@"" forKey:@"currDate"];
                    }
                }
                [uid setObject:_uid forKey:@"userId"];
                [uid setObject:usData forKey:@"ccUID"];
                [uid synchronize];
                
                // 修改
                [[NSUserDefaults standardUserDefaults] setObject:_uid forKey:@"my_id"];

            }
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
            {
                NSDictionary *dict = [dic objectForKey:@"result"];
                _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                NSString *identity = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
                NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];

                if ([str isEqualToString:@"Chinese"] && [identity isEqualToString:@"0"])
                {
                    //talkVC.identity = CHINESEUSER;
                }
                else  if ([str isEqualToString:@"Foreigner"] && [identity isEqualToString:@"1"])
                {
                    //talkVC.identity = FOREINERUSER;
                }
                else
                {

                    [ud removeObjectForKey:@"FirstUseApp"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertAccountNotMatchID delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
                    [alert show];
                    //ChoosePeopleViewController *choosePeopleVC = [[ChoosePeopleViewController alloc]init];
                    return;
                }
                TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
                talkVC.uid = _uid;
                TalkLog(@"User ID: %@",talkVC.uid);
                [self presentViewController:talkVC animated:YES completion:nil];
                [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];

                NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
                if (![_oldId isEqualToString:@""]) {
                    if (_oldId != _uid) {
                        [uid setObject:@"" forKey:@"ForeignerID"];
                        [uid setObject:@"" forKey:@"currDate"];
                    }
                }
                [uid setObject:_uid forKey:@"userId"];
                [uid setObject:usData forKey:@"ccUID"];
                [uid synchronize];
                
                // 修改
                [[NSUserDefaults standardUserDefaults] setObject:_uid forKey:@"my_id"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败 ＝＝ %@",error);
            
        }];
        
    }
    else
    {
        
#warning 判断邮箱格式
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        // 邮箱登录
        if (![emailTest evaluateWithObject:_loginmobileTF.text]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
//        // 邮箱登录
//        if (![_loginmobileTF.text containsString:@"@"]) {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
//            [alert show];
//            return;
        
        
        
        if (_loginmobileTF.text.length == 0 | _passpordTF.text.length ==0) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertCodeEmpty delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            [_passpordTF.text md5String];
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSDictionary *dic1 = @{@"cmd":@"14",
                                   @"email":_loginmobileTF.text,
                                   @"password":_passpordTF.text,
                                   
                                   };
            
            [session POST:PATH_GET_CODE parameters:dic1 progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dic = [solveJsonData changeType:responseObject];
                NSLog(@"success:%@",dic);
                if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
                {
                    NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
                    if (![_oldId isEqualToString:@""]) {
                        if (_oldId != _uid) {
                            [uid setObject:@"" forKey:@"ForeignerID"];
                            [uid setObject:@"" forKey:@"currDate"];
                        }
                    }
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
                    
                    if ([str isEqualToString:@"Chinese"])
                    {
                        //talkVC.identity = CHINESEUSER;
                    }
                    else if([str isEqualToString:@"Foreigner"])
                    {
                        //talkVC.identity = FOREINERUSER;
                    }
                    else
                    {
                        [ud removeObjectForKey:@"FirstUseApp"];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertAccountNotMatchID delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
                        [alert show];
                        //ChoosePeopleViewController *choosePeopleVC = [[ChoosePeopleViewController alloc]init];
                        return;
                    }
                    
                    TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
                    talkVC.uid = _uid;
                    [self.navigationController presentViewController:talkVC animated:NO completion:nil];
                    //登陆环信
                    [EaseMobSDK easeMobLoginAppWithAccount:_loginmobileTF.text password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                    
                    [uid setObject:_uid forKey:@"userId"];
                    [uid setObject:usData forKey:@"ccUID"];
                    [uid synchronize];
                    // 修改
                    [[NSUserDefaults standardUserDefaults] setObject:_uid forKey:@"my_id"];
                }
                else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 5))
                {
                    NSDictionary *dict = [dic objectForKey:@"result"];
                    _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    
                    NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
                    if (![_oldId isEqualToString:@""]) {
                        if (_oldId != _uid) {
                            [uid setObject:@"" forKey:@"ForeignerID"];
                            [uid setObject:@"" forKey:@"currDate"];
                        }
                    }
                    [uid setObject:_uid forKey:@"userId"];
                    [uid setObject:usData forKey:@"ccUID"];
                    [uid synchronize];
                    
                    // 修改
                    [[NSUserDefaults standardUserDefaults] setObject:_uid forKey:@"my_id"];
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
                    
                    if ([str isEqualToString:@"Chinese"]) {
                        InformationViewController *inforVC = [[InformationViewController alloc]init];
                        inforVC.uID = _uid;
                      
                        [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                        TalkLog(@"UID == %@",_uid);
                        [self.navigationController pushViewController:inforVC animated:NO];
                        
                    }
                    else
                    {
                        Foreigner0ViewController *foreigVC = [[Foreigner0ViewController alloc]init];
                        foreigVC.uID = _uid;
                       
                        [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                        TalkLog(@"FUID -- %@",_uid);
                        [self.navigationController pushViewController:foreigVC animated:NO];
                        
                    }
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
            }];
            
        }
    }
}

//-(void)popAction
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_loginmobileTF resignFirstResponder];
    [_passpordTF resignFirstResponder];
}
-(void)forgetPassword
{
    ForgetPasswordViewController *password = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:password animated:NO];
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
