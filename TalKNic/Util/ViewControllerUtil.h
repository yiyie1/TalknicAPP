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
-(NSString*)CheckRole;
-(BOOL)CheckPaid;
-(UINavigationBar* )ConfigNavigationBar:(NSString*)titleStr NavController: (UINavigationController *)NavController NavBar: (UINavigationBar*)NavBar;
@end
