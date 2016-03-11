//
//  LdyAccount.m
//  TalKNic
//
//  Created by Talknic on 15/12/17.
//  Copyright © 2015年 TalKNik. All rights reserved.
//

#import "LdyAccount.h"

@implementation LdyAccount


+(instancetype)accountWithDict:(NSDictionary *)dict

{
    LdyAccount *ldyaccount = [[self alloc]init];
    ldyaccount.tel = dict[@"tel"];
    ldyaccount.userpwd = dict[@"passwsd"];
    
    return ldyaccount;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tel forKey:@"tel"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
    }
    return self;
}
@end
