//
//  ViewControllerUtil.h
//  TalkNic
//
//  Created by Lingyi on 16/3/15.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewControllerUtil : NSObject
-(UILabel *)SetTitle:(NSString *)titleStr;

-(UINavigationBar* )ConfigNavigationBar:(NSString*)titleStr NavController: (UINavigationController *)NavController NavBar: (UINavigationBar*)NavBar;


//UserDefault
-(NSString*)GetUid;
-(NSString*)CheckRole;
-(BOOL)CheckFinishedInformation;

-(BOOL)IsValidChat:(NSString*) pay_time msg_time: (NSString*) msg_time;
@end
