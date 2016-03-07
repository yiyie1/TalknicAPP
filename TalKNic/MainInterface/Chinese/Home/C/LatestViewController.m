//
//  LatestViewController.m
//  TalkNic
//
//  Created by ldy on 15/10/30.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "LatestViewController.h"
#import "FeaturedLayout.h"
#import "MJExtension.h"
#import "Featured.h"
#import "FeaturedCell.h"
#import "MJRefresh.h"
@interface LatestViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,FeaturedLayoutDelegate,UISearchDisplayDelegate>


@property (nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *featureds;
@end

@implementation LatestViewController


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
    
    NSArray *featuredArray = [Featured objectArrayWithFilename:@"1.plist"];
    [self.featureds addObjectsFromArray:featuredArray];
    
    FeaturedLayout *layout = [[FeaturedLayout alloc]init];
    layout.delegate = self;
    
    UICollectionView *collectionView= [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"FeaturedCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
//    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    
    //    view1 = [[UIView alloc]init];
    //    view1.frame = CGRectMake(0, 0, 100, 100);
    //    [view1 maskView];
    //    view1.backgroundColor = [UIColor whiteColor];
    //
    //    view1.hidden = NO;
    //    [self.view addSubview:view1];
    
}
-(void)loadMoreData:(MJRefreshFooter *)footer
{
    [footer endRefreshing];
}
-(CGFloat)featuredLayout:(FeaturedLayout *)featuredLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    Featured *featured = self.featureds[indexPath.item];
    return featured.h / featured.w *width;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.featureds.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeaturedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.featured =self.featureds[indexPath.item];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
