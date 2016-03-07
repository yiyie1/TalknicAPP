//
//  MeHeadViewController.h
//  TalKNic
//
//  Created by 罗大勇 on 15/12/15.
//  Copyright © 2015年 TalKNik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeHeadViewController;

@protocol MeImageCropperDelegate <NSObject>

-(void)imageCropper:(MeHeadViewController *)cropperViewController didFinished:(UIImage *)enitedImage;
-(void)imageCropperDidCancel:(MeHeadViewController *)cropperViewControlelr;

@end

@interface MeHeadViewController : UIViewController

@property (nonatomic,assign)NSInteger tag;
@property (nonatomic,assign)id<MeImageCropperDelegate>delegate;
@property (nonatomic,assign)CGRect cropFrame;

-(id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;


@end
