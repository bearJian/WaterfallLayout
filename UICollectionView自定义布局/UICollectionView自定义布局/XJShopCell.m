//
//  XJShopCell.m
//  UICollectionView自定义布局
//
//  Created by Dear on 16/10/11.
//  Copyright © 2016年 Dear. All rights reserved.
//

#import "XJShopCell.h"
#import "UIImageView+WebCache.h"
#import "XJShop.h"

@interface XJShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation XJShopCell

-(void)setShops:(XJShop *)shops{
    
    _shops = shops;
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:shops.img] placeholderImage:[UIImage imageNamed:@"dear"]];
    
    self.priceLabel.text = shops.price;
}

@end
