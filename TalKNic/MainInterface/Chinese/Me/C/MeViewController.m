//
//  MeViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/20.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "EditProfileViewController.h"
#import "MeViewController.h"
#import "MeSetup.h"
#import "BalanceViewController.h"
#import "CreditCardViewController.h"
#import "VoiceViewController.h"
#import "QaViewController.h"
#import "AboutViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AppDelegate+ShareSDK.h"
#import <MessageUI/MessageUI.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "MeHeadViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
#import "ViewControllerUtil.h"

//#import "UMSocial.h"
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,MeImageCropperDelegate,UITextViewDelegate,UIPickerViewAccessibilityDelegate,UINavigationControllerDelegate>
{
    NSArray *_allMesetup;
    UITextView * _nameText;
    UITextView * _topText;
    NSArray *_GeneralGroup;
}

@property(nonatomic,strong)NSArray *searchArr; //保存searchBar搜索到的数据
@property(nonatomic)BOOL isClickFeeds;
@property(nonatomic)BOOL isClickFollowed;
@property(nonatomic)BOOL isClickFollowing;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *rightItem;
@property (nonatomic,strong)UIImageView *imageViewBar;
@property (nonatomic,strong)UIImageView *photoView;

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *countries;

@property (nonatomic,strong)UIButton *editBtn;
@property (nonatomic,strong)UILabel *about;

@property (nonatomic,strong)UIButton *feedsBtn;
@property (nonatomic,strong)UIButton *followedBtn;
@property (nonatomic,strong)UIButton *followingBtn;

@property (nonatomic,strong)UILabel *feeds1Label;
@property (nonatomic,strong)UILabel *followed1Label;
@property (nonatomic,strong)UILabel *following1Label;

@property (nonatomic,strong)UILabel *feeds2Label;
@property (nonatomic,strong)UILabel *followed2Label;
@property (nonatomic,strong)UILabel *following2Label;

@property (nonatomic,strong)UIView *backview;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewControllerUtil SetTitle:AppMe];

    [ViewControllerUtil verifyFreeUser];
    
    [self Setting];
    [self LayoutProfile];
    [self TopBarView];
    [self TableView];
    [self layoutClickBtnGetSearchBar];
    //设置头像
    [self portraitImageView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadId];
    [ViewControllerUtil verifyFreeUser];
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    
    if([_role isEqualToString:CHINESEUSER])
        _GeneralGroup = @[AppInviteFriends, AppQA,AppAbout];
    else
        _GeneralGroup = @[AppInviteFriends,AppAbout];
    
    if([ViewControllerUtil CheckFreeUser])
    {
        _allMesetup =@[[MeSetup mesetupWithHeader:AppPayment group:@[AppHistory]],
                       [MeSetup mesetupWithHeader:AppGeneral group:_GeneralGroup]];
    }
    else
    {
        _allMesetup =@[[MeSetup mesetupWithHeader:AppPayment group:@[AppBalance,AppCreditCard,AppHistory]],
                       [MeSetup mesetupWithHeader:AppGeneral group:_GeneralGroup]];
    }
    [self.tableView reloadData];
}

-(void)portraitImageView
{
    self.photoView = [[UIImageView alloc]init];
    _photoView.frame = kCGRectMake(15, 30, 82.5, 82.5);
    _photoView.image = [UIImage imageNamed:@"me_avatar_area.png"];
    _photoView.layer.cornerRadius = _photoView.frame.size.width /2;
    _photoView.layer.masksToBounds = YES;
    _photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait:)];
    [_photoView addGestureRecognizer:portraitTap];
    [_imageViewBar addSubview:_photoView];
}

//头像点击方法
-(void)editPortrait:(UITapGestureRecognizer *)tap
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:kAlertOurceFile delegate:self cancelButtonTitle:kAlertCancel destructiveButtonTitle:nil otherButtonTitles:kAlertCamera,kAlertLocal, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    TalkLog(@"buttonIndex = [%ld]",(long)buttonIndex);
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            
            break;
        case 1://本地相册
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }
    
}
/*
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TalkLog(@"buttonIndex = [%ld]",(long)buttonIndex);
    switch (buttonIndex) {
        case 0://照相机
            
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            
            break;
        case 1://本地相册
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }
}*/

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:) withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveImage:(UIImage *)image
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    success  = [fileManager fileExistsAtPath:imageFilePath];
    if (success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(80, 80)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];
    self.photoView.image = selfPhoto;
    
    [self uploadImage];
}

