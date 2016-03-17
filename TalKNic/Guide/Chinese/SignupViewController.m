//
//  SignupViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "SignupViewController.h"
#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
#import "Check.h"
#import <MessageUI/MessageUI.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate.h"
#import "EaseMobSDK.h"
#import "TalkTabBarViewController.h"
#import "InformationViewController.h"
#import "Foreigner0ViewController.h"
#import "ChoosePeopleViewController.h"

#define kMobilewF 275

#define kWidth2  [UIScreen mainScreen].bounds.size.width/320
#define kHeight2 [UIScreen mainScreen].bounds.size.height/480
@interface SignupViewController ()<UITextFieldDelegate>
{
    NSDictionary *_dic;
    NSString *captcha;
    UITextField *_mobilenoTF;
    BOOL mobile;
    NSString *_yanZhen;//邮箱验证码
    NSString * _uid;
    NSDictionary *_dicc;
    //第三方专用
    NSString *_weiboId;
    
}
@property (nonatomic,strong)UIButton *sendBt;
@property (nonatomic,strong)UITextField *codeTF;
@property (nonatomic,strong)UIButton *emailBt;
@property (nonatomic,strong)UIButton *facebookBt;
@property (nonatomic,strong)UIButton *weixinBt;
@property (nonatomic,strong)UIButton *weiboBt;
@property (nonatomic,strong)UIImageView *imageViewD;
@property (nonatomic,strong)UIButton *leftBt;
@property (nonatomic,strong)UIButton *loginBtn;
@property (nonatomic,strong)UIAlertView *alert;
@property (nonatomic,copy)NSString *identity;

@end
@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mobile = YES;
    _dic = [NSDictionary dictionary];
    
    [self createanView];
    
    
}

-(void)createanView
{
    [self mobileTF];
    [self sendbt];
    [self codebt];
    [self emailbt];
    [self facebookbt];
    [self weixinbt];
    [self weibobt];
    [self imageviewD];
    [self loginbt];
}
-(void)imageviewD
{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppCreateAccount;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
}

