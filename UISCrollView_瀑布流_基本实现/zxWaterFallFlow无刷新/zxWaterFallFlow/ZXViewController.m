//
//  ZXViewController.m
//  zxWaterFallFlow
//
//  Created by zx on 15/2/17.
//  Copyright (c) 2015年 zx. All rights reserved.
//

#import "ZXViewController.h"
#import "ZXWaterflowView.h"
#import "ZXWaterflowViewCell.h"
#import "UIColor+ZXRandomColor.h"

@interface ZXViewController ()<ZXWaterflowViewDataSource,ZXWaterflowViewDelegate>

@end

@implementation ZXViewController
{
    ZXWaterflowView *_waterflowView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createWaterflowView];
    [_waterflowView reloadData];
}

-(void)createWaterflowView{
    _waterflowView = [[ZXWaterflowView alloc]init];
    _waterflowView.frame = self.view.bounds;
    _waterflowView.delegate = self;
    _waterflowView.dataSource = self;
    [self.view addSubview:_waterflowView];
}


#pragma mark 必须实现-->数据源方法

-(NSUInteger)numberOfCellsInWaterflowView:(ZXWaterflowView *)waterflowView{
    return 20;
}

-(ZXWaterflowViewCell *)waterflowView:(ZXWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index{
//没有复用cell/复用cell
#if 0
    ZXWaterflowViewCell *cell = [[ZXWaterflowViewCell alloc]init];
    cell.backgroundColor = [UIColor zxRandomColor];
    NSLog(@"%s [LINE:%d] %d---%p", __func__, __LINE__,index,cell);
    return cell;
#else
    static NSString *identifier = @"cell";
    ZXWaterflowViewCell *cell = [waterflowView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[ZXWaterflowViewCell alloc]init];
        cell.identifier = identifier;
        cell.backgroundColor = [UIColor zxRandomColor];
        
        UILabel *label = [[UILabel alloc]init];
        label.tag = 10;
        label.frame = CGRectMake(10,10,20,20);
        [cell addSubview:label];
    }
    
    UILabel *label  = (UILabel *)[cell viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%d",index];
    
    NSLog(@"%s [LINE:%d] %d---%p", __func__, __LINE__,index,cell);
    return cell;
#endif
    
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
    switch (index%3) {

        case 0:return 90.0f;
        case 1:return 110.0f;
        case 2:return 80.0f;
        default: return 120.0f;
    }
}

/**
 *  cell点击事件
 *
 *  @param waterflowView 当前瀑布流对象
 *  @param index         cell标志索引
 */
-(void)waterflowView:(ZXWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index{
    NSLog(@"%s [LINE:%d] clicked:%d cell.", __func__, __LINE__,index);
}

@end