-(void)uploadImage
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
    UIImage *image = _photoView.image;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cmd"] = @"6";
    param[@"user_id"] = _uid;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    [session POST:PATH_GET_LOGIN parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSLog(@"%@",data);
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        TalkLog(@"Succeed to upload image ---- %@",str);
        if(![str containsString:@"2"])
            [MBProgressHUD showError:kAlertdataFailure];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ViewControllerUtil showNetworkErrorMessage: error];
    }];
}

//改变图像的尺寸，方便上传服务器
-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:kCGRectMake(0, 0, 37, 37)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width);
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height);
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(kCGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

-(void)loadId
{
    if(_uid.length == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAlertNotLogin message:kAlertPlsLogin preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:AppCancel style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:AppSure style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            LoginViewController* login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parme = [NSMutableDictionary dictionary];
    parme[@"cmd"] = @"19";
    parme[@"user_id"] = _uid;
    TalkLog(@"Me ID -- %@",_uid);
    [session POST:PATH_GET_LOGIN parameters:parme progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"Me result: %@",responseObject);
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"] isEqualToString:SERVER_SUCCESS])
        {
            NSDictionary *dict = [dic objectForKey:@"result"];
            if([_role isEqualToString:CHINESEUSER])
                _countries.text = @"China";
            else
                _countries.text = [dict objectForKey:@"nationality"];
            
            self.location = _countries.text;
            
            _nameLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            self.name = _nameLabel.text;
            
            _followed1Label.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fans"]];
            _following1Label.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"praise"]];
            
            _about.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bio"]];
            self.bio = _about.text;
            
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
            [self.photoView sd_setImageWithURL:url placeholderImage:nil];
            
            NSString* bSina = [dict objectForKey:@"sina"];
            if(bSina.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bSina forKey:@"Weibo"];
            
            NSString* bWechat = [dict objectForKey:@"wechat"];
            if(bWechat.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bWechat forKey:@"Wechat"];
            
            NSString* bEmail = [dict objectForKey:@"email"];
            if(bEmail.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bEmail forKey:@"Email"];
            
            NSString* bMobile = [dict objectForKey:@"mobile"];
            if(bMobile.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bMobile forKey:@"Mobile"];
            
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
        [ViewControllerUtil showNetworkErrorMessage: error];
    }];
}
-(void)layoutClickBtnGetSearchBar
{
    self.isClickFeeds = NO;
    self.isClickFollowed = NO;
    self.isClickFollowing = NO;
    
    UIView *backView = [[UIView alloc]initWithFrame:kCGRectMake(0, CGRectGetMaxY(self.imageViewBar.frame), 375, 667 - CGRectGetMaxY(self.imageViewBar.frame))];
    [backView setBackgroundColor:[UIColor grayColor]];
    backView.alpha = 0.4;
    
    [[[UIApplication sharedApplication].windows lastObject]addSubview:backView];
    self.backview = backView;
    self.backview.hidden = YES;
    [[[UIApplication sharedApplication].windows lastObject]addSubview:self.searchBarView];
    self.searchBarView.hidden = YES;
    self.searchBarView.center = CGPointMake(kWidth / 2, CGRectGetMaxY(self.imageViewBar.frame) + self.searchBarView.height /2) ;
    self.searchBarView.backgroundColor = [UIColor clearColor];
    self.searchTable.delegate = self;
    self.searchTable.dataSource = self;
}
#pragma mark - 图片剪辑
////图片裁剪
//-(UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect {
//    // CGSize subImageSize = CGSizeMake(kWidth, kHeight); //定义裁剪的区域相对于原图片的位置
//    // CGRect subImageRect = kCGRectMake(START_X, START_Y, kWidth, kHeight);
//    CGImageRef imageRef = superImage.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
//    UIGraphicsBeginImageContext(subImageSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, subImageRect, subImageRef);
//    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext(); //返回裁剪的部分图像
//    return returnImage;
//}
-(void)Setting
{
    self.rightItem = [[UIButton alloc]init];
    _rightItem.frame = kCGRectMake(0, 0, 41/2, 42/2);
    [_rightItem setBackgroundImage:[UIImage imageNamed:@"me_setting_icon.png"] forState:(UIControlStateNormal)];
    [_rightItem addTarget:self action:@selector(settingAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *right =[[UIBarButtonItem alloc]initWithCustomView:_rightItem];
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)LayoutProfile
{
    self.imageViewBar = [[UIImageView alloc]init];
    //FIXME a gap btw top_bar and nav bar
    //_imageViewBar.frame = CGRectMake(0, 129.0/2 + KHeightScaled(3.0/2), KWidthScaled(375), KHeightScaled(191.5));
    _imageViewBar.frame = CGRectMake(0, 64, kWidth, KHeightScaled(191.5));
    _imageViewBar.image = [UIImage imageNamed:@"me_top_bar.png"];
    _imageViewBar.userInteractionEnabled = YES;
    [self.view addSubview:_imageViewBar];
}
-(void)TopBarView
{
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = kCGRectMake(112.5, 10, 150, 25);
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.numberOfLines = 0;
    _nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    [_imageViewBar addSubview:_nameLabel];
    
    self.countries = [[UILabel alloc]init];
    _countries.frame = kCGRectMake(112.5, 27, 150, 25);
    _countries.textColor = [UIColor whiteColor];
    _countries.numberOfLines = 0;
    _countries.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    [_imageViewBar addSubview:_countries];
    
    self.editBtn = [[UIButton alloc]init];
    _editBtn.frame = kCGRectMake(112.5, 52.5, 210.5, 36.5);
    #warning 修改7 开始处
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"me_profile_btn.png"] forState:(UIControlStateNormal)];
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"me_profile_btn_a.png"] forState:(UIControlStateHighlighted)];
    [_editBtn setTitle:AppEditProfile forState:(UIControlStateNormal)];
    _editBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:12.0];
    [_editBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    
    //[_editBtn setTitle:AppEditProfile forState:UIControlStateNormal];
    //_editBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:12.0f];
    //[_editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
#warning 修改7 结束处
    
    [_editBtn addTarget:self action:@selector(editprofileAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_imageViewBar addSubview:_editBtn];
    
    self.about = [[UILabel alloc]init];
    _about.frame = kCGRectMake(112.5, 95, 232.5, 38);
//    _about.text = @"Live in Los Angeles for 2 years! Now I am in Shanghai. Funny, Chatting, make friends with you guys!\nThanks for following me, hoping you will have a good life.";
    _about.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.0];
    _about.textColor = [UIColor whiteColor];
    _about.numberOfLines = 0;
    _about.textAlignment = NSTextAlignmentLeft;
    [_imageViewBar addSubview:_about];
    
    UIImageView *horizontalLine = [[UIImageView alloc]init];
    horizontalLine.frame = kCGRectMake(30, 165/2 +60, 315, 1);
    horizontalLine.image = [UIImage imageNamed:@"me_line_center_long.png"];
    [_imageViewBar addSubview:horizontalLine];
    
    //选项卡1
    self.feeds1Label = [[UILabel alloc]initWithFrame:kCGRectMake(39, 165/2+67, 40, 20)];
    _feeds1Label.text = @"0";
    _feeds1Label.textColor = [UIColor whiteColor];
    _feeds1Label.textAlignment = NSTextAlignmentCenter;
    _feeds2Label.numberOfLines = 0;
    _feeds1Label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    [_imageViewBar addSubview:_feeds1Label];
    self.feeds2Label = [[UILabel alloc]initWithFrame:kCGRectMake(35, 165/2+81, 50, 20)];
    _feeds2Label.text = AppFeeds;
    _feeds2Label.textColor = [UIColor whiteColor];
    _feeds2Label.textAlignment = NSTextAlignmentCenter;
    _feeds2Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    [_imageViewBar addSubview:_feeds2Label];
    
    self.feedsBtn = [[UIButton alloc]initWithFrame:kCGRectMake(35, 165/2+67, 50, 35)];
    _feedsBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.00001];
