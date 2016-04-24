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
    UITextView* _nameText;
    UITextView* _occupText;
    UITextView* _locationText;
    UITextView* _bioText;
}
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.titleView = [ViewControllerUtil SetTitle:AppEditProfile];
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

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)layoutDoneBtn
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:AppDone style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}

-(UITextView*)layoutText:(NSString*)label text:(NSString*)text x:(int)x y:(int)y width:(int)width height:(int)height textView:(UITextView*)textView
{
    UILabel* nameLb = [[UILabel alloc]init];
    nameLb.frame = kCGRectMake(5, y-20, 150, 20);
    nameLb.text = label;
    nameLb.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:6.0];
    nameLb.textColor = [UIColor blackColor];
    [self.view addSubview:nameLb];
    
    textView = [[UITextView alloc]init];
    textView.frame = kCGRectMake(x, y, width, height);
    textView.font=[UIFont systemFontOfSize:12];//[UIFont fontWithName:@"HelveticaNeue-Regular" size:18.0];
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.returnKeyType =UIReturnKeyDone;
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = [UIColor grayColor];
    textView.text = text;
    [self.view addSubview:textView];
    
    return textView;

}


-(void)layoutEditBox
{
    _nameText = [self layoutText:AppUserName       text: _name x:5 y:40 width:365 height:30 textView:_nameText];
    _occupText = [self layoutText:AppOccupation text: _occupation x:5 y:110 width:365 height:30 textView:_occupText];
    _locationText = [self layoutText:AppLocation  text: _location x:5 y:180 width:365 height:30 textView:_locationText];
    _bioText = [self layoutText:AppBio        text: _bio x:5 y:250 width:365 height:200 textView:_bioText];
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
        [ViewControllerUtil showNetworkErrorMessage: error];
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
