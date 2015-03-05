//
//  UIColor+ZXRandomColor.m
//  zxWaterFallFlow
//
//  Created by zx on 15/2/17.
//  Copyright (c) 2015年 zx. All rights reserved.
//

#import "UIColor+ZXRandomColor.h"

@implementation UIColor (ZXRandomColor)

/**
 *  分类方法:随机颜色
 *
 *  @return 随机颜色
 */
+(UIColor *)zxRandomColor{
    
    CGFloat red     = arc4random()%255;
    CGFloat green   = arc4random()%255;
    CGFloat blue    = arc4random()%255;
    UIColor *randomColor = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return randomColor;
}
@end
