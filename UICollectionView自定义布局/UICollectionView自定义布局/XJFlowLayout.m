//
//  XJFlowLayout.m
//  UICollectionView自定义布局
//
//  Created by Dear on 16/10/11.
//  Copyright © 2016年 Dear. All rights reserved.
//

#import "XJFlowLayout.h"
/** 默认的列数 */
static const NSInteger XJColumnCount = 3;
/** 每一列之间的间距 */
static const CGFloat XJColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat XJRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets XJEdgeInsets = {10, 10, 10, 10};

@interface XJFlowLayout ()
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;
//这里方法为了简化 数据处理(通过getter方法来实现)
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation XJFlowLayout
/*
 UICollectionViewLayoutAttributes：布局属性
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 注意每一个cell的原点是contentView的左上角，而不是CollectionView的左上角
 */


#pragma mark - 懒加载
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

// 布局的初始化操作
- (void)prepareLayout{
    
    [super prepareLayout];
    
    // 初始化内容的高度为0
    self.contentHeight = 0;
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    // 先初始化 为所有列默认的高度
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    // 开始创建每一个cell对应的布局属性
    // 查看对应的第0组有多少个item
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        // 获取每一个item的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        // 添加到属性数组
        [self.attrsArray addObject:attrs];
    }
}

/*
 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    return self.attrsArray;
}

/**
 * 返回indexPath位置cell对应的布局属性
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *arrts = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // collectionView的宽度
    CGFloat collectViewW = self.collectionView.frame.size.width;
    
    // 设置布局属性frame
    CGFloat cellW = (collectViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat cellH = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:cellW];
    
    // 找出高度最短的那一列
    // 找出来最短的后 就把下一个cell 添加到下面
    // 初始化当前最短的列号
    NSInteger minColumn = 0;
    // 最短列的高度
    CGFloat minColumnH = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        // 获取第i列的高度
        CGFloat columnH = [self.columnHeights[i] doubleValue];
        
        if (minColumnH > columnH) {
            // 赋值
            minColumnH = columnH;
            minColumn = i;
        }
    }
    CGFloat cellX = self.edgeInsets.left + minColumn * (cellW + self.columnMargin);
    CGFloat cellY = minColumnH;
    
    if (cellY != self.edgeInsets.top) {
        cellY += self.rowMargin;
    }
    
    arrts.frame = CGRectMake(cellX, cellY, cellW, cellH);
    
    // 更新最短那列的高度
    self.columnHeights[minColumn] = @(CGRectGetMaxY(arrts.frame));
    
    //记录内容的高度
    CGFloat columnH = [self.columnHeights[minColumn] doubleValue];
    if (self.contentHeight < columnH) {
        self.contentHeight = columnH;
    }
    
    return arrts;
}

/**
 *  contentSize，设置collectionView的滚动范围
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom + 100);
}

#pragma mark - <XJWaterflowLayouDelegate>

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    }else{
        return XJRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFlowLayout:)]) {
        return [self.delegate columnMarginInWaterFlowLayout:self];
    }else{
        return XJColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    }else{
        return XJColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterFlowLayout:self];
    }else{
        return XJEdgeInsets;
    }
}

@end
