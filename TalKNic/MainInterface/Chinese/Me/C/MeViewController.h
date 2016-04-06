//
//  MeViewController.h
//  TalkNic
//
//  Created by Talknic on 15/10/20.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *role;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *occupation;
@property (nonatomic,copy)NSString *location;
@property (nonatomic,copy)NSString *bio;
@end
