//
//  CouponViewController.m
//  TalKNic
//
//  Created by Talknic on 16/1/11.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "CouponViewController.h"
#import "ViewControllerUtil.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "CouponCardCell.h"

@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ViewControllerUtil *_vcUtil;
}
@property (nonatomic,strong)UIButton *leftBT;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arr;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _vcUtil = [[ViewControllerUtil alloc]init];
    self.navigationItem.titleView = [_vcUtil SetTitle:AppCoupon];
    [self layoutLeftBtn];
    [self layoutView];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self requestData];
}

- (void)requestData
{
    if (!self.arr)
        self.arr = [NSMutableArray array];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"cmd"] = @"29";
    dic[@"user_id"] = _uid;
    TalkLog(@"%@",dic);
    [manager POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"responseObject -- %@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"2"])
        {
            [self.arr addObjectsFromArray:responseObject[@"result"] ];
            [self.tableView reloadData];
        }
        else if ([responseObject[@"code"] isEqualToString:@"4"])
            [MBProgressHUD showError:kAlertNoCoupon];
        else
            [MBProgressHUD showError:kAlertdataFailure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
}

-(void)layoutView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
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

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KHeightScaled(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
    //CouponCardCell *cell = [[CouponCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardCell"];

    //UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSString *code = self.arr[indexPath.row][@"voucher_code"];
    NSString *price = self.arr[indexPath.row][@"voucher_price"];
    cell.imageview.image = [UIImage imageNamed:@"me_promotion_icon.png"];
    cell.rmbLabel.text = [NSString stringWithFormat:@"%@ RMB", price];
    //cell.rmbLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40.0];
    cell.cardNum.text = [NSString stringWithFormat:@"%@",code];
    //cell.cardNum.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:34.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.arr.count)
    {
        //[self showOkayCancelActionSheetWithIndexPath:indexPath];
    }
    else
    {
        //AddCreditCardViewController *addVC = [[AddCreditCardViewController alloc]init];
        //addVC.uid = _uid;
        //[self.navigationController pushViewController:addVC animated:YES];
    }
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
