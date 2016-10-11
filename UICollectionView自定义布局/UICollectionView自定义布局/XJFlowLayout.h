//
//  XJFlowLayout.h
//  UICollectionView自定义布局
//
//  Created by Dear on 16/10/11.
//  Copyright © 2016年 Dear. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJFlowLayout;

@protocol XJWaterflowLayouDelegate <NSObject>

// 必须实现的方法
@required
// 根据item的宽和index，计算高
-(CGFloat)waterflowLayout:(XJFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

// 可选
@optional
/** 总共显示多少列 */
- (CGFloat)columnCountInWaterFlowLayout:(XJFlowLayout *)waterFlowLayout;
/** 每列之间的间距 */
- (CGFloat)columnMarginInWaterFlowLayout:(XJFlowLayout *)waterFlowLayout;
/** 每一行之间的间距 */
- (CGFloat)rowMarginInWaterFlowLayout:(XJFlowLayout *)waterFlowLayout;
/** collectionView的内边距 */
- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(XJFlowLayout *)waterFlowLayout;
@end

@interface XJFlowLayout : UICollectionViewFlowLayout
/**代理*/
@property (nonatomic, weak) id<XJWaterflowLayouDelegate> delegate;
@end
