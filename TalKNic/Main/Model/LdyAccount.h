//
//  LdyAccount.h
//  TalKNic
//
//  Created by 罗大勇 on 15/12/17.
//  Copyright © 2015年 TalKNik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LdyAccount : NSObject<NSCoding>
//手机号
@property (nonatomic,copy)NSString *tel;
// 密码
@property (nonatomic,copy)NSString *userpwd;

+(instancetype)accountWithDict:(NSDictionary *)dict;
@end
