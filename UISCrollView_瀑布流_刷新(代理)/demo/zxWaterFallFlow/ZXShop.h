//
//  ZXShop.h
//  zxWaterFallFlow
//
//  Created by zx on 15/2/25.
//  Copyright (c) 2015年 zx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXShop : NSObject

@property (nonatomic,assign)           CGFloat     h;
@property (nonatomic,assign)           CGFloat     w;
@property (nonatomic,copy)           NSString     *img;
@property (nonatomic,copy)           NSString     *price;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)shopWithDic:(NSDictionary *)dic;

+(NSMutableArray *)objectArrayWithFilename:(NSString *)filename;

@end
