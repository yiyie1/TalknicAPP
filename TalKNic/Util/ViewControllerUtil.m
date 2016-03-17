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

-(UINavigationBar* )ConfigNavigationBar:(NSString*)titleStr NavController: (UINavigationController *)NavController NavBar: (UINavigationBar*)NavBar
{
    [NavController setNavigationBarHidden:YES];
    if (NavBar == nil) {
        NavBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 129.0/2)];
        UIImage * img= [UIImage imageNamed:@"nav_bg.png"];
        img = [img stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        
        [NavBar setBackgroundImage:img forBarMetrics:(UIBarMetricsDefault)];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = NavBar.frame;
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
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *role = [user objectForKey:kChooese_ChineseOrForeigner];
    if([role isEqualToString:@"Chinese"])
        return CHINESEUSER;
    else
        return FOREINERUSER;
}

-(BOOL)CheckPaid
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *payTime = [user objectForKey:@"payTime"];
    if(payTime)
        return YES;
    else
        return NO;
}
@end
