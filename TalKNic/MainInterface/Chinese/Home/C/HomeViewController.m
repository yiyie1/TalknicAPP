//
//  HomeViewController.m
//  TalkNic
//
//  Created by ldy on 15/10/20.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "HomeViewController.h"

#import "FeaturedViewController.h"
//#import "LatestViewController.h"
//#import "PopularViewController.h"
#import "AFNetworking.h"
#import "Header.h"
#import "solveJsonData.h"
#import "Featured.h"
#import "HomeShowPicturwCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "EaseMobSDK.h"
#import "YGPayByAliTool.h"

@interface HomeViewController ()<UISearchBarDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *dataArray;
    NSMutableDictionary *dataDic_1;
    NSString *praise;
    NSString *uid;
    NSString *topic;
    NSString *user_pic;
    NSString *username;
    
    NSString *userid;
    NSMutableArray *searChArr;//搜索结果数组
    NSDictionary * _dicP;//接受匹配信息的通知
    NSMutableArray *_piArr;//存放匹配信息
    
}
//{
//     UISearchBar *searchBar;
//
//
//}
@property (nonatomic,strong)UISegmentedControl *segmentControl;
@property (nonatomic,strong)UINavigationBar *bar;

@property (nonatomic,strong)FeaturedViewController *featuredView;
//@property (nonatomic,strong)LatestViewController *latestView;
//@property (nonatomic,strong)PopularViewController *popularView;

@property (nonatomic,strong)UISearchDisplayController *searchController;
@property (nonatomic,strong)UISearchBar *searchBar;

//@property (nonatomic,strong)NSMutableArray *searchDataArr;   //搜索结果数组
@property(nonatomic,strong)NSMutableDictionary *dataDic;


