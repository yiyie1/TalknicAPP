//
//  ForeignerBalanceViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "ForeignerBalanceViewController.h"
#import "Balance.h"
#import "FootView.h"
#import "BalanceTableViewCell.h"
#import "SDCycleScrollView.h"
#import "Balance2ViewController.h"
@interface ForeignerBalanceViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    NSArray *_allBalance;
}
@property (nonatomic,strong)UIButton *leftBT;



@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ForeignerBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.backgroundColor = self.view.backgroundColor;
    [self layoutLeftBtn];
    
    [self layoutView];
    
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 35 / 2, 375, 1)];
    label.backgroundColor = [UIColor grayColor];
    [self.view addSubview:label];
    self.tableView = [[UITableView alloc]initWithFrame:kCGRectMake(0, 65 + 35 / 2, 375, 497.5 + 65 + 35 / 2) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setScrollEnabled:NO];
    FootView *foot = [[FootView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), 375, kHeight - 447.5 )];
    self.tableView.tableFooterView = foot;
    
    [self.view addSubview:_tableView];
    
    _allBalance = @[
                    [Balance balancesetupWithGrouping:@[@"Balance",@"Frozen balance",@"Available balance",@"Points"]],
                    [Balance balancesetupWithGrouping:@[@"Alipay",@"Credit Card/UnionPay",@"Coupon"]]];
    
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
            return 231 / 2;
        }
    }
    return 99 / 2 ;
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
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.textLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BalanceTableViewCell *cell1 = [[BalanceTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 375, 231 / 2)];
            return cell1;
        }else if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"￥0.00";
            cell.detailTextLabel.textColor = [UIColor blueColor];
            
        }else if (indexPath.row == 2) {
            cell.detailTextLabel.text = @"￥0.00";
            cell.detailTextLabel.textColor = [UIColor blueColor];
            
            
        }else{
            cell.detailTextLabel.text = @"￥203";
            cell.detailTextLabel.textColor = [UIColor blueColor];
            
            
        }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            
            cell.imageView.image = [UIImage imageNamed:@"me_alipay_icon.png"];
            cell.backgroundColor = [UIColor lightGrayColor];
        }else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"me_card_icon.png"];
            cell.backgroundColor = [UIColor lightGrayColor];
            
        }else
        {
            cell.imageView.image = [UIImage imageNamed:@"me_promotion_icon.png"];
            cell.backgroundColor = [UIColor lightGrayColor];
            
        }
    }
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
        Balance2ViewController *baVC = [storyboard instantiateViewControllerWithIdentifier:@"balance2ViewController"];
        //        [self.navigationController presentViewController:baVC animated:YES completion:nil];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baVC animated:YES];
    }
    

}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