-(void)mobileTF
{
    
    _mobilenoTF = [[UITextField alloc]init];
    _mobilenoTF.frame = kCGRectMake( 36, 89,302.5 , 56.5) ;
    _mobilenoTF.placeholder = AppCellNum;
    _mobilenoTF.delegate = self;
    _mobilenoTF.textAlignment = NSTextAlignmentCenter;
    [_mobilenoTF setBackground:[UIImage imageNamed:kInputLg]];
    
    //键盘格式
    //    _mobilenoTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_mobilenoTF];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"%d  %@  %d",[_mobilenoTF.placeholder isEqualToString:AppEmail],_mobilenoTF.placeholder,[_mobilenoTF.text containsString:@"@"]);
    if ([_mobilenoTF.placeholder isEqualToString:AppEmail]) {
        if (![_mobilenoTF.text containsString:@"@"]) {
//            [MBProgressHUD showError:kAlertEmailError];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}

-(void)sendbt
{
    
    self.sendBt = [[UIButton alloc]init];
    _sendBt.frame = kCGRectMake(36.5, 151.5, 140.5, 54.5);
    [_sendBt setBackgroundImage:[UIImage imageNamed:kSendBtn] forState:(UIControlStateNormal)];
    [_sendBt setBackgroundImage:[UIImage imageNamed:kSendBtnHigh] forState:(UIControlStateHighlighted)];
    [_sendBt setTitle:AppSend forState:(UIControlStateNormal)];
    [_sendBt addTarget:self action:@selector(sendAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.leftBt = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    _leftBt.frame =kCGRectMake(0, 0, 7, 11.5);
    [_leftBt setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBt addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBt];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.view addSubview:_sendBt];
    
}
-(void)codebt
{
    self.codeTF = [[UITextField alloc]init];
    _codeTF.frame = kCGRectMake(198.5,  151.5, 140.5, 54.5);
    _codeTF.placeholder = AppCode;
    _codeTF.textAlignment = NSTextAlignmentCenter;
    [_codeTF setBackground:[UIImage imageNamed:@"login_btn_100%.png"]];
    //键盘格式
    //    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    //    _codeTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_codeTF];
    
    UILabel *label1 = [[UILabel alloc ]init];
    label1.frame = kCGRectMake(40, 298, 70, 2);
    [label1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_line_side_a.png"]]];
    [self.view addSubview:label1];
    UILabel *label2 = [[UILabel alloc]init];
    label2.frame = kCGRectMake(130, 282.5 , 140, 24);
    label2.text = AppOtherFastSignup;
    label2.font = [UIFont fontWithName:kHelveticaLight size:14];
    
    
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.frame = kCGRectMake( 270, 298, 70, 2);
    [label3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_line_side_a.png"]]];
    [self.view addSubview:label3];
    
    
}
-(void)loginbt
{
    self.loginBtn = [[UIButton alloc]init];
    _loginBtn.frame = kCGRectMake( 36, 211.5, 302.5, 56.5);
    [_loginBtn setTitle:AppSignup forState:(UIControlStateNormal)];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_lg_a.png"] forState:(UIControlStateNormal)];
    [_loginBtn addTarget:self action:@selector(loginupAciton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_loginBtn];
}

-(void)emailbt
{
    
    self.emailBt = [[UIButton alloc]init];
    _emailBt.frame = kCGRectMake(40, 318, 60, 60);
    [_emailBt setBackgroundImage:[UIImage imageNamed:@"login_mail.png"] forState:(UIControlStateNormal)];
    [_emailBt setBackgroundImage:[UIImage imageNamed:@"login_mail_a.png"] forState:(UIControlStateHighlighted)];
    [_emailBt addTarget:self action:@selector(emailBtAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_emailBt];
}
-(void)facebookbt
{
    self.facebookBt = [[UIButton alloc]init];
    _facebookBt.frame = kCGRectMake( 120, 318, 60, 60);
    [_facebookBt setBackgroundImage:[UIImage imageNamed:@"login_fb.png"] forState:(UIControlStateNormal)];
    [_facebookBt setBackgroundImage:[UIImage imageNamed:@"login_fb.png"] forState:(UIControlStateHighlighted)];
    [self.view addSubview:_facebookBt];
}
-(void)weixinbt
{
    self.weixinBt = [[UIButton alloc]init];
    _weixinBt.frame = kCGRectMake(200, 318, 60, 60);
    [_weixinBt setBackgroundImage:[UIImage imageNamed:@"login_wechat.png"] forState:(UIControlStateNormal)];
    [_weixinBt setBackgroundImage:[UIImage imageNamed:@"login_wechat_a.png"] forState:(UIControlStateHighlighted)];
    [_weixinBt addTarget:self action:@selector(weixinLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_weixinBt];
}
-(void)weibobt
{
    self.weiboBt = [[UIButton alloc]init];
    _weiboBt.frame = kCGRectMake( 280, 318, 60, 60);
    [_weiboBt setBackgroundImage:[UIImage imageNamed:@"login_weibo.png"] forState:(UIControlStateNormal)];
    [_weiboBt setBackgroundImage:[UIImage imageNamed:@"login_weibo_a.png"] forState:(UIControlStateHighlighted)];
    [self.view addSubview:_weiboBt];
    [_weiboBt addTarget:self action:@selector(weiboLogin) forControlEvents:(UIControlEventTouchUpInside)];
    UILabel *label4 = [[UILabel alloc]init];
    label4.frame = kCGRectMake(40, 395 , 300, 2);
    [label4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_line_bold.png"]]];
    [self.view addSubview:label4];
    
    
    UIView *labelView = [[UIView alloc]init];
    labelView.frame = kCGRectMake(40, 412, 300, 14);
    [self.view addSubview:labelView];
    UILabel *label5 = [[UILabel alloc]init];
    label5.frame = kCGRectMake(0, 0, 120, 7);

    label5.text = @"注册即代表同意[";
    label5.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    label5.font = [UIFont systemFontOfSize:13.0];
    label5.textAlignment = NSTextAlignmentRight;

    [labelView addSubview:label5];
    
    UIImageView *imageTalk = [[UIImageView alloc]init];
    imageTalk.frame = CGRectMake(CGRectGetMaxX(label5.frame), 0, 25, 8);

    imageTalk.image = [UIImage imageNamed:@"talknic_font_blue.png"];
    [labelView addSubview:imageTalk];
    
    UILabel *label9 = [[UILabel alloc]init];
    label9.frame = CGRectMake(CGRectGetMaxX(imageTalk.frame), 0, 161, 7);

    label9.text = @"]服务条款和隐私条款";
    label9.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    label9.font = [UIFont systemFontOfSize:13.0];
    label9.textAlignment = NSTextAlignmentLeft;
    [labelView addSubview:label9];
    
    
}

-(void)sendAction
{
    
    if (mobile == YES)
    {
        NSString *userphoneText = _mobilenoTF.text;
        if (userphoneText.length != 0) {
            //判断电话号码
            if (_mobilenoTF.text.length != 11) {
                [MBProgressHUD showError:kAlertPhoneNumberNotCorrect];
                return;
            }else {
                Check *checkNum = [[Check alloc]init];
                if (![checkNum isMobileNumber:_mobilenoTF.text]) {
                    [MBProgressHUD showError:kAlertPhoneNumberFormatWrong];
                    return;
                }
            }
        }else {
            [MBProgressHUD showError:kAlertEnterThePhoneNumber];
            return;
        }
        
        //1.请求管理者
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //2.拼接请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"cmd"] = @"1";
        params[@"tel"] = _mobilenoTF.text;
        
        [session GET:PATH_GET_CODE parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            //        //取出验证码
            NSDictionary *dic = [solveJsonData changeType:responseObject];
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )  {
                NSDictionary *dict = [dic objectForKey:@"result"];
                captcha = [NSString stringWithFormat:@"%@",[dict objectForKey:@"captcha"]];
                NSLog(@"%@",captcha);
                [MBProgressHUD showSuccess:kAlertverificationSent];
            }
            if (([[dic objectForKey:@"code"] isEqualToString:@"4"]) ) {
                [MBProgressHUD showError:kAlertregisteredPhoneNumber];
            }
            
            NSLog(@"成功 = %@",dic);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"code00:%@",error);
            NSLog(@"失败");
            [MBProgressHUD showError:kAlertNetworkError];
            return;
        }];
        
    }else{
        
#warning 判断邮箱格式
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        // 邮箱登录
        if (![emailTest evaluateWithObject:_mobilenoTF.text]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
//
//        if (_mobilenoTF.text.length == 0) {
//            [MBProgressHUD showError:kAlertenterEmailAddress];
//            
//        }else{
        
            
            //1.请求管理者
            
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            //2.拼接请求参数
            
            NSDictionary *dic = @{@"cmd":@"12",
                                  @"email":_mobilenoTF.text,};
            
            [session POST:PATH_GET_CODE parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success%@",responseObject);
                NSDictionary *youDic = [responseObject objectForKey:@"result"];
                _yanZhen = [youDic objectForKey:@"captcha"];
                [MBProgressHUD showSuccess:kAlertverificationSent];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error%@",error);
                [MBProgressHUD showError:kAlertNetworkError];
                return;
            }];
            
        }
//    }
}

-(void)loginupAciton
{
    if ([_mobilenoTF.placeholder isEqualToString:AppEmail]) {
        if (![_mobilenoTF.text containsString:@"@"]) {
            //            [MBProgressHUD showError:kAlertEmailError];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    //存储用户选择身份
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
    NSString *identity;
    if ([str isEqualToString:@"Chinese"]) {
        identity = @"0";
        TalkLog(@"用户身份3 -- %@",identity);
    }else
    {
        identity = @"1";
        TalkLog(@"用户身份4 -- %@",identity);
    }
    TalkLog(@"用户身份 -- %@",identity);
    
    if (mobile == YES) {
        
        NSString *codeText = self.codeTF.text;
        if (codeText.length == 0 ) {
            [MBProgressHUD showError:kAlertYan];
            return;
        }
        
        if (![codeText isEqualToString:captcha]) {
            [MBProgressHUD showError:kAlertCodeFail];
            NSLog(@"%@",codeText);
            NSLog(@"%@",captcha);
            
            return;
        }
        
        //        else
        //        {
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册成功" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //            [alert show];
        //        }
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"cmd"] = @"2";
        params[@"tel"] = _mobilenoTF.text;
        params[@"captcha"] = captcha;
        params[@"identity"] = identity;
        TalkLog(@"用户身份2 == %@",params);
        [session GET:PATH_GET_CODE parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableDictionary *dic = [solveJsonData changeType:responseObject];
            NSLog(@"--.......%@",dic);
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2)) {
                
                NSDictionary *dict = [dic objectForKey:@"result"];
                _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertPrompt message:kAlertRegister delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
                if (_uid !=nil) {
                    //注册环信
                    [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
                }
                
                
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.telNum = _mobilenoTF.text;
                [self.navigationController pushViewController:loginVC animated:NO];
                
            }
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 3)) {
                [MBProgressHUD showError:@"Verification code error"];//验证码错误
                return ;
            }
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4)) {
                [MBProgressHUD showError:@"Mobile phone number has been registered"];
                return;
            }
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 5)) {
                [MBProgressHUD showError:@"Registration failed"];
                return;
            }
            NSLog(@"success%@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@",error);
            [MBProgressHUD showError:kAlertNetworkError];
            return;
        }];
        
    }
    else
    {
        NSString *codeText = self.codeTF.text;
        if (codeText.length == 0 ) {
            [MBProgressHUD showError:kAlertCode];
            return;
        }
        if (codeText != _yanZhen) {
            [MBProgressHUD showError:kAlertCodeFail];
            return;
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertRegister message:kAlertRegister delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
        }
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        
        NSDictionary *dic = @{@"cmd":@"13",
                              @"email":_mobilenoTF.text,
                              @"captcha":codeText,
                              @"identity":identity,
                              };
        NSLog(@"----->>>>%@",codeText);
        [session POST:PATH_GET_CODE parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success:%@",responseObject);
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@",error);
            [MBProgressHUD showError:kAlertNetworkError];
            return;
        }];
    }
}

