//
//  Balance2ViewController.m
//  TalKNic
//
//  Created by Talknic on 16/1/11.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "Balance2ViewController.h"
#import "BalanceCell.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "OrderRecorder.h"
#import "MBProgressHUD+MJ.h"

@interface Balance2ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentcontroller;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) NSString *index;
@property (nonatomic,strong)UIButton *leftBT;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation Balance2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppBalance;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
    
    self.navigationItem.titleView = title;
    
    self.index = @"0";

    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    // 左上角返回键
    [self layoutLeftBtn];
    //请求数据
    [self requestData:@"0"];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)segmentController:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
//    [self.tableview reloadData];
    self.index = [NSString stringWithFormat:@"%ld",(long)index];
    [self requestData:[NSString stringWithFormat:@"%ld",(long)index]];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     UIImageView *imageview;
     IBOutlet UILabel *messageLb;
     IBOutlet UILabel *moneyLb;
     IBOutlet UILabel *dateLb;
     */
    
    BalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BalanceCell" forIndexPath:indexPath];
    OrderRecorder *order = self.dataArray[indexPath.row];
    if ([self.index isEqualToString:@"0"]) {
        cell.messageLb.text = @"Alipay Recharging";
        cell.moneyLb.text = [NSString stringWithFormat:@"￥%@",order.order_price];
        cell.dateLb.text = order.time;
    }else{
        cell.messageLb.text = @"Consum";
        cell.moneyLb.text = [NSString stringWithFormat:@"￥%@",order.order_price];
        cell.dateLb.text = order.time;
    }
    
    if (self.segment.selectedSegmentIndex == 0) {
        cell.imageview.image = [UIImage imageNamed:@"balance_in_icon"];
    }else
    {
        cell.imageview.image = [UIImage imageNamed:@"balance_out_icon"];
    }
    
    return cell;
    
}


- (void)requestData:(NSString *)index
{
//    if (!self.dataArray) {
//        self.dataArray = [NSMutableArray array];
//    }
    self.dataArray = [NSMutableArray array];

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"my_id"];
    
    parmes[@"user_id"] = userId;
    //    parmes[@"theory_time"] = @"";
//    parmes[@"cmd"] = @"19";
    
    NSString *path = NULL;
    if ([index isEqualToString:@"0"]) {
        path = PATH_GET_ORDER_CHARGE;
    }else{
        path = PATH_GET_ORDER_RECORDER;

    }
    
    [session POST:path parameters:parmes progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSLog(@"%@",dic);

        if ([[dic objectForKey:@"code"]isEqualToString:@"2"]) {
            
//            self.dataArray = [NSMutableArray array];
            if (![[[dic objectForKey:@"result"] class] isSubclassOfClass:[NSString class]]) {
                
                NSArray *results = [NSArray array];
                results = [dic objectForKey:@"result"];
                NSLog(@"%@",results);
                if ([index isEqualToString:@"0"]) {
                    
                    NSLog(@"results.count%lu",(unsigned long)results.count);
                    for (int i = 0; i<results.count; i++) {
                        OrderRecorder *order = [[OrderRecorder alloc]init];
                        
                        if ([results[i] isKindOfClass:[NSDictionary class]]) {
                            order.order_price = [results[i] objectForKey:@"recharge_money"];
                            order.time = [results[i] objectForKey:@"recharge_time"];
                            [self.dataArray addObject:order];
                            NSLog(@"%@",order.order_price);
                            
                        }
                    }
                    
                    NSLog(@"self.dataArray.count%lu",(unsigned long)self.dataArray.count);

                }
                else
                {
                    for (NSDictionary *dict in results)
                    {
                        
                        OrderRecorder *order = [[OrderRecorder alloc]init];
                        order.order_price = [dict objectForKey:@"order_price"];
                        order.time = [dict objectForKey:@"time"];
                        [self.dataArray addObject:order];
                        NSLog(@"%@",order.order_price);
                        
                    }

                }
                
            }
            
            NSLog(@"%@",dic);
            [self.tableview reloadData];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableview reloadData];
//        
//    });
    
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
