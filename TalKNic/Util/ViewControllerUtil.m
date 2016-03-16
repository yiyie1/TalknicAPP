//
//  ViewControllerUtil.m
//  TalkNic
//
//  Created by Lingyi on 16/3/15.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "ViewControllerUtil.h"

@implementation ViewControllerUtil

- (UILabel *)SetTitle:(NSString *)titleStr
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = titleStr;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    return title;
}

-(NSString*)CheckRole
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *role = [user objectForKey:kChooese_ChineseOrForeigner];
    if([role isEqualToString:@"Chinese"])
        return CHINESEUSER;
    else
        return FOREINERUSER;
}
@end
