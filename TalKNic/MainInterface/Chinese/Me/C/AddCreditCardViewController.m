//
//  AddCreditCardViewController.m
//  TalKNic
//
//  Created by Talknic on 16/1/25.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "AddCreditCardViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
#import "Check.h"
#import "ViewControllerUtil.h"

@interface AddCreditCardViewController ()
{
}
@property (nonatomic,strong)UITextField *cardnumber;
@property (nonatomic,strong)UITextField *holdername;

@property (nonatomic,strong)UITextField *mmyy;
@property (nonatomic,strong)UITextField *ccv;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIButton *leftBT;

@end

@implementation AddCreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewControllerUtil SetTitle:AppNewCreditCard];

    [self addView];

}
-(void)addView
{
    self.leftBT = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _leftBT.frame = CGRectMake(0, 0, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftITem = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftITem;

    self.cardnumber = [[UITextField alloc]init];
     _cardnumber.frame = kCGRectMake(50, 84, 277.77, 60);
    _cardnumber.placeholder =@"card number";
    
    _cardnumber.textAlignment = NSTextAlignmentCenter;
    [_cardnumber setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    [self.view addSubview:_cardnumber];

    self.mmyy = [[UITextField alloc]init];
    _mmyy.frame = kCGRectMake(50, CGRectGetMaxY(_cardnumber.frame) + 30, 131.385, 60);
    _mmyy.keyboardType = UIKeyboardTypeNumberPad; // 修改9
    [_mmyy setBackground:[UIImage imageNamed:@"login_input_small.png"]];
    _mmyy.placeholder = @"mm / yy";
    _mmyy.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_mmyy];
    
    self.ccv = [[UITextField alloc]init];
    _ccv.frame = kCGRectMake(196.385, CGRectGetMaxY(_cardnumber.frame) +30,131.385 , 60);
    _ccv.keyboardType = UIKeyboardTypeNumberPad; // 修改9
    [_ccv setBackground:[UIImage imageNamed:@"login_input_small.png"]];
    _ccv.placeholder = @"ccv";
    _ccv.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_ccv];
    
    self.holdername = [[UITextField alloc]init];
    _holdername.frame = kCGRectMake(50, CGRectGetMaxY(_ccv.frame)+40, 277.77, 60);
    [_holdername setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    _holdername.placeholder =@"holder name";
    _holdername.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_holdername];
    
    self.btn = [[UIButton alloc]init];
    _btn.frame = kCGRectMake(50, CGRectGetMaxY(_holdername.frame)+50, 277.77, 60);
    [_btn setTitle:AppDone forState:(UIControlStateNormal)];
    [_btn addTarget:self action:@selector(doneAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_btn setBackgroundImage:[UIImage imageNamed:@"login_btn_lg_a.png"] forState:(UIControlStateNormal)];
    
    [self.view addSubview:_btn];

}
-(void)doneAction
{
    Check *checkNum = [[Check alloc]init];
    if (![checkNum validateBankCardNumber:_cardnumber.text]) {
        [MBProgressHUD showError:kAlertFormat];
        return;
    }
    if (_cardnumber.text.length == 0) {
        [MBProgressHUD showError:kAlertcardFormat];
        return;
    }
    if (_cardnumber.text.length != 16) {
        [MBProgressHUD showError:kAlertcardLength];
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
        // 修改9 
        [MBProgressHUD showError:kAlertCCVOverLength];
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cmd"] = @"9";
    dic[@"user_id"] = _uid;
    dic[@"number"] = _cardnumber.text;
    dic[@"name"] = _holdername.text;
    dic[@"validity"] = _mmyy.text;
    dic[@"ccv"] = _ccv.text;
    [manager POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"添加银行卡 -- %@",responseObject);
        NSMutableDictionary *dicq = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dicq objectForKey:@"code"] intValue] == 2))
        {
            [MBProgressHUD showSuccess:kAlertUpSecEmpty];
        }
        else if (([(NSNumber *)[dicq objectForKey:@"code"] intValue] == 3))
        {
            [MBProgressHUD showError:kAlertUpFailEmpty];//验证码错误
        }
        else if (([(NSNumber *)[dicq objectForKey:@"code"] intValue] == 4))
        {
            [MBProgressHUD showError:kAlertUseridWrongEmpty];
        }
        else if (([(NSNumber *)[dicq objectForKey:@"code"] intValue] == 5))
        {
            [MBProgressHUD showError:kAlertCardnumberExists];
        }
        [self popAction];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ViewControllerUtil showNetworkErrorMessage: error];
    }];
    
    
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_holdername resignFirstResponder];
    [_cardnumber resignFirstResponder];
    [_mmyy resignFirstResponder];
    [_ccv resignFirstResponder];
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
