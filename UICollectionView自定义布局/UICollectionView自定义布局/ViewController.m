//
//  ViewController.m
//  UICollectionView自定义布局
//
//  Created by Dear on 16/10/11.
//  Copyright © 2016年 Dear. All rights reserved.
//

#import "ViewController.h"
#import "XJFlowLayout.h"
#import "XJShopCell.h"
#import "MJExtension.h"
#import "XJShop.h"
static NSString *ID = @"cell";

@interface ViewController ()<XJWaterflowLayouDelegate>
/**<#注释#>*/
@property (nonatomic, strong) NSMutableArray *shopArray;
@end

@implementation ViewController

-(instancetype)init{
    
    XJFlowLayout *flowLayout = [[XJFlowLayout alloc] init];
    flowLayout.delegate = self;
    
    return [super initWithCollectionViewLayout:flowLayout];
}

-(NSMutableArray *)shopArray{
    
    if (!_shopArray) {
        
        _shopArray = [NSMutableArray array];
        
        NSArray *shop = [XJShop objectArrayWithFilename:@"shops.plist"];
        
        [_shopArray addObjectsFromArray:shop];
    }
    return _shopArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor= [UIColor whiteColor];
    
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"XJShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.shopArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XJShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.shops = self.shopArray[indexPath.item];
    
    return cell;
}

#pragma mark - XJWaterflowLayouDelegate
-(CGFloat)waterflowLayout:(XJFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    
    XJShop *shop = self.shopArray[index];
    CGFloat itemHeight = itemWidth * shop.h / shop.w;
    return itemHeight;
}

@end
