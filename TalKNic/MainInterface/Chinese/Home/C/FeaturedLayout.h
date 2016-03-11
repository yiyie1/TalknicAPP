//
//  FeaturedLayout.h
//  TalkNic
//
//  Created by Talknic on 15/10/29.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeaturedLayout;
@protocol FeaturedLayoutDelegate <NSObject>

-(CGFloat)featuredLayout:(FeaturedLayout *)featuredLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end
@interface FeaturedLayout : UICollectionViewLayout
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 */
@property (nonatomic, assign) int columnsCount;

@property (nonatomic, weak) id<FeaturedLayoutDelegate> delegate;
@end