//    _feedsBtn.imageEdgeInsets = UIEdgeInsetsMake(32, 0, 2, 0);
    
    [_feedsBtn addTarget:self action:@selector(optionsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_imageViewBar addSubview:_feedsBtn];
    
    //选项卡2
    self.followed1Label = [[UILabel alloc]initWithFrame:kCGRectMake(165, 165/2+67, 40, 20)];
//    _followed1Label.text = @"52";
    _followed1Label.textAlignment = NSTextAlignmentCenter;
    _followed1Label.numberOfLines = 0;
    _followed1Label.textColor = [UIColor whiteColor];
    _followed1Label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    [_imageViewBar addSubview:_followed1Label];
    self.followed2Label = [[UILabel alloc]initWithFrame:kCGRectMake(161, 165/2+81, 50, 20)];
    _followed2Label.text = AppFollowed;
    _followed2Label.textAlignment = NSTextAlignmentCenter;
    _followed2Label.textColor = [UIColor whiteColor];
    _followed2Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    _followed2Label.numberOfLines = 0;
    [_imageViewBar addSubview:_followed2Label];
    
    self.followedBtn = [[UIButton alloc]initWithFrame:kCGRectMake(161, 165/2 +67, 50, 35)];
    _followedBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.00001];
    [_followedBtn addTarget:self action:@selector(optionsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_imageViewBar addSubview:_followedBtn];
    
    //选项卡3
    self.following1Label = [[UILabel alloc]initWithFrame:kCGRectMake(296, 165/2+67, 40, 20)];
//    _following1Label.text = @"76";
    _following1Label.textAlignment = NSTextAlignmentCenter;
    _following1Label.numberOfLines = 0;
    _following1Label.textColor = [UIColor whiteColor];
    _following1Label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
    [_imageViewBar addSubview:_following1Label];
    self.following2Label = [[UILabel alloc]initWithFrame:kCGRectMake(292, 165/2+81, 50, 20)];
    _following2Label.text = AppFollowing;
    _following2Label.textAlignment = NSTextAlignmentCenter;
    _following2Label.textColor = [UIColor whiteColor];
    _following2Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    _following2Label.numberOfLines = 0;
    [_imageViewBar addSubview:_following2Label];
    self.followingBtn = [[UIButton alloc]initWithFrame:kCGRectMake(292, 165/2+67, 50, 35)];
    [_followingBtn addTarget:self action:@selector(optionsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _followingBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.00001];
    [_imageViewBar addSubview:_followingBtn];
    

}
-(void)TableView
{
    self.tableView = [[UITableView alloc]initWithFrame: CGRectMake(0,129.0/2 + KHeightScaled(191.5), kWidth, KHeightScaled(kHeight-191.5-50)) style:(UITableViewStyleGrouped)];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    [_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return _allMesetup.count;
    }else
    {
        return 1;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        MeSetup *mesetup = _allMesetup[section];
        return  mesetup.grouping.count;
    }else
    {
        return self.searchArr.count;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];

    if (tableView == self.tableView) {
        MeSetup *mesetup = _allMesetup[indexPath.section];
        cell.textLabel.text = mesetup.grouping[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
        cell.textLabel.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
        
        NSArray *arr = nil;
        if([ViewControllerUtil CheckFreeUser])
        {
            if([_role isEqualToString:CHINESEUSER])
                arr = @[@[@"me_history_icon.png"],@[@"me_invite_icon.png",@"me_qa_icon.png",@"me_about_icon.png"]];
            else
                arr = @[@[@"me_history_icon.png"],@[@"me_invite_icon.png",@"me_about_icon.png"]];
        }
        else
        {
            if([_role isEqualToString:CHINESEUSER])
            {
                arr = @[@[@"me_balance_icon.png",@"me_card_icon.png",@"me_history_icon.png"],@[@"me_invite_icon.png",@"me_qa_icon.png",@"me_about_icon.png"]];
            }
            else
            {
                arr = @[@[@"me_balance_icon.png",@"me_card_icon.png",@"me_history_icon.png"],@[@"me_invite_icon.png",@"me_about_icon.png"]];
            }
        }
        cell.imageView.image = [UIImage imageNamed:arr[indexPath.section][indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else
    {
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  KHeightScaled(40);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHeightScaled(20);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return KHeightScaled(0.01);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==0)
    {
        UILabel *label = [[UILabel alloc]init];
        label.frame = kCGRectMake(10, 3, 100, 15);
        label.font = [UIFont fontWithName:kHelveticaLight size:14.0];
        label.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
        if([ViewControllerUtil CheckFreeUser])
            label.text = @"";
        else
            label.text = AppPayment;
        return label;
    }
    else
    {
        UILabel *label = [[UILabel alloc]init];
        label.frame = kCGRectMake(10, 3, 100, 15);
        label.font = [UIFont fontWithName:kHelveticaLight size:14.0];
        label.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
        label.text = AppGeneral;
        return label;
        
    }
}

-(void)settingAction
{
    self.isClickFeeds = NO;
    self.isClickFollowed = NO;
    self.isClickFollowing = NO;
    
    self.backview.hidden = YES;
    self.searchBarView.hidden = YES;
    
    SettingViewController *setVC = [[SettingViewController alloc]init];
    setVC.uid = _uid;
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)editprofileAction
{
    EditProfileViewController *editVc = [[EditProfileViewController alloc]init];
    editVc.uid = _uid;
    editVc.name = _name;
    editVc.occupation = _occupation;
    editVc.location = _location;
    editVc.bio = _bio;
    [self.navigationController pushViewController:editVc animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if (range.length>50)
        
    {
        
        //控制输入文本的长度
        
        return  NO;
        
    }
    
    if ([text isEqualToString:@"\n"]) {
        
        //禁止输入换行
        
        return NO;
        
    }
    
    else
        
    {
        
        return YES;
        
    }
    
}

-(void)optionsAction:(id)sender
{
    /*self.searchBarView.hidden = NO;
    //self.backview.hidden = NO;
    [self.view setBackgroundColor:[UIColor grayColor]];
    self.tableView.hidden = YES;
    if (sender == self.feedsBtn)
    {
        self.isClickFeeds = !self.isClickFeeds;
        self.isClickFollowed = NO;
        self.isClickFollowing = NO;
        
        _feedsBtn.imageEdgeInsets = UIEdgeInsetsMake(32, 0, 2, 0);
        _feedsBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.00001];
        [_feedsBtn setImage:[UIImage imageNamed:@"me_feeditem_line.png"] forState:(UIControlStateNormal)];
        [_followedBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_followingBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [self.imageview setImage:[UIImage imageNamed:@"me_feeds_tab_bg.png"]];
    }
    else if (sender == self.followedBtn)
    {
        self.isClickFeeds = NO;
        self.isClickFollowed = !self.isClickFollowed;
        self.isClickFollowing = NO;
        _followedBtn.imageEdgeInsets = UIEdgeInsetsMake(32, 0, 2, 0);
        [_followedBtn setImage:[UIImage imageNamed:@"me_feeditem_line.png"] forState:(UIControlStateNormal)];
        [_feedsBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [_followingBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [self.imageview setImage:[UIImage imageNamed:@"me_followed_bg.png"]];
        
    }
    else
    {
        self.isClickFeeds = NO;
        self.isClickFollowed = NO;
        self.isClickFollowing = !self.isClickFollowing;
        _followingBtn.imageEdgeInsets = UIEdgeInsetsMake(32, 0, 2, 0);
        [_followingBtn setImage:[UIImage imageNamed:@"me_feeditem_line.png"] forState:(UIControlStateNormal)];
        [_feedsBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [_followedBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        
        [self.imageview setImage:[UIImage imageNamed:@"me_following_tab_bg.png"]];
    }
    if (!self.isClickFeeds && !self.isClickFollowed && !self.isClickFollowing) {
        self.searchBarView.hidden = YES;
        self.tableView.hidden = NO;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        //self.backview.hidden = YES;
    }*/
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:AppBalance])
    {
        BalanceViewController *balanceVC = [[BalanceViewController alloc]init];
        balanceVC.uid = _uid;
        [self.navigationController pushViewController:balanceVC animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:AppCreditCard])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
        CreditCardViewController *creditVC = [storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
        creditVC.uid = _uid;
        [self.navigationController pushViewController:creditVC animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:AppHistory])
    {
        VoiceViewController *historyVC = [[VoiceViewController alloc]init];
        historyVC.uid = _uid;
        historyVC.needBack = YES;
        historyVC.titleStr = AppHistory;
        [self.navigationController pushViewController:historyVC animated:YES];

    }
    else if ([cell.textLabel.text isEqualToString:AppInviteFriends])
    {
        //[MBProgressHUD showError:@"Not Implemented"];
        //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Share your Talknic" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:AppCancel style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *wechatFriendAction = [UIAlertAction actionWithTitle:@"Share wechat friends" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            [ViewControllerUtil simplyShare:SSDKPlatformSubTypeWechatSession];
            return;
        }];
        
        UIAlertAction *wechatTimelineAction = [UIAlertAction actionWithTitle:@"Share wechat timeline" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [ViewControllerUtil simplyShare:SSDKPlatformSubTypeWechatTimeline];
            return;
        }];
        
        UIAlertAction *weiboAction = [UIAlertAction actionWithTitle:@"Share weibo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [ViewControllerUtil simplyShare:SSDKPlatformTypeSinaWeibo];
            return;
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:wechatFriendAction];
        [alertController addAction:wechatTimelineAction];
        [alertController addAction:weiboAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([cell.textLabel.text isEqualToString:AppQA])
    {
        QaViewController *qaVC = [[QaViewController alloc]init];
        qaVC.uid = _uid;
        [self.navigationController pushViewController:qaVC animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:AppAbout])
    {
        AboutViewController *aboutVC= [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameText resignFirstResponder];
    [_topText resignFirstResponder];
    [self.searchTable resignFirstResponder];
    [self.searchBar resignFirstResponder];
    self.searchBarView.hidden = YES;
    self.backview.hidden = YES;
    
    self.isClickFeeds = NO;
    self.isClickFollowed = NO;
    self.isClickFollowing = NO;
    
    self.tableView.hidden = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = NO;
    
    self.searchBarView.hidden = YES;
    self.tableView.hidden = NO;
    self.backview.hidden = YES;

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    self.isClickFeeds = NO;
    self.isClickFollowed = NO;
    self.isClickFollowing = NO;
    
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
