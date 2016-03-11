//
//  UIImage+HKExtension.m
//  weike
//
//  Created by mac on 15/9/22.
//  Copyright © 2015年 HK. All rights reserved.
//

#import "UIImage+HKExtension.h"

@implementation UIImage (HKExtension)

+ (UIImage *)resizedWithImage:(NSString *)imageName{
    UIImage * image = [UIImage imageNamed:imageName];
    [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return image;
}

@end
