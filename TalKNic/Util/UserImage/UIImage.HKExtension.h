//
//  UIImage+HKExtension.h
//  weike
//
//  Created by mac on 15/9/22.
//  Copyright © 2015年 HK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HKExtension)

/**
 *  返回一个拉伸的图片
 *
 *  @param imageName 图片名称
 *
 *  @return 返回一个拉伸好的图片
 */
+ (UIImage *)resizedWithImage:(NSString *)imageName;

@end
