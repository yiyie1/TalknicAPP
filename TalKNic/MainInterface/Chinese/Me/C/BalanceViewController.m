//
//  BalanceViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/16.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "BalanceViewController.h"
#import "Balance.h"
#import "FootView.h"
#import "BalanceTableViewCell.h"
#import "Balance2ViewController.h"
#import "CreditCardViewController.h"
#import "YGPayByAliTool.h"
#import "SDCycleScrollView.h"
#import "solveJsonData.h"
#import "AFNetworking.h"
#import "CouponViewController.h"
#import "MBProgressHUD+MJ.h"

@interface BalanceViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    NSArray *_allBalance;
}
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UIButton *rightBT;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sources;

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppBalance;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
    
    [self layoutLeftBtn];
    
    [self layoutView];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
    [self getData];
    
    

}

- (void)getData{
    
    NSLog(@"哥哥走了一遍");
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"my_id"];
    
    parmes[@"user_id"] = userId;
    //    parmes[@"theory_time"] = @"";
    //    parmes[@"cmd"] = @"19";
    
    [session POST:PATH_GET_MONEY parameters:parmes progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"] isEqualToString:@"2"]) {
            self.sources = [NSMutableArray array];
            NSDictionary *result = [dic objectForKey:@"result"];
            
            [self.sources addObject:[result objectForKey:@"balance"]];
            [self.sources addObject:[result objectForKey:@"frozen_balance"]];
            [self.sources addObject:[result objectForKey:@"available_balance"]];
            [self.sources addObject:[result objectForKey:@"score"]];
            [self.tableView reloadData];
            NSLog(@"%@",result);
            
        }
        
        //            [self.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];

}

-(void)layoutLeftBtn
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 10, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
}
-(void)layoutView
{
    UILabel *label = [[UILabel alloc] initWithFrame:kCGRectMake(0, 64 + 35 / 2, 375, 1)];
    label.backgroundColor = [UIColor grayColor];
    [self.view addSubview:label];
    self.tableView = [[UITableView alloc]initWithFrame:kCGRectMake(0, 65 + 35 / 2, 375, 497.5 + 65 + 35 / 2 +15) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setScrollEnabled:NO];
    
    FootView *foot = [[FootView alloc] initWithFrame:kCGRectMake(0, 0, 375, 240 )];
    
    
    self.tableView.tableFooterView = foot;
    
    [self.view addSubview:_tableView];
    NSArray *images = @[[UIImage imageNamed:@"me_ads_image.png"],
                        [UIImage imageNamed:@"me_ads_image.png"],
                        [UIImage imageNamed:@"me_ads_image.png"]
                        ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:kCGRectMake(10, 35, 351 , 120) imagesGroup:images];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [foot addSubview:cycleScrollView];
    
    _allBalance = @[
                    [Balance balancesetupWithGrouping:@[AppBalance,AppFreeze,AppAvailablebalance,AppPoints]],
                    [Balance balancesetupWithGrouping:@[AppAlipay,AppCreditCard,AppCoupon]]];
    
}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    TalkLog(@"--点击了第%ld张图片",index);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allBalance.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 231 / 2.5;
        }
    }
    return 45 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:nil];
    Balance *balance = _allBalance[indexPath.section];
    cell.textLabel.text = balance.grouping[indexPath.row];

    cell.textLabel.font = [UIFont fontWithName:kHelveticaLight size:14.0];
    cell.textLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            BalanceTableViewCell *cell1 = [[BalanceTableViewCell alloc] initWithFrame:kCGRectMake(0, 0, 375, 231 / 2)];
            cell1.label.text = [NSString stringWithFormat:@"￥%@",self.sources[0]];
            return cell1;
        }
        else if (indexPath.row == 1)
        {
//            cell.detailTextLabel.text = @"￥0.00";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.sources[1]];
            cell.detailTextLabel.textColor = [UIColor blueColor];
            
        }
        else if (indexPath.row == 2)
        {
//            cell.detailTextLabel.text = @"￥0.00";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.sources[2]];
            cell.detailTextLabel.textColor = [UIColor blueColor];

        }
        else
        {
//            cell.detailTextLabel.text = @"￥203";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.sources[3]];
            cell.detailTextLabel.textColor = [UIColor blueColor];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            
            cell.imageView.image = [UIImage imageNamed:@"me_alipay_icon.png"];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        else if (indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"me_card_icon.png"];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"me_promotion_icon.png"];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            self.hidesBottomBarWhenPushed=YES;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
            Balance2ViewController *baVC = [storyboard instantiateViewControllerWithIdentifier:@"balance2ViewController"];
            //        [self.navigationController presentViewController:baVC animated:YES completion:nil];
            [self.navigationController pushViewController:baVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
    }
    
#warning 支付修改开始 10.1
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            NSString *orderId = [self generateTradeNO];
        
            [YGPayByAliTool payByAliWithSubjects:ALI_PAY_SUBJECT body:nil price:0.01 orderId:orderId partner:ALI_PARTNER_ID seller:ALI_SELLER_ID privateKey:ALI_PRIVATE_KEY success:^(NSDictionary *info) {
                NSString *result = info[@"result"];

                if (result.length)
                {
//                [self charge];
                }
            }];
        //[self charge];
        }
        else if(indexPath.row == 1)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
            CreditCardViewController *creditVC = [storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
            //creditVC.uid = _uid;
            [self.navigationController pushViewController:creditVC animated:YES];

        }
        else if(indexPath.row == 2)
        {
            CouponViewController *couponVC = [[CouponViewController alloc]init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
    }
}

- (void)charge{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"my_id"];
    NSLog(@"%@",userId);
    parmes[@"user_id"] = [NSNumber numberWithInt:[userId intValue]];
    
    parmes[@"recharge_money"] = @"10";
    
    //    parmes[@"theory_time"] = @"";
    //    parmes[@"cmd"] = @"19";
    
    [session POST:PATH_ADD_MONEY parameters:parmes progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"code"] isEqualToString:@"2"]) {
            
            // 充值成功
            NSLog(@"充值成功");
            [self getData];

            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];

}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"01234789ABCDEFGHIJKLMNOPQRSTUVWXY";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
#warning 支付修改结束10.1
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    ////    me_line_center_long.png
    
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
