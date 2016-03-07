//
//  Created by ldy on 15/10/22.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaView : UIView
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *fristBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

+ (instancetype)createInstance;
@end
