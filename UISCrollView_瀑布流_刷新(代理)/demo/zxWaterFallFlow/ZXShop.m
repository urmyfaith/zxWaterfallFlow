//
//  ZXShop.m
//  zxWaterFallFlow
//
//  Created by zx on 15/2/25.
//  Copyright (c) 2015年 zx. All rights reserved.
//

#import "ZXShop.h"

@implementation ZXShop

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(instancetype)shopWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

+(NSMutableArray *)objectArrayWithFilename:(NSString *)filename{
    NSString *path = [[NSBundle mainBundle]pathForResource:filename ofType:nil];
    NSArray *fileContent_array = [[NSArray alloc]initWithContentsOfFile:path];
    
    NSMutableArray *shops_marray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in fileContent_array) {
        [shops_marray addObject:[ZXShop shopWithDic:dic]];
    }
    return shops_marray;
}

/**
  *  KVC的时候,防止给不存在的属性赋值
  *
  *  @param value 值
  *  @param key   键
  */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s [LINE:%d] key=%@", __func__, __LINE__,key);
}

-(NSString *)description{
    static int  i = 0;
    return [NSString stringWithFormat:@"ZXShop %2d: w=%3.f h=%3.f img=%@ price=%@ ",i++,self.w,self.h,self.img,self.price];
}

@end
