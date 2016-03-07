//
//  YGPayByAliTool.m
//  Yunyige
//
//  Created by zlyunduan on 16/1/5.
//  Copyright (c) 2016年 ZLyunduan. All rights reserved.
//

#import "YGPayByAliTool.h"
#import "Product.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation YGPayByAliTool

+ (void)payByAliWithSubjects:(NSString *)subjects body:(NSString *)body price:(float)price orderId:(NSString *)orderId partner:(NSString *)partner seller:(NSString *)seller privateKey:(NSString *)privateKey success:(void(^)(NSDictionary *))success{
    
    /*
     *获取prodcut实例并初始化订单信息
     */
    Product *product = [self generateProductWithSubjects:subjects body:body price:price orderId:orderId];
    /**
     *  调用pay方法去付款
     */
    [self payByAliWithProduct:product partner:partner seller:seller privateKey:privateKey success:success];
    
}

+ (Product *)generateProductWithSubjects:(NSString *)subjects body:(NSString *)body price:(float)price orderId:(NSString *)orderId{
    
    Product *product = [[Product alloc] init];
    product.subject = subjects;
    product.body = body;
    product.price = price;
    product.orderId = orderId;
    return product;
}

+ (void)payByAliWithProduct:(Product *)product partner:(NSString *)partner seller:(NSString *)seller privateKey:(NSString *)privateKey success:(void(^)(NSDictionary *))success{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */

    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertPrompt
                                                        message:kAlertLess
                                                       delegate:self
                                              cancelButtonTitle:kAlertSure
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = product.orderId; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.baidu.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdktalknic";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            // 支付后调用的方法
            NSLog(@"reslut = %@",resultDic);
            // 调出外界
            success(resultDic);
            
        }];
        
    }

    
}

//+ (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand(time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}


@end
