//
//  ZXShopCell.m
//  zxWaterFallFlow
//
//  Created by zx on 15/2/25.
//  Copyright (c) 2015年 zx. All rights reserved.
//

#import "ZXShopCell.h"
#import "ZXWaterflowView.h"
#import "ZXWaterflowViewCell.h"
#import "ZXShop.h"
#import "UIKit+AFNetworking.h"

@interface ZXShopCell()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *priceLabel;

@end

@implementation ZXShopCell


//这里创建控件
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView=[[UIImageView alloc]init];
		[self addSubview:imageView];
		self.imageView=imageView;
        
		UILabel *priceLabel=[[UILabel alloc]init];
		priceLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
		priceLabel.textAlignment=NSTextAlignmentCenter;
		priceLabel.textColor=[UIColor whiteColor];
        
		[self addSubview:priceLabel];
        
		self.priceLabel=priceLabel;
    }
    return self;
}

+(instancetype)cellWithWaterflowView:(ZXWaterflowView *)waterflowView{
    static NSString *identifier = @"cell_identifier";
    ZXShopCell *cell = [waterflowView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[ZXShopCell alloc]init];
        cell.identifier = identifier;
    }
    return cell;
}

-(void)setShop:(ZXShop *)shop{
    _shop = shop;
    self.priceLabel.text = shop.price;
    [self.imageView setImageWithURL:[NSURL URLWithString:shop.img]
                   placeholderImage:[UIImage imageNamed:@"loading"]];
}

//这里给控件赋值
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    CGFloat priceX = 0;
    CGFloat priceH = 25;
    CGFloat priceY = self.bounds.size.height - priceH;
    CGFloat priceW = self.bounds.size.width;
    
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
}

@end
