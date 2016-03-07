//
//  ForeignerMeViewController.h
//  TalKNic
//
//  Created by ldy on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForeignerMeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *FsearchBarView;
@property (weak, nonatomic) IBOutlet UIImageView *fimageview;
@property (weak, nonatomic) IBOutlet UISearchBar *fsearchBar;
@property (weak, nonatomic) IBOutlet UITableView *fsearchTable;
@property (nonatomic,copy)NSString *uid;
@end
