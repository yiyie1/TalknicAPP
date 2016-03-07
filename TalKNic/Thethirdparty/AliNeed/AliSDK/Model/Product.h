//
//  Product.h
//  AliPayDemo
//
//  Created by Ibokan on 15/12/12.
//  Copyright © 2015年 Baiwushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
/**
 *商品标签
 */
@property (nonatomic, copy) NSString *subject;
/**
 *商品描述
 */
@property (nonatomic, copy) NSString *body;
/**
 *商品价格
 */
@property (nonatomic, assign) float price;
/**
 *商品ID
 */
@property (nonatomic, copy) NSString *orderId;

@end