//-(void)sendAction
//{
//    
//    if (mobile == YES) {
//        Check *checkNum = [[Check alloc]init];
//        if (![checkNum isMobileNumber:_mobilenoTF.text]) {
//            [MBProgressHUD showError:kAlertPhoneNumberFormatWrong];
//            return;
//        }
//        //判断电话号码
//        if (_mobilenoTF.text.length != 11 ) {
//            
//            [MBProgressHUD showError:kAlertPhoneNumberNotCorrect];
//            return;
//        }
//        
//        NSString *userphoneText = _mobilenoTF.text;
//        if (userphoneText.length == 0) {
//            [MBProgressHUD showError:kAlertEnterThePhoneNumber];
//            return;
//        }
//        [MBProgressHUD showSuccess:kAlertverificationSent];
//        //1.请求管理者
//        
//        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        
//        //2.拼接请求参数
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"cmd"] = @"1";
//        params[@"tel"] = _mobilenoTF.text;
//        
//        [session GET:PATH_GET_CODE parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//            //        //取出验证码
//            NSDictionary *dic = [solveJsonData changeType:responseObject];
//            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )  {
//                NSDictionary *dict = [dic objectForKey:@"result"];
//                captcha = [NSString stringWithFormat:@"%@",[dict objectForKey:@"captcha"]];
//                NSLog(@"%@",captcha);
//                
//            }
//            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4) ) {
//                [MBProgressHUD showError:kAlertregisteredPhoneNumber];
//            }
//            NSLog(@"成功 = %@",dic);
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"code00:%@",error);
//            NSLog(@"失败");
//        }];
//        
//    }else{
//        
//        
//        if (_mobilenoTF.text.length == 0) {
//            [MBProgressHUD showError:kAlertenterEmailAddress];
//            
//        }else{
//            [MBProgressHUD showSuccess:kAlertverificationSent];
//            
//            //1.请求管理者
//            
//            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//            session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//            
//            //2.拼接请求参数
//            
//            NSDictionary *dic = @{@"cmd":@"12",
//                                  @"email":_mobilenoTF.text,};
//            
//            [session POST:PATH_GET_CODE parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//                
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"success%@",responseObject);
//                NSDictionary *youDic = [responseObject objectForKey:@"result"];
//                _yanZhen = [youDic objectForKey:@"captcha"];
//                
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"error%@",error);
//            }];
//            
//        }
//        
//        
//        
//    }
//    
//    
//    
//}
//
//
//
//
//-(void)loginupAciton
//{
//    
//    
//    if ([_mobilenoTF.placeholder isEqualToString:@"Email No."]) {
//        if (![_mobilenoTF.text containsString:@"@"]) {
//            //            [MBProgressHUD showError:kAlertEmailError];
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
//    }
//    
//    //存储用户选择身份
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
//    NSString *identity;
//    if ([str isEqualToString:@"Chinese"]) {
//        identity = @"0";
//        TalkLog(@"用户身份3 -- %@",identity);
//    }else
//    {
//        identity = @"1";
//        TalkLog(@"用户身份4 -- %@",identity);
//    }
//    TalkLog(@"用户身份 -- %@",identity);
//    
//    if (mobile == YES) {
//        NSString *codeText = self.codeTF.text;
//        if (codeText.length == 0 ) {
//            [MBProgressHUD showError:kAlertYan];
//            return;
//        }
//        if (codeText != captcha) {
//            [MBProgressHUD showError:kAlertYan];
//            return;
//        }
//        //        else
//        //        {
//        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册成功" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        //            [alert show];
//        //        }
//        
//        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"cmd"] = @"2";
//        params[@"tel"] = _mobilenoTF.text;
//        params[@"captcha"] = captcha;
//        params[@"identity"] = identity;
//        TalkLog(@"用户身份2 == %@",params);
//        [session GET:PATH_GET_CODE parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSMutableDictionary *dic = [solveJsonData changeType:responseObject];
//            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2)) {
//               
//                NSDictionary *dict = [dic objectForKey:@"result"];
//                _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertPrompt message:kAlertRegister delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
//                if (_uid !=nil) {
//                    //注册环信
//                   [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
//                }
//                
//                
//                LoginViewController *loginVC = [[LoginViewController alloc]init];
//                [self.navigationController pushViewController:loginVC animated:NO];
//
//            }
//            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 3)) {
//                [MBProgressHUD showError:@"Verification code error"];//验证码错误
//                return ;
//            }
//            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4)) {
//                [MBProgressHUD showError:@"Mobile phone number has been registered"];
//                return;
//            }
//            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 5)) {
//                [MBProgressHUD showError:@"Registration failed"];
//                return;
//            }
//            NSLog(@"success%@",responseObject);
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"error%@",error);
//        }];
//        
//    }else{
//        NSString *codeText = self.codeTF.text;
//        if (codeText.length == 0 ) {
//            [MBProgressHUD showError:kAlertCode];
//            return;
//        }
//        if (codeText != _yanZhen) {
//            [MBProgressHUD showError:kAlertCodeFail];
//            return;
//        }else
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertRegister message:kAlertRegister delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//
//        
//        NSDictionary *dic = @{@"cmd":@"13",
//                              @"email":_mobilenoTF.text,
//                              @"captcha":codeText,
//                              @"identity":identity,
//                              };
//        NSLog(@"----->>>>%@",codeText);
//        [session POST:PATH_GET_CODE parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"success:%@",responseObject);
//            LoginViewController *loginVC = [[LoginViewController alloc]init];
//            [self.navigationController pushViewController:loginVC animated:NO];
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"error:%@",error);
//        }];
//        
//    }
//    
//    
//    
//}


