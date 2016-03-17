//
//  QaViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/16.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "QaViewController.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "MBProgressHUD+MJ.h"

@interface QaViewController ()
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UIButton *RightBT;
@property (nonatomic,strong)UITextView* textView;
@property (nonatomic,strong)UITextField* EmailFeild;
@property (nonatomic,strong)UITextField* NameFeild;
@property(strong,nonatomic)NSDictionary  *dict;

@end

@implementation QaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppQA;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
    
     _dict = [NSDictionary dictionary];
    
    [self layoutLeftBT];
    [self layoutView];
}
-(void)layoutLeftBT
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 10, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
    
    self.RightBT = [[UIButton alloc]init];
    _RightBT.frame = CGRectMake(0, 10, 45, 31/2);
    [_RightBT setTitle:@"Send" forState:(UIControlStateNormal)];//setBackgroundImage:[UIImage imageNamed:@"login_btn_send"] forState:(UIControlStateNormal)];
    _RightBT.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    [_RightBT addTarget:self action:@selector(RightAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *RightI = [[UIBarButtonItem alloc]initWithCustomView:_RightBT];
    self.navigationItem.rightBarButtonItem = RightI;
}

-(void)layoutView
{
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 273)];
    [self.view addSubview:_textView];
    UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 273, self.view.frame.size.width, 20)];
    numberLabel.text = @"    400";
    numberLabel.textColor = [UIColor grayColor];
    numberLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:numberLabel];
    
    UIView* line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, numberLabel.frame.origin.y+numberLabel.frame.size.height, self.view.frame.size.width, 1)];
    line_1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line_1];
    
    self.EmailFeild = [[UITextField alloc] initWithFrame:CGRectMake(0, line_1.frame.origin.y+2, self.view.frame.size.width, 87/2)];
    _EmailFeild.backgroundColor = [UIColor whiteColor];
    self.EmailFeild.placeholder = @"    Email";
    [self.view addSubview:self.EmailFeild];
    
    UIView* line_2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.EmailFeild.frame.origin.y+self.EmailFeild.frame.size.height, self.view.frame.size.width, 1)];
    line_2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line_2];
    
    self.NameFeild = [[UITextField alloc] initWithFrame:CGRectMake(0, line_2.frame.origin.y+line_2.frame.size.height, self.view.frame.size.width, 87/2)];
    self.NameFeild.placeholder = @"    Name";
    [self.view addSubview:self.NameFeild];
    _NameFeild.backgroundColor = [UIColor whiteColor];
    
    
    UIView* line_3 = [[UIView alloc] initWithFrame:CGRectMake(0, self.NameFeild.frame.origin.y+self.NameFeild.frame.size.height, self.view.frame.size.width, 1)];
    line_3.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line_3];
}



-(void)RightAction
{
    TalkLog(@"Send");
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSData *usData = [userD objectForKey:@"ccUID"];
    NSString *uID = [[NSString alloc]initWithData:usData encoding:NSUTF8StringEncoding];
    
#warning 判断邮箱格式
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    // 邮箱登录
    NSLog(@"%d",[emailTest evaluateWithObject:_EmailFeild.text]);
    if (![emailTest evaluateWithObject:_EmailFeild.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:kAlertPrompt message:kAlertEmailError delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary * dic = @{@"cmd":@"31",
                           @"name":_NameFeild.text,
                           @"mail":_EmailFeild.text,
                           @"content":_textView.text,
                           @"user_id":uID
                           };
    
    
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    [session POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _dict = [solveJsonData changeType:responseObject];
        
        //        NSLog(@"上床问题成功%@****%@",responseObject[@"code"],dic);
        
        if ([responseObject[@"code"]integerValue]==2) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:kAlertNetworkError];
        NSLog(@"error%@",error);
        //return;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"填写有误或内容为空。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
    
    
}



-(void)leftAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
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