@property(nonatomic)NSInteger seletedCount;
@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self resignFirstResponder];
    self.homecollectview.delegate = self;
    self.homecollectview.dataSource = self;
    // 把遮挡板放在当前window最外层
    [[UIApplication sharedApplication].keyWindow addSubview:self.zhedangbanview];
    self.zhedangbanview.hidden = YES;
    self.seletedCount = 0;
    [self.homecollectview addLegendHeaderWithRefreshingBlock:^{
        NSArray *titleArr = @[@"featured"];//,AppLatest,AppPopular];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestDataMethod:titleArr[self.segmentControl.selectedSegmentIndex]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    //    // 头部的刷新
    //    self.homecollectview.header = [MJRefreshHeader headerWithRefreshingBlock:^{
    //        NSArray *titleArr = @[@"featured",@"latest",@"popular"];
    //        [self requestDataMethod:titleArr[self.segmentControl.selectedSegmentIndex]];
    //    }];
    
    //注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
    
}
-(void)tongzhi:(NSNotification *)dic
{
    TalkLog(@"接受匹配信息 -- %@",dic);
    TalkLog(@"%@",dic.userInfo);
    dataArray = (NSMutableArray *)dic.userInfo;
    
    [self.homecollectview reloadData];
    
}
#pragma mark - UICollectionViewDataSouce And UICollectionViewDelegate
//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}
//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeShowPicturwCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeShowPicturwCell" forIndexPath:indexPath];
    
    //赋值
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dataArray[indexPath.item][@"user_pic"]]];
    [cell.imageview sd_setImageWithURL:url placeholderImage:nil];
    cell.titlelb.text = [NSString stringWithFormat:@"Topic：%@",dataArray[indexPath.item][@"topic"]];
    cell.nickNameLb.text = [NSString stringWithFormat:@"Nick：%@",dataArray[indexPath.item][@"username"]];
    cell.dianzanLb.text = [NSString stringWithFormat:@"%@",dataArray[indexPath.item][@"praise"]];
    cell.pingfenLb.text = @"0.0";
    
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (kWidth - 20) / 2, (kWidth - 20) / 2 * 4 / 3 );
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//点击cell触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = dataArray[indexPath.item];
    self.dataDic = [NSDictionary dictionaryWithDictionary:dataDic];
    
    self.zhedangbanview.hidden = NO;
    
    self.detailimage1.layer.masksToBounds = YES;
    self.detailimage1.layer.cornerRadius = 50 / 2 * (kWidth / 320);
    self.beijingView.layer.masksToBounds = YES;
    self.beijingView.layer.cornerRadius = 54 / 2 * (kWidth / 320);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"user_pic"]]];
    [self.detailimage1 sd_setImageWithURL:url placeholderImage:nil];
    self.nameLb.text = dataArray[indexPath.item][@"username"];
    self.addressLb.text = @"";
    self.pingfenLb.text = @"";
    self.dianzaiLb.text = [NSString stringWithFormat:@"%@",dataArray[indexPath.item][@"praise"]];
    uid = dataArray[indexPath.item][@"uid"];
    self.addressLb.text = @"";
    self.bioLb.text = @"";
    self.topicLb.text = dataDic[@"topic"];
    
    // 点赞、评分
    self.dianzaiLb.text = dataDic[@"praise"];
    self.pingfenLb.text = @"";
    [self.dianzangBtn addTarget:self action:@selector(dianzangBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.pingfenBtn addTarget:self action:@selector(pingfenBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //确定进入下一步
    [self.sureBtn addTarget:self action:@selector(sureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)dianzangBtn:(id)sender
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSData *usData = [userD objectForKey:@"ccUID"];
    NSString *idU = [[NSString alloc]initWithData:usData encoding:NSUTF8StringEncoding];
    
    // NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [ud objectForKey:kLogin_user_information];
    NSDictionary *parmeDic = @{@"cmd":@"15",@"user_id":self.dataDic[@"uid"],@"praise_id":idU};
    TalkLog(@"点赞的 --- %@",parmeDic);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [session POST:PATH_GET_LOGIN parameters:parmeDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if([dic[@"code"] isEqualToString:@"2"])
        {
            // 点赞成功
            int dianzanCount = [self.dataDic[@"praise"] intValue] + 1;
            self.dianzaiLb.text = [NSString stringWithFormat:@"%d",dianzanCount];
            
        }else if([dic[@"code"] isEqualToString:@"3"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已点赞" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else if ([dic[@"code"] isEqualToString:@"4"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"点赞失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}
- (void)pingfenBtn:(id)sender
{
    TalkLog(@"没有接口");
    
}
- (void)cancelBtn:(id)sender
{
    self.zhedangbanview.hidden = YES;
    self.seletedCount = 0;
    
    [self showViewFrom:NO];
    
    NSArray *titleArr = @[@"featured"];//, AppLatest,AppPopular];
    [self requestDataMethod:titleArr[self.segmentControl.selectedSegmentIndex]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //NSArray *titleArr = @[AppFeatured];//, AppLatest,AppPopular];
        [self requestDataMethod:titleArr[self.segmentControl.selectedSegmentIndex]];
    });
}
- (void)sureBtn:(id)sender
{
    //    UIButton *btn = (UIButton *)sender;
    
    self.seletedCount ++;
    if (self.seletedCount % 2 == 1) {
        [self showViewFrom:YES];
        
        // 优惠券和支付价格选择
        [self.youhuiquanBtn addTarget:self action:@selector(youhuiquanBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.priceBtn addTarget:self action:@selector(priceBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    if (self.seletedCount % 2 == 0) {
        //进入支付页面
        userid = uid ;
        self.zhedangbanview.hidden = YES;
        TalkLog(@"聊天界面UID -- %@",userid);
        [YGPayByAliTool payByAliWithSubjects:ALI_PAY_SUBJECT body:nil price:0.01 orderId:@"10001" partner:ALI_PARTNER_ID seller:ALI_SELLER_ID privateKey:ALI_PRIVATE_KEY success:^(NSDictionary *info) {
            // 手机没有安装支付宝自动调用网页版
            // 支付完成后调用  打印查看是否支付成功
            NSLog(@"info = %@",info);
            
        }];
        
        
        //        [EaseMobSDK createOneChatViewWithConversationChatter:userid onNavigationController:self.navigationController];
        
        //
        //        NSData *dataUid = [userid dataUsingEncoding:NSUTF8StringEncoding];
        //        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        //        [user setObject:dataUid forKey:@"ForeignerID"];
        //
        //        NSDate *payDate = [NSDate date];
        //        [user setObject:payDate forKey:@"payTime"];
        //
        //        TalkLog(@"外教ID -- %@",user);
        
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
        parmes[@"theory_time"] = @(15);
        NSString *my_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"my_id"];
        
        parmes[@"student_id"] = [NSNumber numberWithInt:[my_id intValue]];
        parmes[@"teacher_id"] = [NSNumber numberWithInt:[userid intValue]];
        NSLog(@"student_id%@  teacher_id%@",parmes[@"student_id"], parmes[@"teacher_id"]);
        [session POST:PATH_GET_ORDER parameters:parmes progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSData *dataUid = [userid dataUsingEncoding:NSUTF8StringEncoding];
            NSDate *payDate = [NSDate date];
            [user setObject:dataUid forKey:@"ForeignerID"];
            [user setObject:payDate forKey:@"payTime"];
            NSDictionary *dic = [solveJsonData changeType:responseObject];
            NSLog(@"%@",dic);
            
            // 修改
            if ([[dic objectForKey:@"code" ] isEqualToString:@"2"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"order_id"] forKey:@"order_id"];
                NSLog(@"%@",[dic objectForKey:@"order_id"]);
                NSLog(@"%@",dic);
                [EaseMobSDK createOneChatViewWithConversationChatter:userid Name:self.nameLb.text onNavigationController:self.navigationController];
            }else if([[dic objectForKey:@"code" ] isEqualToString:@"5"]){//
                
                // 支付差额
                NSString *orderId = [self generateTradeNO];
                
                [YGPayByAliTool payByAliWithSubjects:ALI_PAY_SUBJECT body:nil price:0.01 orderId:orderId partner:ALI_PARTNER_ID seller:ALI_SELLER_ID privateKey:ALI_PRIVATE_KEY success:^(NSDictionary *info) {
                    NSLog(@"网页版 = %@",info);
                    NSString *result = info[@"result"];
                    NSLog(@"-----------heheh");
                    
                    if (result.length) {
                        // 支付成功通知
                        [self charge];
                        // 继续聊天
                        [EaseMobSDK createOneChatViewWithConversationChatter:userid Name:self.nameLb.text onNavigationController:self.navigationController];
                        
                    }
                    
                }];
                NSLog(@"Skip payment");
                [EaseMobSDK createOneChatViewWithConversationChatter:userid Name:self.nameLb.text onNavigationController:self.navigationController];
                
                
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
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
            //            [self getData];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"chatDuration"];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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


- (void)youhuiquanBtn:(id)sender
{
    TalkLog(@"没有数据接口");
}

- (void)priceBtn:(id)sender
{
    TalkLog(@"没有数据接口");
}

-(void)initNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    if (self.bar == nil) {
        [self.navigationController setNavigationBarHidden:YES];
        
        self.bar = [[UINavigationBar alloc]initWithFrame:kCGRectMake(0, 0, self.view.frame.size.width, 129 / 2)];
        UIImage * img= [UIImage imageNamed:@"nav_bg.png"];
        img = [img stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        
        [_bar setBackgroundImage:img forBarMetrics:(UIBarMetricsDefault)];
        UILabel *label = [[UILabel alloc]init];
        label.frame = kCGRectMake(self.view.frame.size.width/2.4, 30, 80, 30) ;
        label.text = AppDiscover;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
        
        //UILabel *title = [[UILabel alloc] initWithFrame:kCGRectMake(0, 129/4, 100, 44)];
        //title.text = AppDiscover;
        //title.textAlignment = NSTextAlignmentCenter;
        //title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        //title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
        //self.navigationItem.titleView = title;
        
        [_bar addSubview:label];
        [self.view addSubview:_bar];
    }
}
-(void)segment
{
    if (self.segmentControl == nil) {
        self.segmentControl = [[UISegmentedControl alloc]initWithItems:@[AppFeatured]];//, AppLatest,AppPopular]];
        _segmentControl.frame = CGRectMake(self.view.frame.size.width /21, self.view.frame.size.height/9.5 , _bar.frame.size.width /1.1, _bar.frame.size.height / 3.15);
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.tintColor = [UIColor whiteColor];
        [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:(UIControlEventValueChanged)];
        [self.view addSubview:_segmentControl];
    }
}
-(void)layoutViews
{
    self.featuredView = [[FeaturedViewController alloc]init];
    _featuredView.view.frame = CGRectMake(0, self.view.frame.size.height /6 +44, self.view.frame.size.width, self.view.frame.size.height) ;
    
    [self.view addSubview:_featuredView.view];
    
    /*self.latestView = [[LatestViewController alloc]init];
     _latestView.view.frame = CGRectMake(0, self.view.frame.size.height /6 +44, self.view.frame.size.width, self.view.frame.size.height);
     
     [self.view addSubview:_latestView.view];
     
     self.popularView = [[PopularViewController alloc]init];
     _popularView.view.frame = CGRectMake(0, self.view.frame.size.height/6 +44, self.view.frame.size.width, self.view.frame.size.height);
     
     [self.view addSubview:_popularView.view];*/
}

-(void)searchBarView
{
    UISearchBar *searchbar = [[UISearchBar alloc]initWithFrame:kCGRectMake(0, 129/2, 375, 44)];
    UITextField *searchField = [searchbar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor colorWithRed:125/255.0 green:194/255.0 blue:232/255.0 alpha:0.5f];
    [searchField setValue:[UIColor colorWithRed:125/255.0 green:194/255.0 blue:232/255.0 alpha:0.5f] forKeyPath:@"_placeholderLabel.textColor"];
    searchbar.delegate = self;
    searchbar.placeholder = AppSearch;
    
    self.searchBar.delegate = self;
    self.searchBar = searchbar;
    [self.view addSubview:searchbar];
    
    //    [self.searchBar setSearchFieldBackgroundImage:
    //     [UIImage imageNamed:@"search_icon.png"]forState:UIControlStateNormal];
    self.searchController = [[UISearchDisplayController alloc]initWithSearchBar:searchbar contentsController:self];
    self.searchController.searchResultsTableView.tableFooterView = [[UIView alloc]init];
    _searchController.searchResultsDataSource =self;
    _searchController.searchResultsDelegate =self;
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    searchBar.hidden = YES;
}

-(void)segmentAction:(UISegmentedControl *)segment
{
    NSArray *titleArr = @[@"featured"];//, @"latest",@"popular"];
    [self requestDataMethod:titleArr[segment.selectedSegmentIndex]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.homecollectview reloadData];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = YES;
    //    self.tabBarController.tabBar.translucent = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    [self initNavigationBar];
    
    //[self segment];

    if (self.searchBar == nil) {
        [self searchBarView];
    }
    
    // 界面出现时，显示featured的collectview
    [self requestDataMethod:@"featured"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    //    self.tabBarController.tabBar.translucent = NO;
    //    self.tabBarController.tabBar.hidden = NO;
}

#define mark ------ UISearchDisplayController的布局

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  searChArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.textLabel.text = [[searChArr objectAtIndex:indexPath.row] valueForKey:@"username"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dataDic = searChArr[indexPath.row];
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    
    
    self.zhedangbanview.hidden = NO;
    
    self.detailimage1.layer.masksToBounds = YES;
    self.detailimage1.layer.cornerRadius = 50 / 2 * (kWidth / 320);
    self.beijingView.layer.masksToBounds = YES;
    self.beijingView.layer.cornerRadius = 54 / 2 * (kWidth / 320);
    
    NSLog(@"self.dataDic%@",self.dataDic);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"user_pic"]]];
    [self.detailimage1 sd_setImageWithURL:url placeholderImage:nil];
    self.nameLb.text = searChArr[indexPath.row][@"username"];
    
    self.addressLb.text = @"无字段";
    self.pingfenLb.text = @"无";
    self.dianzaiLb.text = [NSString stringWithFormat:@"%@",searChArr[indexPath.row][@"praise"]];
    uid = searChArr[indexPath.row][@"uid"];
    self.addressLb.text = @"无字段";
    self.bioLb.text = @"无字段";
    self.topicLb.text = dataDic[@"topic"];
    
    // 点赞、评分
    self.dianzaiLb.text = dataDic[@"praise"];
    self.pingfenLb.text = @"无字段";
    [self.dianzangBtn addTarget:self action:@selector(dianzangBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.pingfenBtn addTarget:self action:@selector(pingfenBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //确定进入下一步+
    [self.sureBtn addTarget:self action:@selector(sureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    tableView.hidden = YES;
    
    self.searchBar.frame = kCGRectMake(0, 129 / 2, 375, 44);
    _featuredView.view.frame = kCGRectMake(0, 667 / 6 + 44, 375, 667 - 667 / 6 + 44);
    //_latestView.view.frame = kCGRectMake(0, 667 / 6 + 44, 375, 667 - 667 / 6 + 44);
    //_popularView.view.frame = kCGRectMake(0, 667 / 6 + 44, 375, 667 - 667 / 6 + 44);
    
    self.searchBar.alpha = 0.5f;
    [self.searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.frame = kCGRectMake(0, 129 / 2, 375, 44);
    _featuredView.view.frame = kCGRectMake(0, 70, 375, 667 - 70);
    //_latestView.view.frame = kCGRectMake(0, 70, 375, 667 - 70);
    //_popularView.view.frame = kCGRectMake(0, 70, 375, 667 - 70);
    
    self.searchBar.alpha = 1.0f;
    NSLog(@"_+++++)((");
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.frame = kCGRectMake(0, 129 / 2, 375, 44);
    _featuredView.view.frame = kCGRectMake(0, 129 / 2 + 44, 375, 667 - 129 / 2 + 44);
    //_latestView.view.frame = kCGRectMake(0, 667 / 6 + 44, 375, 667 - 667 / 6 + 44);
    //_popularView.view.frame = kCGRectMake(0, 667 / 6 + 44, 375, 667 - 667 / 6 + 44);
    self.searchBar.alpha = 1.0f;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (!searChArr) {
        searChArr = [[NSMutableArray alloc]init];
        
    }else
    {
        [searChArr removeAllObjects];
    }
    NSString *strSearch = searchBar.text;
    
    for (int i = 0; i<[dataArray count]; i++) {
        NSDictionary *searchDic = dataArray[i];
        NSString *searchStr = searchDic[@"username"];
        
        NSRange range = [searchStr rangeOfString:strSearch];
        if (range.location != NSNotFound) {
            [searChArr addObject:[dataArray objectAtIndex:i]];
        }
    }
    TalkLog(@"搜索库 ＝＝ %@",searChArr);
    TalkLog(@"搜索的数据 ＝＝ %@",strSearch);
    
    
    [self.searchController.searchResultsTableView reloadData];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}
- (void)setImage:(nullable UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state
{
    [self.searchBar setSearchFieldBackgroundImage:
     [UIImage imageNamed:@"search_icon.png"]forState:UIControlStateNormal];
}


#pragma mark - 数据请求封装
- (NSDictionary *)requestData1:(NSMutableDictionary *)parmesDic1
{
    if (!dataDic_1) {
        dataDic_1 = [NSMutableDictionary dictionary];
    }else
    {
        [dataDic_1 removeAllObjects];
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [session POST:PATH_GET_LOGIN parameters:parmesDic1 progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"]isEqualToString:@"2"]) {
            dataDic_1 = (NSMutableDictionary *)dic;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.homecollectview reloadData];
        
    });
    
    return dataDic_1;
}


- (void)requestDataMethod:(NSString *)discover
{
    [self.homecollectview.header endRefreshing];
    
    if (!dataArray) {
        dataArray = [NSMutableArray array];
    }else
    {
        [dataArray removeAllObjects];
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
    parmes[@"cmd"] = @"10";
    parmes[@"discover"] = discover;
    [session POST:PATH_GET_LOGIN parameters:parmes progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"]isEqualToString:@"2"]) {
            
            NSArray *array = [dic objectForKey:@"result"];
            NSString *localUid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
            for (NSDictionary *dic in array) {
                if (![[dic valueForKey:@"username"] isEqualToString:localUid]) {
                    [dataArray addObject:dic];
                }
            }
            TalkLog(@"数组  ＝＝＝＝＝ %@",dataArray);
            
            [self.homecollectview reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.homecollectview reloadData];
        
    });
    
}

// 布局时，根据不同按钮，展示不同控件
- (void)showViewFrom:(BOOL)isBool
{
    BOOL noBool = !isBool;
    self.jieshaoLb.hidden = isBool;
    self.bioLb.hidden =  isBool;
    self.dailyTopicLb2.hidden = noBool;
    self.fengexian2.hidden = noBool;
    self.fengexian3.hidden = noBool;
    self.dailyTopicLb1.hidden = isBool;
    self.topicLb.hidden = isBool;
    self.xiaofengexian1.hidden = noBool;
    self.xiaofengexian2.hidden = noBool;
    self.youhuiquanBtn.hidden = noBool;
    self.priceBtn.hidden = noBool;
    self.couponsLb.hidden = noBool;
    self.rmbLb.hidden = noBool;
    
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
