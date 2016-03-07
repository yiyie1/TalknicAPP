//
//  FeaturedViewController.m
//  TalkNic
//
//  Created by ldy on 15/10/30.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "FeaturedViewController.h"
#import "FeaturedLayout.h"
#import "MJExtension.h"
#import "Featured.h"
#import "FeaturedCell.h"
#import "MJRefresh.h"
#import "PopupView.h"
#import "PopupView1.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "Header.h"
@interface FeaturedViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,FeaturedLayoutDelegate>
{
    NSArray *arr;
}
//{
//    UIView *view1;
//}
@property (nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *featureds;



@end

@implementation FeaturedViewController

-(NSMutableArray *)featureds
{
    if (_featureds ==nil) {
        self.featureds = [NSMutableArray array];
    }
    return _featureds;
}

static NSString *const ID = @"featured";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    
    
    FeaturedLayout *layout = [[FeaturedLayout alloc]init];
    layout.delegate = self;
    
    UICollectionView *collectionView= [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"FeaturedCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    //刷新界面
    [self.collectionView reloadData];
    
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
//    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    
    

    
}
-(void)loadData
{
    if(!self.featureds )
    {
        self.featureds = [NSMutableArray array];
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
            parmes[@"cmd"] = @"10";
            parmes[@"discover"] = @"featured";
            TalkLog(@"%@ %@",PATH_GET_LOGIN,parmes);
            [session GET:PATH_GET_LOGIN parameters:parmes progress:^(NSProgress * _Nonnull uploadProgress) {
    
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"瀑布流 -- %@",responseObject);
                NSDictionary *ddic = responseObject;
                if ([[ddic objectForKey:@"code"] isEqualToString:@"2"]) {
                    [self.featureds addObjectsFromArray:[ddic objectForKey:@"result"]];
                    
//                    NSMutableArray *featured = [ddic objectForKey:@"result"];
//                    
//                    for (NSDictionary *ddict in featured) {
//                        Featured *featured = [[Featured alloc] init];
//                        featured.user_pic = [NSString stringWithFormat:@"%@",[ddict objectForKey:@"user_pic"]];
//                        
//                        featured.topic = [NSString stringWithFormat:@"%@",[ddict objectForKey:@"topic"]];
//                        featured.username = [NSString stringWithFormat:@"%@",[ddict objectForKey:@"username"]];
//                        featured.praise = [NSString stringWithFormat:@"%@",[ddict objectForKey:@"praise"]];
//                        featured.uid = [NSString stringWithFormat:@"%@",[ddict objectForKey:@"uid"]];
//
//                        
//                        [self.featureds addObject:featured];
//                    }
                    
                    
                    
                    
                }
                
                
                [self.collectionView reloadData];
               
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
}
-(void)loadMoreData:(MJRefreshFooter *)footer
{
    [footer endRefreshing];
}
//-(CGFloat)featuredLayout:(FeaturedLayout *)featuredLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
//{
//    Featured *featured = self.featureds[indexPath.item];
//    return featured.h / featured.w *width;
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.featureds.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeaturedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.featured =self.featureds[indexPath.row];
    return cell;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PopupView1 *pop = [[PopupView1 alloc]initWithFrame:self.view.frame];
    pop.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height /2 +60);
    
    [self.view addSubview:pop];
    
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
