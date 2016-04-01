//
//  CompletedChatViewController.m
//  TalkNic
//
//  Created by Lingyi on 16/3/31.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "CompletedChatViewController.h"
#import "ViewControllerUtil.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"

@interface CompletedChatViewController ()
{
    ViewControllerUtil *_vcUtil;
    NSString *_score;
    NSString *_role;
    NSString *_comment;
    AFHTTPSessionManager *_session;
}
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *countries;
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UIImageView *photoView;
@property (nonatomic,strong)UIImageView *heart_icon;
@property (nonatomic,strong)UIImageView *star_yellow;
@property (nonatomic,strong)UILabel *heartCount;
@property (nonatomic,strong)UILabel *starPoint;
@end

@implementation CompletedChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _session = [AFHTTPSessionManager manager];
    _session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    _vcUtil = [[ViewControllerUtil alloc]init];
    _role = [_vcUtil CheckRole];
    self.navigationItem.titleView = [_vcUtil SetTitle:AppCompleted];
    [self navigaTitle];

    [self portraitImageView];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadId];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)portraitImageView
{
    self.photoView = [[UIImageView alloc]init];
    _photoView.frame = kCGRectMake((kWidth - 103)/2, 30, 103.0/2, 103.0/2);
    _photoView.image = [UIImage imageNamed:@"me_completed_avatar_icon.png"];
    _photoView.layer.cornerRadius = _photoView.frame.size.width /2;
    _photoView.layer.masksToBounds = YES;
    //_photoView.userInteractionEnabled = YES;
    [self.view addSubview:_photoView];
    
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = kCGRectMake(kWidth/2 + 10, 30, 150, 25);
    _nameLabel.textColor = [UIColor blackColor];
    //_nameLabel.numberOfLines = 0;
    _nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    [self.view addSubview:_nameLabel];
    
    self.countries = [[UILabel alloc]init];
    _countries.frame = kCGRectMake(kWidth/2 + 10, 45, 150, 25);
    _countries.textColor = [UIColor grayColor];
    _countries.numberOfLines = 0;
    _countries.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    [self.view addSubview:_countries];

    self.heart_icon = [[UIImageView alloc]init];
    _heart_icon.frame = kCGRectMake((kWidth)/2 + 10, 70, 28/2, 23.0/2);
    _heart_icon.image = [UIImage imageNamed:@"me_completed_heart_icon.png"];
    [self.view addSubview:_heart_icon];
    
    self.heartCount = [[UILabel alloc]init];
    _heartCount.frame = kCGRectMake((kWidth)/2 + 10 + 20, 70, 28/2, 23.0/2);
    _heartCount.textColor = [UIColor grayColor];
    _heartCount.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    [self.view addSubview:_heartCount];
    
    self.star_yellow = [[UIImageView alloc]init];
    _star_yellow.frame = kCGRectMake((kWidth)/2 + 10 + 30, 70-2, 28/2, 27.0/2);
    _star_yellow.image = [UIImage imageNamed:@"discover_pay_star_yellow.png"];
    [self.view addSubview:_star_yellow];

    self.starPoint = [[UILabel alloc]init];
    _starPoint.frame = kCGRectMake((kWidth)/2 + 10 + 30 + 20, 70, 28/2, 27.0/2);
    _starPoint.textColor = [UIColor grayColor];
    _starPoint.numberOfLines = 0;
    _starPoint.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    [self.view addSubview:_starPoint];

}

-(void)navigaTitle
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 0, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:AppDone style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)loadId
{
    
    NSMutableDictionary *parme = [NSMutableDictionary dictionary];
    parme[@"cmd"] = @"19";
    parme[@"user_id"] = @"151";//_chatter_uid;
    TalkLog(@"Me ID -- %@",_chatter_uid);
    [_session POST:PATH_GET_LOGIN parameters:parme progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"Completed result: %@",responseObject);
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
        {
            NSDictionary *dict = [dic objectForKey:@"result"];
            if([_role isEqualToString:CHINESEUSER])
                _countries.text = @"China";
            else
                _countries.text = [dict objectForKey:@"nationality"];
            _nameLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            _starPoint.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fans"]];
            _heartCount.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"praise"]];
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
            [self.photoView sd_setImageWithURL:url placeholderImage:nil];
        }
        else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4))
        {
            [MBProgressHUD showError:kAlertIDwrong];
            return;
        }
        else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 3))
        {
            [MBProgressHUD showError:kAlertdataFailure];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
    
}

-(void)rightAction
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cmd"] = @"32";
    dic[@"user_id"] = _uid;
    dic[@"role"] = [_vcUtil CheckRole];
    dic[@"stars"] = _score;
    dic[@"comment"] = _comment;
    
    TalkLog(@"dic--%@",dic);
    [_session POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        TalkLog(@"responseObject: %@",responseObject);
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )
        {
            [MBProgressHUD showSuccess:kAlertdataSuccess];
        }
        else
        {
            [MBProgressHUD showError:kAlertdataFailure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];

}

- (void)leftAction
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
