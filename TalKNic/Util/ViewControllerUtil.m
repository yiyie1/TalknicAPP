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

-(BOOL)IsValidChat:(NSString*) pay_time msg_time: (NSString*) msg_time
{
    NSDate *dateNow = [NSDate date];
    NSTimeInterval sec1970 = [dateNow timeIntervalSince1970];
    
    NSTimeInterval time_after_pay = sec1970 - [pay_time doubleValue];
    TalkLog(@"time_after_pay: %f hours", time_after_pay / 60 / 60);

    return time_after_pay < DEFAULT_MAX_CHAT_DURATION_MINS * 60 && ![msg_time isEqualToString:@"0"];
}

-(UINavigationBar* )ConfigNavigationBar:(NSString*)titleStr NavController: (UINavigationController *)NavController NavBar: (UINavigationBar*)NavBar
{
    [NavController setNavigationBarHidden:YES];
    if (NavBar == nil) {
        NavBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 129.0/2)];
        UIImage * img= [UIImage imageNamed:@"nav_bg.png"];
        img = [img stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        
        [NavBar setBackgroundImage:img forBarMetrics:(UIBarMetricsDefault)];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, KHeightScaled(10), kWidth, 129.0/2);//NavBar.frame;
        label.text = titleStr;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
        
        [NavBar addSubview:label];
        //[self.view addSubview:_bar];
    }
    return NavBar;
}

-(NSString*)CheckRole
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kChooese_ChineseOrForeigner] isEqualToString:@"Chinese"])
        return CHINESEUSER;
    else
        return FOREINERUSER;
}

-(NSString*)GetUid
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}

-(BOOL)CheckFinishedInformation
{
    return ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FinishedInformation"] isEqualToString:@"Done"]);
}
@end
