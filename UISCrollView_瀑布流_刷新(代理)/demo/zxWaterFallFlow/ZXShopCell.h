//
//  ZXShopCell.h
//  zxWaterFallFlow
//
//  Created by zx on 15/2/25.
//  Copyright (c) 2015年 zx. All rights reserved.
//

#import "ZXWaterflowViewCell.h"

@class ZXWaterflowView,ZXShop;

@interface ZXShopCell : ZXWaterflowViewCell

@property (nonatomic,strong) ZXShop    *shop;

+(instancetype)cellWithWaterflowView:(ZXWaterflowView *)waterflowView;

@end