-(void)weixinLogin
{
    [ShareSDK getUserInfo:(SSDKPlatformTypeWechat) onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
            NSString *idtent;
            if ([str isEqualToString:@"Chinese"]) {
                idtent = @"0";
            }else{
                idtent = @"1";
            }

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSMutableDictionary *dice = [NSMutableDictionary dictionary];
            dice[@"cmd"] = @"333";
            dice[@"login_type"] = @"wechat";
            dice[@"unique_identification"] = user.uid ;
            dice[@"identity"] = idtent;
            
            [manager POST:PATH_GET_LOGIN parameters:dice progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                TalkLog(@"uid = %@ , token = %@ ,nickname = %@",user.uid,user.credential.token,user.nickname);
                TalkLog(@"微信 -- %@",responseObject);
                  _dicc = [solveJsonData changeType:responseObject];
                if (([(NSNumber *)[_dicc objectForKey:@"code"] intValue] == 2)){
                    NSDictionary *dict = [_dicc objectForKey:@"result"];
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
                    [uid setObject:usData forKey:@"ccUID"];
                    [uid setObject:_uid forKey:@"userId"];
                    [uid synchronize];

                }
                else if (([(NSNumber *)[_dicc objectForKey:@"code"] intValue] == 5))
                {
                    
                    NSDictionary *dict = [_dicc objectForKey:@"result"];
                    _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    _weiboId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
                    if (_uid !=nil) {
                        NSLog(@"------------%@",_uid);
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
                    
                    TalkLog(@"UID == %@",_uid);
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
                    
                    if ([str isEqualToString:@"Chinese"]&&[_weiboId isEqualToString:@"0"]) {
                        InformationViewController *inforVC = [[InformationViewController alloc]init];
                        
                        [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                        inforVC.uID = _uid;
                        [self.navigationController pushViewController:inforVC animated:NO];
                    }
                    else
                    {
                        Foreigner0ViewController *foreigVC = [[Foreigner0ViewController alloc]init];
                        
                        [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                        foreigVC.uID = _uid;
                        [self.navigationController pushViewController:foreigVC animated:NO];
                    }
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error%@",error);
                [MBProgressHUD showError:kAlertNetworkError];
                return;
            }];
            
        
        }else
        {
            TalkLog(@"Wechat Failure");
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

            TalkLog(@"uid = %@  %@  token = %@ nickname = %@",user.uid,user.credential,user.credential.token,user.nickname);
            TalkLog(@"Weibo user information: %@",user.rawData);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"cmd"] = @"333";
            dic[@"login_type"] = @"sina";
            dic[@"unique_identification"] = user.uid ;
            dic[@"identity"] = idtent;
            NSLog(@"----====%@",_identitt);
            [manager POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                TalkLog(@"Weibo -- %@",responseObject);
                _dicc = [solveJsonData changeType:responseObject];
                
        if (([(NSNumber *)[_dicc objectForKey:@"code"] intValue] == 2)) //2 mean already signed
        {
            NSDictionary *dict = [_dicc objectForKey:@"result"];
            _weiboId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"identity"]];
            _uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
            if (_uid !=nil) {
                //注册环信
                [EaseMobSDK easeMobRegisterAppWithAccount:_uid password:KHuanxin HUDShowInView:self.view];
            }

            if ([self initTalkViewControllerByThirdPlatform] == -1)
                return;
            
            NSData * usData = [_uid dataUsingEncoding:NSUTF8StringEncoding];
            NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
            [uid setObject:usData forKey:@"ccUID"];
            [uid setObject:_uid forKey:@"userId"];
            [uid synchronize];
        }
        else if (([(NSNumber *)[_dicc objectForKey:@"code"] intValue] == 5))    //5 means first sign up
        {
            
            NSDictionary *dict = [_dicc objectForKey:@"result"];
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

            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *str = [ud objectForKey:kChooese_ChineseOrForeigner];
            
            if ([str isEqualToString:@"Chinese"]&&[_weiboId isEqualToString:@"0"])
            {
                InformationViewController *inforVC = [[InformationViewController alloc]init];
                
                [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                inforVC.uID = _uid;
                [self.navigationController pushViewController:inforVC animated:NO];
                
            }else
            {
                Foreigner0ViewController *foreigVC = [[Foreigner0ViewController alloc]init];
                
                [EaseMobSDK easeMobLoginAppWithAccount:_uid password:KHuanxin isAutoLogin:NO HUDShowInView:self.view];
                foreigVC.uID = _uid;
                [self.navigationController pushViewController:foreigVC animated:NO];
                
            }
        }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error%@",error);
                [MBProgressHUD showError:kAlertNetworkError];
                return;
            }];

        }
        else
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

-(void)emailBtAction
{
    mobile = mobile ? NO : YES;
    if(mobile)
    {
        _mobilenoTF.placeholder = AppCellNum;
    }
    else
    {
        _mobilenoTF.placeholder = AppEmail;
    }
    
    //Check *checkEm = [[Check alloc]init];
    
}
//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_codeTF resignFirstResponder];
    [_mobilenoTF resignFirstResponder];
}


-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
