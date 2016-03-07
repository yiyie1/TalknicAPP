//
//  ChatViewController.m
//  TalKNic
//
//  Created by 罗大勇 on 15/12/7.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import "ChatViewController.h"
#import "leftCell.h"
#import "RightcellTableViewCell.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *sayBtn;
@property (nonatomic,strong)NSMutableArray *messages;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIButton *btnLeft;
@property (nonatomic,strong)UIButton *btnMe;

@property (nonatomic,strong)UILabel *avaliLabel;
@property (nonatomic,strong)UILabel *nameLabel;


@property (nonatomic,strong)UIButton *sendVoice;

@property (strong ,nonatomic) UIImageView * imagevie;

@property (assign ,nonatomic) int l;

@end

@implementation ChatViewController

-(void)viewWillAppear:(BOOL)animated{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.l = 1;

    self.tabBarController.tabBar.hidden = YES;
    
    [self layoutBtn];
    
    [self Personalinformation];
    
//    [self layoutChatView];
    
   
    [self image];
    self.tableview.delegate = self;
    
    self.tableview.dataSource = self;
    
    self.tableview.tableFooterView = [[UIView alloc]init];
    [self.sayBtn setBackgroundImage:[UIImage imageNamed:@"msg_audio_input_icon.png"] forState:(UIControlStateNormal)];
//    self.sayBtn.backgroundColor = [UIColor redColor];
    
    UILongPressGestureRecognizer * longPG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPG.minimumPressDuration = 0.1;
    [self.sayBtn  addGestureRecognizer:longPG];
    
    [self.view addSubview:_tableview];
//    self.tableview.backgroundColor = [UIColor redColor];
    
    
}

-(void)image
{
    self.imagevie = [[UIImageView alloc]initWithFrame:CGRectMake(0, 596, self.view.frame.size.width, 70)];
    NSMutableArray * arr = [NSMutableArray array];
    for (int a=1 ; a<4; a++) {
        UIImage * image =[UIImage imageNamed:[NSString stringWithFormat:@"msg_audio_wave_%d.png",a]];
        [arr addObject:image];
    }
    [self.view addSubview:self.imagevie];
    self.imagevie.animationImages=arr;
    self.imagevie.animationDuration=1;
    if (self.l == 1) {
//        self.imagevie.animationRepeatCount=0;

    }
    NSLog(@"%@",arr);
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        self.imagevie.animationRepeatCount=0;
            [self.imagevie startAnimating];

    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
            [self.imagevie stopAnimating];

    }
}


//-(NSMutableArray *)messages
//{
//    if (_messages == nil) {
//        
//        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil]];
//        
//        NSMutableArray *messageArr = [NSMutableArray array];
//        
//        for (NSDictionary *dic in array) {
//            MessageModel *messag = [MessageModel messageWithDict:dic];
//            [_messages addObject:messag];
//            [messageArr addObject:messag];
//        }
//        _messages = messageArr;
//        
//    }
//    return _messages;
//}
-(void)Personalinformation
{
    self.avaliLabel = [[UILabel alloc]init];
    _avaliLabel.frame = kCGRectMake(150, 5, 175, 12);
    _avaliLabel.text = @"avaliable";
    _avaliLabel.textColor = [UIColor whiteColor];
    _avaliLabel.textAlignment = NSTextAlignmentRight;
    _avaliLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:9];
    
    [self.navigationController.navigationBar addSubview:_avaliLabel];
    
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = kCGRectMake(150, 20, 175, 18);
    _nameLabel.text = @"Nick Sullivane";
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:17];
    [self.navigationController.navigationBar addSubview:_nameLabel];
}
-(void)layoutBtn
{
    self.btnLeft = [[UIButton alloc]init];
    _btnLeft.frame = kCGRectMake(21, 0, 49/2, 49/2);
    [_btnLeft setBackgroundImage:[UIImage imageNamed:@"msg_allview_icon.png"] forState:(UIControlStateNormal)];
    [_btnLeft addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftIm = [[UIBarButtonItem alloc]initWithCustomView:_btnLeft];
    self.navigationItem.leftBarButtonItem = leftIm;
    
    self.btnMe = [[UIButton alloc]init];
    _btnMe.frame = kCGRectMake(375 - 51/2 - 20, 0,51/2 , 51/2);
    [_btnMe setBackgroundImage:[UIImage imageNamed:@"msg_audio_avatar.png"] forState:(UIControlStateNormal)];
    [_btnMe addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightIm =[[UIBarButtonItem alloc]initWithCustomView:_btnMe];
    self.navigationItem.rightBarButtonItem = rightIm;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    
    if (indexPath.row % 2 == 0) {
        leftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftcell"];
        cell.timeLb.text = @"10s";
        cell.deetaLb.text = date;
        return cell;
    }else
    {
        RightcellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightcell"];
        cell.timelb.text = @"5s";
        cell.detaLb.text = date;
        
        return cell;
        
    }

}

-(void)sendVoiceAction
{
    
}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
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
