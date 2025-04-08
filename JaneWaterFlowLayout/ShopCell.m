//
//  ShopCell.m
//  JaneWaterFlowLayout
//
//  Created by Jane on 2018/1/31.
//  Copyright © 2018 jane. All rights reserved.
//

#import "ShopCell.h"
#import "Shop.h"
#import "UIImageView+WebCache.h"

@interface ShopCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation ShopCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (void)setShop:(Shop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    //self.priceLabel.text = shop.price;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imageView];
        //[self.contentView addSubview:self.priceLabel];
        
    }
    return self;
}

- (void)layoutSubviews 
{
    [super layoutSubviews];

    self.imageView.frame = self.bounds;
    //self.priceLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 30);
}


@end
