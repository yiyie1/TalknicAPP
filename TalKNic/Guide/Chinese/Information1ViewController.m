//
//  Information1ViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "Information1ViewController.h"
#import "Information2ViewController.h"
#import "LoginViewController.h"
#import "MeHeadViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
#import "Information2ViewController.h"
#import "ViewControllerUtil.h"

@interface Information1ViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,MeImageCropperDelegate,UINavigationControllerDelegate,UIPickerViewAccessibilityDelegate>
{
    UIAlertController *_alert;
    NSString *uuID;
}
@property (nonatomic,strong)UIImageView *imagePhoto,*chooseImage;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UITextField *usernameTf;
@property (nonatomic,strong)UIButton *maleBT;
@property (nonatomic,strong)UIButton *femaleBT;
@property (nonatomic,strong)UIButton *nextBT;
@property (nonatomic,strong)UIButton *leftBTLogin;
@property (nonatomic) BOOL bUploadPhoto; //default NO;

@end

@implementation Information1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewControllerUtil SetTitle:AppInformation1];
    
    [self informationView];
    
    self.bUploadPhoto = NO;
}

-(void)informationView
{
    [self userphoto];
    [self usernametf];
    [self chooseView];
    [self nextbtt];
}
-(void)userphoto
{
    
    self.imagePhoto = [[UIImageView alloc]init];
    _imagePhoto.frame = CGRectMake(self.view.frame.size.width / 2.5, self.view.frame.size.height / 6, self.view.frame.size.width / 4.68, self.view.frame.size.width / 4.68);
    _imagePhoto.image = [UIImage imageNamed:@"login_avatar.png"];
    _imagePhoto.userInteractionEnabled= YES;
    _imagePhoto.layer.cornerRadius = _imagePhoto.frame.size.width /2;
    _imagePhoto.layer.masksToBounds = YES;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait:)];
    [_imagePhoto addGestureRecognizer:portraitTap];
    [self.view addSubview:_imagePhoto];
    
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(self.view.frame.size.width / 2.75, self.view.frame.size.height / 3.2, self.view.frame.size.width / 3.5, 30);
    _nameLabel.text = AppUploadPhoto;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont fontWithName:kHelveticaLight size:15.0];
    _nameLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    [self.view addSubview:_nameLabel];
    
}
//用户名
-(void)usernametf
{
    
    self.usernameTf = [[UITextField alloc]init];
    _usernameTf.frame = kCGRectMake(50, 256.5, 277.77, 60);
    _usernameTf.placeholder = AppUserName;
    [_usernameTf setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    _usernameTf.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_usernameTf];
}
//选择性别
-(void)chooseView
{
    
    self.chooseImage = [[UIImageView alloc]init];
    _chooseImage.frame = kCGRectMake(50, 327.6, 277.77, 60);
    _chooseImage.image = [UIImage imageNamed:@"login_input_lg.png"];
    [self.view addSubview:_chooseImage];
    
    
    self.maleBT = [[UIButton alloc]init];
    _maleBT.frame = kCGRectMake(81.5, 350, 15, 15);
    [_maleBT setImage:[UIImage imageNamed:@"login_tick.png"] forState:(UIControlStateNormal)];
    [_maleBT addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)
     ];
    [self.view addSubview:_maleBT];
    UILabel *labelMale  =[[UILabel alloc]init];
    labelMale.text = AppMale;
    labelMale.textColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    labelMale.frame = kCGRectMake(107, 340, 53.5, 33.35);
    [self.view addSubview:labelMale];
    
    self.femaleBT = [[UIButton alloc]init];
    _femaleBT.frame = kCGRectMake(208.3, 350, 15, 15);
    [_femaleBT setBackgroundImage:[UIImage imageNamed:@"login_tick.png"] forState:(UIControlStateNormal)];
    [_femaleBT addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_femaleBT];
    UILabel *felabel = [[UILabel alloc]init];
    felabel.frame = kCGRectMake(234.375, 340, 70, 33.35);
    felabel.text = AppFemail;
    felabel.textColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    [self.view addSubview:felabel];
    
    
    
}
//跳转
-(void)nextbtt
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:(UIBarButtonItemStylePlain) target:self action:@selector(nextAction)];
    rightItem.tintColor =[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.leftBTLogin = [[UIButton alloc]init];
    _leftBTLogin.frame =CGRectMake(0, 0, 7, 23/2);
    [_leftBTLogin setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBTLogin addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftItEm = [[UIBarButtonItem alloc]initWithCustomView:_leftBTLogin];
    self.navigationItem.leftBarButtonItem = leftItEm;
    
}
-(void)nextAction
{
    _unameID = _usernameTf.text;
    if (self.usernameTf.text.length ==0)
    {
        [MBProgressHUD showError:kAlertUsernamecannotbeEmpty];
        return;
    }
    if (_sex.length ==0) {
        [MBProgressHUD showError:kAlertSex];
        return;
    }
    
    if(_bUploadPhoto == NO)
    {
        [MBProgressHUD showError:kAlertPhoto];
        return;
    }
    uuID = _uID;

    
    Information2ViewController *infor2VC = [[Information2ViewController alloc]init];
    infor2VC.usID = uuID;
    
    infor2VC.nameID = _unameID;
    infor2VC.sexID = _sex;
    
    TalkLog(@"usid = %@ -nameid = %@ - sexid = %@ ",uuID,_unameID,_sex);
    [self.navigationController pushViewController:infor2VC animated:YES];
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_usernameTf resignFirstResponder];
    
}
//选择
-(void)click:(id)sender
{
    
    if (sender == self.maleBT) {
        _sex = @"male";
        [_maleBT setImage:[UIImage imageNamed:@"login_tick_a.png"] forState:(UIControlStateNormal)];
        [_femaleBT setImage:[UIImage imageNamed:@"login_tick.png"] forState:(UIControlStateNormal)];
    }
    if (sender == self.femaleBT) {
        _sex = @"female";
        [_maleBT setImage:[UIImage imageNamed:@"login_tick.png"] forState:(UIControlStateNormal)];
        [_femaleBT setImage:[UIImage imageNamed:@"login_tick_a.png"] forState:(UIControlStateNormal)];
    }
    
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
    self.imagePhoto.image = selfPhoto;
    
    [self uploadPhoto];
}

-(void)uploadPhoto
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
    UIImage *image = _imagePhoto.image;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cmd"] = @"6";
    param[@"user_id"] = _uID;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    [session POST:PATH_GET_LOGIN parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        NSLog(@"Image data -- %@",data);
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        TalkLog(@"return value ---- %@",str);
        if (![str containsString:@"2"])
        {
            [MBProgressHUD showError:kAlertdataFailure];
            return;
        }
        
        self.bUploadPhoto = YES;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ViewControllerUtil showNetworkErrorMessage: error];

    }];
}

//改变图像的尺寸，方便上传服务器
-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, 37, 37)];
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
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


//改变导航栏字体大小和颜色
//[self.navigationController.navigationBar setTitleTextAttributes:
// @{NSFontAttributeName:[UIFont systemFontOfSize:20],
//   NSForegroundColorAttributeName:[UIColor blackColor]}];


//UIBarButtonItem*leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回"style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
//
//[leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold"size:17.0], NSFontAttributeName, [UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//self.navigationItem.leftBarButtonItem = leftButton;


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
