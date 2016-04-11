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
#import "ViewControllerUtil.h"

@interface QaViewController ()
{
    ViewControllerUtil* _vcUtil;
}
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
    _vcUtil = [[ViewControllerUtil alloc]init];
    self.navigationItem.titleView = [_vcUtil SetTitle:AppQA];
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
    [_RightBT setTitle:AppSend forState:(UIControlStateNormal)];
    _RightBT.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    [_RightBT addTarget:self action:@selector(RightAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *RightI = [[UIBarButtonItem alloc]initWithCustomView:_RightBT];
    self.navigationItem.rightBarButtonItem = RightI;
}

-(void)layoutView
{
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 273)];
    _textView.font =  [UIFont systemFontOfSize:20];
    
    [self.view addSubview:_textView];
    UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 273, self.view.frame.size.width, 20)];
    numberLabel.text = @" Add your comments & questions in 400 words";
    numberLabel.textColor = [UIColor grayColor];
    numberLabel.backgroundColor = [UIColor whiteColor];
    numberLabel.font = [UIFont fontWithName:kHelveticaRegular size:10.0];
    [self.view addSubview:numberLabel];
    
    UIView* line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, numberLabel.frame.origin.y+numberLabel.frame.size.height, self.view.frame.size.width, 1)];
    line_1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line_1];
}



-(void)RightAction
{
    if(_textView.text.length == 0)
    {
        [MBProgressHUD showError:@"Add your comments and questions"];
        return;
    }
    NSDictionary * dic = @{@"cmd":@"31",
                           @"uid":_uid,
                           @"qa":_textView.text,
                           };
    
    
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    [session POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _dict = [solveJsonData changeType:responseObject];
        if ([responseObject[@"code"] isEqualToString:SERVER_SUCCESS])
        {
            [MBProgressHUD showSuccess:kAlertdataSuccess];
        }
        else
        {
            [MBProgressHUD showError:kAlertdataFailure];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:kAlertNetworkError];
        NSLog(@"error%@",error);
        
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
