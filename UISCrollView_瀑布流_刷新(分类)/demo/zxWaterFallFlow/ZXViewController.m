//
//  ZXViewController.m
//  zxWaterFallFlow
//
//  Created by zx on 15/2/17.
//  Copyright (c) 2015年 zx. All rights reserved.
//

#import "ZXViewController.h"

/*==========自定义的瀑布流===========*/
#import "ZXWaterflowView.h"
#import "ZXWaterflowViewCell.h"

/*==========自定义cell/模型===========*/
#import "ZXShop.h"
#import "ZXShopCell.h"

/*==========刷新数据===========*/
#import "MJRefresh.h"

#import "UIColor+ZXRandomColor.h"

@interface ZXViewController ()<ZXWaterflowViewDataSource,ZXWaterflowViewDelegate>
@property (nonatomic,strong)  NSMutableArray    *shops;
@end

@implementation ZXViewController
{
    
    ZXWaterflowView *_waterflowView;
}

#pragma mark lazy load
-(NSMutableArray *)shops{
    if (nil == _shops) {
        _shops = [[NSMutableArray alloc]init];
    }
    return _shops;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建瀑布流,加载数据源,刷新数据
    [self createWaterflowView];
    self.shops= [ZXShop objectArrayWithFilename:@"shopData.plist"];
    [_waterflowView reloadData];
}

-(void)createWaterflowView{
    
    _waterflowView = [[ZXWaterflowView alloc]init];
    _waterflowView.frame = self.view.bounds;
    _waterflowView.delegate = self;
    _waterflowView.dataSource = self;
    [self.view addSubview:_waterflowView];
    
    [_waterflowView addHeaderWithTarget:self action:@selector(loadNewShops)];
    [_waterflowView addFooterWithTarget:self action:@selector(loadMoreShops)];
}

/**
 *  上拉刷新时调用: 更新数据源(替换已有数据),重新绘制,结束刷新.
 */
-(void)loadNewShops{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *newShop=[ZXShop objectArrayWithFilename:@"shopData.plist"];
        [self.shops insertObjects:newShop atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShop.count)]];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_waterflowView reloadData];
        [_waterflowView  headerEndRefreshing];
    });
}

/**
 *  下拉刷新时调用: 更新数据源(追加新数据),重新绘制,结束刷新.
 */
-(void)loadMoreShops{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *newShop=[ZXShop objectArrayWithFilename:@"shopData2.plist"];
        [self.shops addObjectsFromArray:newShop];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_waterflowView reloadData];
        [_waterflowView footerEndRefreshing];
    });
}

#pragma mark 必须实现-->数据源方法

-(NSUInteger)numberOfCellsInWaterflowView:(ZXWaterflowView *)waterflowView{
    return self.shops.count;
}

-(ZXWaterflowViewCell *)waterflowView:(ZXWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index{
    
    ZXShopCell *cell=[ZXShopCell cellWithWaterflowView:waterflowView];
    cell.shop=self.shops[index];
    return cell;
}

#pragma mark 可选方法--->根据需要设置

/**
 *  可以设置的有cell的列数,cell的间距,cell的高度,选中cell执行的方法
 */

-(NSUInteger)numberOfColumnsInWaterflowView:(ZXWaterflowView *)waterflowView{
    return 3;
}

-(CGFloat)waterflowView:(ZXWaterflowView *)waterflowView marginForType:(ZXWaterFlowViewMarginType)type{
    switch (type) {
        case ZXWaterFlowViewMarginTypeTop:
        case ZXWaterFlowViewMarginTypeBottom:
        case ZXWaterFlowViewMarginTypeLeft:
        case ZXWaterFlowViewMarginTypeRight:
            return 1.0f;
            break;
            
        case ZXWaterFlowViewMarginTypeColumn:
        case ZXWaterFlowViewMarginTypeRow:
            return 1.0f;
            break;
    }
    return 2;
}

/**
 *  这个方法应该是对于自定义的cell最为有用的方法,确定每个cell的高度
 */

-(CGFloat)waterflowView:(ZXWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index{
    ZXShop *shop = (ZXShop *)[self.shops objectAtIndex:index];
    return shop.h;
}

/**
 *  cell点击事件
 *
 *  @param waterflowView 当前瀑布流对象
 *  @param index         cell标志索引
 */
-(void)waterflowView:(ZXWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index{
    NSLog(@"%s [LINE:%d] clicked:%lu cell.", __func__, __LINE__,index);
}

@end
