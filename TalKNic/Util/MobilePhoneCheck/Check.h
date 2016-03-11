//
//  Check.h
//  
//
//  Created by Talknic on 15/12/18.
//  Copyright (c) 2015年 TalknicD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Check : NSObject
- (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL)validateEmail:(NSString *)email;
- (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;
@end
