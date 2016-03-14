//
//  Foreigner2ViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/25.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "Foreigner2ViewController.h"
#import "DailysettingViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Check.h"
#import "solveJsonData.h"
@interface Foreigner2ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UILabel *label;

@property (nonatomic,strong)UITextField *cardnumber;
@property (nonatomic,strong)UITextField *holdername;

@property (nonatomic,strong)UITextField *mmyy;
@property (nonatomic,strong)UITextField *ccv;

@end

@implementation Foreigner2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = @"Information (3/3)";
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    self.navigationItem.titleView = title;
    
    [self navigaTitle];
    
    [self layoutView];
}
-(void)navigaTitle
{
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
-(void)layoutView
{
    self.label = [[UILabel alloc]init];
    _label.frame = CGRectMake(0, 84, kWidth, 20);
    _label.text = @"Bank section:";
    _label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    _label.numberOfLines =0;
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    self.cardnumber = [[UITextField alloc]init];
    _cardnumber.frame = kCGRectMake(50, 130, 277.77, 60);
    _cardnumber.placeholder =@"card number";
    _cardnumber.keyboardType = UIKeyboardTypeNumberPad;
    _cardnumber.delegate = self;
    _cardnumber.tag = 100;
    _cardnumber.textAlignment = NSTextAlignmentCenter;
    [_cardnumber setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    [self.view addSubview:_cardnumber];
    
    self.holdername = [[UITextField alloc]init];
    _holdername.frame = kCGRectMake(50, 195, 277.77, 60);
    [_holdername setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    _holdername.placeholder =@"holder name";
//    _holdername.keyboardType = UIKeyboardTypeNumberPad;
    _holdername.delegate = self;
    _holdername.tag = 101;
    _holdername.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_holdername];
    
    self.mmyy = [[UITextField alloc]init];
    _mmyy.frame = kCGRectMake(50, 265, 131.385, 60);
    [_mmyy setBackground:[UIImage imageNamed:@"login_input_small.png"]];
    _mmyy.placeholder = @"mm / yy";
    _mmyy.keyboardType = UIKeyboardTypeNumberPad;
    _mmyy.delegate = self;
    _mmyy.tag = 102;
    _mmyy.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_mmyy];
    
    self.ccv = [[UITextField alloc]init];
    _ccv.frame = kCGRectMake(196.385, 265,131.385 , 60);
    [_ccv setBackground:[UIImage imageNamed:@"login_input_small.png"]];
    _ccv.placeholder = @"ccv";
    _ccv.keyboardType = UIKeyboardTypeNumberPad;
    _ccv.delegate = self;
    _ccv.tag = 103;
    _ccv.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_ccv];
}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
{
    Check *checkNum = [[Check alloc]init];
    if (![checkNum validateBankCardNumber:_cardnumber.text]) {
        [MBProgressHUD showError:kAlertcardFormat];
        return;
    }
    if (_cardnumber.text.length == 0) {
        [MBProgressHUD showError:kAlertCardEmpty];
        return;
    }
    if (_cardnumber.text.length > 17) {
        [MBProgressHUD showError:kAlertLenghtEmpty];
        return;
    }
    if (_holdername.text.length ==0) {
        [MBProgressHUD showError:kAlertcardNameEmpty];
        return;
    }
    if (_mmyy.text.length ==0) {
        [MBProgressHUD showError:kAlertDateEmpty];
        return;
    }
    if (_ccv.text.length == 0) {
        [MBProgressHUD showError:kAlertCCVEmpty];
        return;
    }
    if (_ccv.text.length >3) {
        [MBProgressHUD showError:kAlertLenghtEmpty];
        return;
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"cmd"]  = @"9";
    parame[@"user_id"] = _iD;
    parame[@"number"] = _cardnumber.text;
    parame[@"name"]  = _holdername.text;
    parame[@"validity"] = _mmyy.text;
    parame[@"ccv"] = _ccv.text;
    [session POST:PATH_GET_LOGIN parameters:parame progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        TalkLog(@"上传银行卡信息成功 -- %@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TalkLog(@"上传银行卡信息失败 -- %@",error);
        
    }];
    
    
    DailysettingViewController *dailyVC = [[DailysettingViewController alloc]init];
    dailyVC.iD = _iD;
    [self.navigationController pushViewController:dailyVC animated:NO];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_ccv resignFirstResponder];
    [_mmyy resignFirstResponder];
    [_cardnumber resignFirstResponder];
    [_holdername resignFirstResponder];
    
    
}
#pragma mark - 输入长度限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger strLength = textField.text.length - range.length + string.length;
    if (textField.tag == 100) {
        
        if (strLength >16) {
            [MBProgressHUD showError:kAlertLenghtEmpty];
            return NO;
        }
    }else if (textField.tag == 101){
        if (strLength >60) {
            return NO;
        }
        
    }else if (textField.tag == 102){
        if (strLength >20) {
            return NO;
        }
         
    }else if (textField.tag == 103){
        if (strLength >3) {
            [MBProgressHUD showError:kAlertLenghtEmpty];
            return NO;
        }
        
    }
    
    return YES;
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
