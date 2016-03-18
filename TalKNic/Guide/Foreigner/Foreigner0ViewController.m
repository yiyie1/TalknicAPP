//
//  Foreigner0ViewController.m
//  TalKNic
//
//  Created by Talknic on 15/12/8.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import "Foreigner0ViewController.h"
#import "ForeignerViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
#import "MeHeadViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"
@interface Foreigner0ViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,MeImageCropperDelegate,UINavigationControllerDelegate,UIPickerViewAccessibilityDelegate,UITextFieldDelegate>
{
    NSString *_sex;
}

@property (nonatomic,strong)UIImageView *imagePhoto,*chooseImage;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UITextField *usernameTf;
@property (nonatomic,strong)UIButton *maleBT;
@property (nonatomic,strong)UIButton *femaleBT;
@property (nonatomic,strong)UIButton *nextBT;
@property (nonatomic,strong)UIButton *leftBTLogin;
@property (nonatomic,strong)UITextField *nationalityTF;
@property (nonatomic,strong)UITextField *occupationTF;
@property (nonatomic,strong)UITextField *biographyTF;

@end

@implementation Foreigner0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = @"Information (1/3)";
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    self.navigationItem.titleView = title;
    
    
    [self informationView];
    [self initFeedText];
    
    
    
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
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait:)];
    [_imagePhoto addGestureRecognizer:portraitTap];
    _imagePhoto.userInteractionEnabled = YES;
    [self.view addSubview:_imagePhoto];
    
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(self.view.frame.size.width / 2.75, self.view.frame.size.height / 3.2, self.view.frame.size.width / 3.5, 30);
    _nameLabel.text = @"upload avatar";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    _nameLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    [self.view addSubview:_nameLabel];
    
}
-(void)usernametf
{
    
    self.usernameTf = [[UITextField alloc]init];
    _usernameTf.frame = kCGRectMake(50, 256.5, 277.77, 60);
    _usernameTf.placeholder = @"username";
    _usernameTf.delegate = self;
    [_usernameTf setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    _usernameTf.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_usernameTf];
    
    self.nationalityTF = [[UITextField alloc]init];
    _nationalityTF.frame = kCGRectMake(50, 397.6, 277.77, 60);
    _nationalityTF.placeholder = @"nationality";
    _nationalityTF.delegate = self;
    [_nationalityTF setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    _nationalityTF.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nationalityTF];
    
    self.occupationTF = [[UITextField alloc]init];
    _occupationTF.frame = kCGRectMake(50, 467.6, 277.77, 60);
    _occupationTF.placeholder = @"occupation";
    _occupationTF.delegate = self;
    [_occupationTF setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    _occupationTF.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_occupationTF];
    
    self.biographyTF = [[UITextField alloc]init];
    _biographyTF.frame = kCGRectMake(50, 537.6, 277.77, 60);
    _biographyTF.placeholder =@"biography(50 max)";
    _biographyTF.delegate =self;
    [_biographyTF setBackground:[UIImage imageNamed:@"login_input_lg.png"]];
    _biographyTF.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_biographyTF];
}
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
    labelMale.text = @"Male";
    labelMale.textColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    labelMale.frame = kCGRectMake(107, 340, 53.5, 33.35);
    [self.view addSubview:labelMale];
    
    self.femaleBT = [[UIButton alloc]init];
    _femaleBT.frame = kCGRectMake(208.3, 350, 15, 15);
    [_femaleBT setBackgroundImage:[UIImage imageNamed:@"login_tick.png"] forState:(UIControlStateNormal)];
    [_femaleBT addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_femaleBT];
    
    
    UILabel *felabel = [[UILabel alloc]init];
    felabel.frame = kCGRectMake(234.375, 340, 80, 33.35);
    felabel.text = @"Female";
    felabel.textColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    [self.view addSubview:felabel];
    
    
    
}
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
    if (_usernameTf.text.length == 0) {
        [MBProgressHUD showError:kAlertUsernamecannotbeEmpty];
        return;
    }
    if (_sex.length == 0 ) {
        [MBProgressHUD showError:kAlertSelectGender];
        return;
    }
    if (_nationalityTF.text.length == 0) {
        [MBProgressHUD showError:kAlertSelectNotion];
        return;
    }
    if (_occupationTF.text.length == 0) {
        [MBProgressHUD showError:kAlertProfession];
        return;
    }
    if (_biographyTF.text.length == 0) {
        [MBProgressHUD showError:kAlertPerson];
        return;
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"cmd"] = @"7";
    dic[@"user_id"] = _uID;
    dic[@"identity"] = @"1";
    dic[@"user_name"] = _usernameTf.text;
    dic[@"user_sex"] = _sex;
    dic[@"user_level"] = @"senior";
    dic[@"nationality"] = _nationalityTF.text;
    dic[@"occupation"] = _occupationTF.text;
    dic[@"biography"] = _biographyTF.text;
    TalkLog(@"asdas %@",dic);

    [session GET:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"上传成功 -- %@",responseObject);
        NSMutableDictionary *dicc = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dicc objectForKey:@"code"] intValue] == 2)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertSuccess delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            ForeignerViewController *foreVC = [[ForeignerViewController alloc]init];
            foreVC.usID = _uID;
            foreVC.usName = _usernameTf.text;
            foreVC.sex = _sex;
            foreVC.nation = _nationalityTF.text;
            foreVC.occup = _occupationTF.text;
            foreVC.biogra = _biographyTF.text;
            
            [self.navigationController pushViewController:foreVC animated:NO];
            TalkLog(@"dicc -- %@",dicc);
        }
        if (([(NSNumber *)[dicc objectForKey:@"code"] intValue] == 3)) {
            [MBProgressHUD showError:kAlertUploadFail];
            return ;
        }
        if (([(NSNumber *)[dicc objectForKey:@"code"] intValue] == 4)) {
            [MBProgressHUD showError:kAlertIDwrong];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
    
    
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_usernameTf resignFirstResponder];
    [_biographyTF resignFirstResponder];
    [_occupationTF resignFirstResponder];
    [_nationalityTF resignFirstResponder];
    
}
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
-(void)editPortrait:(UITapGestureRecognizer *)tap
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:kAlertOurceFile delegate:self cancelButtonTitle:kAlertCancel destructiveButtonTitle:nil otherButtonTitles:kAlertCamera,kAlertLocal, nil];
    [actionSheet showInView:self.view];
}

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
}
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
    
    [self shangchuan];
}
-(void)shangchuan
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
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSLog(@"上传头像 -- %@",data);
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        TalkLog(@"Succeed to upload image ---- %@",str);
        if(![str containsString:@"2"])
            [MBProgressHUD showError:kAlertdataFailure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (kHeight == 568) {
        
        if (textField == _nationalityTF){
            self.view.frame = CGRectMake(0, -(textField.frame.origin.y-200), kWidth, kHeight*1.5);
        }else if (textField == _occupationTF){
            self.view.frame = CGRectMake(0, -(textField.frame.origin.y-200), kWidth,kHeight*1.5);
        }else if (textField == _biographyTF){
            self.view.frame = CGRectMake(0, -(textField.frame.origin.y-200), kWidth, kHeight*1.5);
            
        }
        
    }else{
        if (textField == _nationalityTF){
            self.view.frame = CGRectMake(0, -(textField.frame.origin.y-300), kWidth, kHeight*1.5);
        }else if (textField == _occupationTF){
            self.view.frame = CGRectMake(0, -(textField.frame.origin.y-300), kWidth,kHeight*1.5);
        }else if (textField == _biographyTF){
            self.view.frame = CGRectMake(0, -(textField.frame.origin.y-300), kWidth, kHeight*1.5);
            
        }
        
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame = CGRectMake(0, 0, kWidth, kHeight);
    
}
-(void)initFeedText{
    
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:kCGRectMake(0, 0, 375, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    
    [_usernameTf setInputAccessoryView:topView];
    [_nationalityTF setInputAccessoryView:topView];
    [_occupationTF setInputAccessoryView:topView];
    [_biographyTF setInputAccessoryView:topView];
    
    
}
-(void)dismissKeyBoard{
    
    self.view.frame=CGRectMake(0, 0, kWidth, kHeight);
    
    [_usernameTf resignFirstResponder];
    [_nationalityTF resignFirstResponder];
    [_occupationTF resignFirstResponder];
    [_biographyTF resignFirstResponder];
    
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
