//
//  EditProfileViewController.m
//  TalkNic
//
//  Created by Lingyi on 16/4/6.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ViewControllerUtil.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"

@interface EditProfileViewController ()
{
    ViewControllerUtil *_vcUtil;
    UITextField* _nameText;
    UITextField* _occupText;
    UITextField* _locationText;
    UITextField* _bioText;
}
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _vcUtil = [[ViewControllerUtil alloc]init];
    self.navigationItem.titleView = [_vcUtil SetTitle:AppEditProfile];
    [self layoutLeftBtn];
    [self layoutDoneBtn];
    [self layoutEditBox];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
}


-(void)layoutLeftBtn
{
    UIButton* leftBT = [[UIButton alloc]init];
    leftBT.frame = kCGRectMake(0, 10, 7, 23/2);
    [leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
}

-(void)layoutDoneBtn
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:AppDone style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)layoutEditBox
{
    _nameText = [[UITextField alloc]init];
    _nameText.frame = kCGRectMake(10, 40, 375, 30);
    _nameText.font=[UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    _nameText.keyboardType = UIKeyboardTypeDefault;
    _nameText.textAlignment = NSTextAlignmentCenter;
    _nameText.backgroundColor = [UIColor whiteColor];
    _nameText.placeholder = @"name";
    _nameText.textColor = [UIColor grayColor];
    _nameText.text = _name;
    [self.view addSubview:_nameText];
    
    _occupText = [[UITextField alloc]init];
    _occupText.frame = kCGRectMake(10, 80, 375, 30);
    _occupText.font=[UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    _occupText.keyboardType = UIKeyboardTypeDefault;
    _occupText.textAlignment = NSTextAlignmentCenter;
    _occupText.backgroundColor = [UIColor whiteColor];
    _occupText.placeholder = @"Occupation";
    _occupText.textColor = [UIColor grayColor];
    _occupText.text = _occupation;
    [self.view addSubview:_occupText];
    
    _locationText = [[UITextField alloc]init];
    _locationText.frame = kCGRectMake(10, 120, 375, 30);
    _locationText.font=[UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    _locationText.keyboardType = UIKeyboardTypeDefault;
    _locationText.textAlignment = NSTextAlignmentCenter;
    _locationText.backgroundColor = [UIColor whiteColor];
    _locationText.placeholder = @"Location";
    _locationText.textColor = [UIColor grayColor];
    _locationText.text = _location;
    [self.view addSubview:_locationText];
    
    _bioText = [[UITextField alloc]init];
    _bioText.frame = kCGRectMake(10, 160, 375, 60);
    _bioText.font=[UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    _bioText.keyboardType = UIKeyboardTypeDefault;
    _bioText.textAlignment = NSTextAlignmentLeft;
    _bioText.backgroundColor = [UIColor whiteColor];
    _bioText.placeholder = @"Bio";
    _bioText.textColor = [UIColor grayColor];
    _bioText.text = _bio;
    [self.view addSubview:_bioText];
}

-(void)rightAction
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    dicc[@"cmd"] = @"21";
    dicc[@"user_id"] = _uid;
    dicc[@"username"] = _nameText.text;
    dicc[@"biography"] = _bioText.text;
    dicc[@"occupation"] = _occupText.text;
    dicc[@"location"] = _locationText.text;
    
    [manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"result -- %@",responseObject);
        
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"] isEqualToString: SERVER_SUCCESS])
        {
            [MBProgressHUD showSuccess:kAlertModifyDatassSuccessful];
            [self leftAction];
        }
        else
        {
            [MBProgressHUD showError:kAlertModifyDataFailure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TalkLog(@"cmd 21 -- %@",error);
        [MBProgressHUD showError:kAlertNetworkError];
    }];
}

-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
