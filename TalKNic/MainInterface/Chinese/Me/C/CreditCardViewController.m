//
//  CreditCardViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/16.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "CreditCardViewController.h"
#import "CreditCardCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "AddCreditCardViewController.h"

@interface CreditCardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)UIButton *leftBT;

@property (nonatomic,strong)NSMutableArray *arr;
@end

@implementation CreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppCreditCard;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
    [self layoutLeftBT];
    
    // 获取数据
    [self requestData];
    
    [self layoutView];
//    // 例：dataArr;
//    self.arr = [NSMutableArray arrayWithObjects:@"1234 5678 ●●●● 1234",@"1234 5678 ●●●● 1234",@"1234 5678 ●●●● 1234",@"1234 5678 ●●●● 1234",@"Add New Credit Card",nil];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    
    
    
}

- (void)requestData
{
    if (!self.arr) {
        self.arr = [NSMutableArray array];
    }
    //NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kLogin_user_information];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"cmd"] = @"22";
    dic[@"user_id"] = _uid;
    TalkLog(@"%@",dic);
    [manager POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"展示银行卡 -- %@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"2"]) {
            [self.arr addObjectsFromArray:responseObject[@"result"] ];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
    
    
}

-(void)layoutLeftBT
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 20, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
}

-(void)layoutView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CreditCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
//    CreditCardCell *cell = [[CreditCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardCell"];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row == self.arr.count) {
//        cell.cardNum.text = @"Add New Credit Card";
        cell.textLabel.text = @"Add New Credit Card";
        cell.imageView.image = [UIImage imageNamed:@"me_creditcard_add_icon.png"];
        
        
    }else
    {
//        cell.cardNum.text = self.arr[indexPath.row][@"bank_number"];
        cell.textLabel.text = self.arr[indexPath.row][@"bank_number"];

        //    NSArray *arrImg = @[@"me_creditcard_unionpay_icon.png",@"me_creditcard_amex_icon.png",@"me_creditcard_master_icon.png",@"me_creditcard_visa_icon.png",@"me_creditcard_add_icon.png"];
        //    cell.imageview.image = [UIImage imageNamed:arrImg[indexPath.row]];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.arr.count) {
        // 银行卡的row
        
        [self showOkayCancelActionSheetWithIndexPath:indexPath];
        
    }else
    {
        AddCreditCardViewController *addVC = [[AddCreditCardViewController alloc]init];
        addVC.uid = _uid;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (void)showOkayCancelActionSheetWithIndexPath:(NSIndexPath *)indexPath {
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *destructiveButtonTitle = NSLocalizedString(@"Delete", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's destructive action occured.");
        
        // 向后台传删除的银行卡
        AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        par[@"cmd"] = @"901";
        par[@"bank_number"] = self.arr[indexPath.row][@"bank_number"];
        [manger POST:PATH_GET_LOGIN parameters:par progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TalkLog(@"删除银行卡成功 -- %@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@",error);
            [MBProgressHUD showError:kAlertNetworkError];
            return;
        }];
        
        NSLog(@"%ld",indexPath.row);
        // 删除对应银行卡
        [self.arr removeObjectAtIndex:indexPath.row];

        [self.tableView reloadData];
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:destructiveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)leftAction
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
