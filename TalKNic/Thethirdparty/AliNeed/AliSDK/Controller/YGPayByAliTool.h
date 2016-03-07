//
//  YGPayByAliTool.h
//  Yunyige
//
//  Created by zlyunduan on 16/1/5.
//  Copyright (c) 2016年 ZLyunduan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGPayByAliTool : NSObject
/**
 *  支付下单
 *
 *  @param subjects   商品标签
 *  @param body       商品描述
 *  @param price      商品价格
 *  @param orderId    商品ID
 *  @param partner    商户partner   partner可于seller相同
 *  @param seller     商户seller
 *  @param privateKey 商户私钥
 *  @param success    支付完成回调
 */
+ (void)payByAliWithSubjects:(NSString *)subjects
                        body:(NSString *)body
                       price:(float)price
                     orderId:(NSString *)orderId
                     partner:(NSString *)partner
                      seller:(NSString *)seller
                  privateKey:(NSString *)privateKey
                     success:(void(^)(NSDictionary *info))success;

@end
