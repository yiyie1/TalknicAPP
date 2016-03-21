//
//  ForgetPasswordViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/19.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "MBProgressHUD+MJ.h"
#import "Check.h"
#import "LoginViewController.h"

@interface ForgetPasswordViewController ()
{
    UITextField *_mobileTF;
    UITextField *_codeTF;
    NSDictionary *_dic;
    NSString *captcha;
}
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UIButton *sendBtn;
@property (nonatomic,strong)UITextField *ewPassword;
@property (nonatomic,strong)UITextField *confirmPassword;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = self.titleText;//@"Forget Password";
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
    [self forgetPass];
    [self forgeMobile];
    [self sendBT];
    [self codeBT];
    [self newPassword];
    [self confirmpassWord];
      
}
-(void)forgetPass
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = kCGRectMake(0, 0, 7, 11.5);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Reset" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)forgeMobile
{
    _mobileTF = [[UITextField alloc]init];
    _mobileTF.frame = kCGRectMake(45,  84, 275, 50);
    _mobileTF.placeholder = AppCellNum;//AppCellOrEmail;
    _mobileTF.text = self.telMailNum;
    _mobileTF.textAlignment = NSTextAlignmentCenter;
    [_mobileTF setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    [self.view addSubview:_mobileTF];
}
-(void)sendBT
{
    self.sendBtn = [[UIButton alloc]init];
    _sendBtn.frame = kCGRectMake(45, 150, 130, 50);
    [_sendBtn setTitle:AppSend forState:(UIControlStateNormal)];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_100%.png"] forState:(UIControlStateNormal)] ;
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_100%_a.png"] forState:(UIControlStateHighlighted)];
    [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_sendBtn];
}

-(void)codeBT
{
    _codeTF = [[UITextField alloc]init];
    _codeTF.frame = kCGRectMake(190, 150, 130, 50);
    _codeTF.placeholder = AppCode;
    _codeTF.textAlignment = NSTextAlignmentCenter;
    [_codeTF setBackground:[UIImage imageNamed:@"login_btn_100%.png"]];
    [self.view addSubview:_codeTF];
    
}

-(void)newPassword
{
    self.ewPassword = [[UITextField alloc]init];
    _ewPassword.frame = kCGRectMake(45,220,275, 50);
    _ewPassword.placeholder =@"New Password";
    _ewPassword.secureTextEntry = YES;
    _ewPassword.textAlignment = NSTextAlignmentCenter;
    [_ewPassword setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    [self.view addSubview:_ewPassword];
}

-(void)confirmpassWord
{
    self.confirmPassword = [[UITextField alloc]init];
    _confirmPassword.frame = kCGRectMake(45, 290, 275, 50);
    _confirmPassword.placeholder =AppConfirmPassword;
    _confirmPassword.secureTextEntry = YES;
    _confirmPassword.textAlignment = NSTextAlignmentCenter;
    [_confirmPassword setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    [self.view addSubview:_confirmPassword];
}

-(void)sendBtnAction
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    Check *checkNum = [[Check alloc]init];
    if ([checkNum isMobileNumber:_mobileTF.text])
    {
        _mobile = YES;
    }
    else if ([emailTest evaluateWithObject:_mobileTF.text])
    {
        _mobile = NO;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    //判断电话号码
    if (_mobileTF.text.length != 11 ) {
        
        [MBProgressHUD showError:kAlertPhoneNumberNotCorrect];
        return;
    }
    
    NSString *userphoneText = _mobileTF.text;
    if (userphoneText.length == 0) {
        [MBProgressHUD showError:kAlertEnterThePhoneNumber];
        return;
    }
    
    //1.请求管理者
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    if(_mobile)
    {
    //2.拼接请求参数
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"cmd"] = @"4";
    parmas[@"tel"] = _mobileTF.text;
    
    [session GET:PATH_GET_LOGIN parameters:parmas success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"result: %@",responseObject);
        //        //取出验证码
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )
        {
            NSDictionary *dict = [dic objectForKey:@"result"];
            captcha = [NSString stringWithFormat:@"%@",[dict objectForKey:@"captcha"]];
            [MBProgressHUD showSuccess:kAlertverificationSent];
            NSLog(@"%@",captcha);
            
        }
        else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4) )
        {
            [MBProgressHUD showError:kAlertunregisteredPhoneNumber];
        }
        else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 3))
        {
            [MBProgressHUD showError:kAlertfaildePhoneNumber];
            
        }
        NSLog(@"成功 = %@",dic);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"code00:%@",error);
        NSLog(@"失败");
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
    }
    else
    {
        //TODO mail
    }
}

-(void)leftAction
{
    if(self.loginVC)
    {
        self.loginVC.loginmobileTF.text = _mobileTF.text;
        self.loginVC.passwordTF.text = _ewPassword.text;
        self.loginVC.mobile = _mobile;
        [self.navigationController popToViewController:self.loginVC animated:YES];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction
{
    NSString *codeText = _codeTF.text;
    if (![codeText isEqualToString:captcha]) {
        [MBProgressHUD showError:kAlertCodeFail];
        return;
    }
    if (![_ewPassword.text isEqualToString:_confirmPassword.text]) {
        [MBProgressHUD showError:kAlertPasstouch];
        return;
    }
    
    if (_ewPassword.text.length < 6) {
        [MBProgressHUD showError:kAlert6];
        return;
    }
    if (_ewPassword.text.length > 16 || _confirmPassword.text.length > 16) {
        [MBProgressHUD showError:kAlert16];
        return;
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cmd"] = @"5";
    dic[@"tel"] = _mobileTF.text;
    dic[@"captcha"] = _codeTF.text;
    dic[@"password"] = _ewPassword.text;
    dic[@"repassword"] = _confirmPassword.text;
    
    [session POST:PATH_GET_LOGIN parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"result ＝ %@",responseObject);
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )
        {
            [MBProgressHUD showSuccess:kAlertPassChangeSuccess];
            [self leftAction];
        }
        else
        {
            [MBProgressHUD showError:kAlertdataFailure];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TalkLog(@"失败 ＝＝ %@ ",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_codeTF resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    [_mobileTF resignFirstResponder];
    [_ewPassword resignFirstResponder];
    
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
