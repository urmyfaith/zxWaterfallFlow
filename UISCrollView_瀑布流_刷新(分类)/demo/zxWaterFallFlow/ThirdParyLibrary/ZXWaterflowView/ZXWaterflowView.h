//
//  ZXWaterflowView.h
//  zxWaterFallFlow
//
//  Created by zx on 15/2/17.
//  Copyright (c) 2015年 zx. All rights reserved.
//

/*
 
参考UITableView控件的设计。
 
 （1）设置数据源（强制的，可选的）
 1)告诉有多少个数据（cell）
 2)每一个索引对应的cell
 3)告诉显示多少列

 （2）设置代理
 代理方法都是可选的。
 1）设置第index位置对应的高度
 2）监听选中了第index的cell（控件)
 3）设计返回的间距那么
 */


#import <UIKit/UIKit.h>

typedef enum {

    ZXWaterFlowViewMarginTypeTop,
    ZXWaterFlowViewMarginTypeBottom,
    ZXWaterFlowViewMarginTypeLeft,
    ZXWaterFlowViewMarginTypeRight,
    ZXWaterFlowViewMarginTypeColumn,
    ZXWaterFlowViewMarginTypeRow
}ZXWaterFlowViewMarginType;


@class ZXWaterflowView,ZXWaterflowViewCell;


#pragma mark 数据源协议
/**
 *  数据源方法
 */
@protocol ZXWaterflowViewDataSource <NSObject>

@required

/**
 *  cell的总数目
 *
 *  @param waterflowView 当前瀑布流对象
 *
 *  @return cell的数目
 */
-(NSUInteger )numberOfCellsInWaterflowView:(ZXWaterflowView *)waterflowView;

/**
 *  每个cell
 *
 *  @param waterflowView 当前瀑布流对象
 *  @param index         标记cell的位置
 *
 *  @return 每个cell对象
 */
-(ZXWaterflowViewCell *)waterflowView:(ZXWaterflowView *)waterflowView cellAtIndex:(NSUInteger )index;

@optional
/**
 *  有多少列
 *
 *  @param waterflowView 当前瀑布流对象
 *
 *  @return 多少列
 */
-(NSUInteger)numberOfColumnsInWaterflowView:(ZXWaterflowView *)waterflowView;
@end


#pragma mark 外观相关的协议方法
/**
 *  外观相关的协议方法
 * 注意:此协议继承了协议.
 */
@protocol ZXWaterflowViewDelegate <UIScrollViewDelegate>

@optional

/**
 *  cell高度
 *
 *  @param waterflowView 当前瀑布流对象
 *  @param index         区分cell标记
 *
 *  @return cell高度
 */
-(CGFloat)waterflowView:(ZXWaterflowView *)waterflowView heightAtIndex:(NSUInteger )index;

/**
 *  选中cell执行方法
 *
 *  @param waterflowView 当前瀑布流对象
 *  @param index         区分cell标记
 */
-(void)waterflowView:(ZXWaterflowView *)waterflowView  didSelectAtIndex:(NSUInteger )index;

/**
 *  cell间距
 *
 *  @param waterflowView 当前瀑布流对象
 *  @param type          间距的类型
 *
 *  @return 间距的长度
 */
-(CGFloat)waterflowView:(ZXWaterflowView *)waterflowView marginForType:(ZXWaterFlowViewMarginType)type;

@end



#pragma mark 瀑布流视图
/**
 *  瀑布流,使用滚动视图来实现
 
 代理1-->数据源
 代理2-->外观控制
 方法--->刷新数据
 */
@interface ZXWaterflowView : UIScrollView

/**
 *  数据源
 */
@property(nonatomic,weak)id<ZXWaterflowViewDataSource> dataSource;

/*
 *  外观控制
 */
@property(nonatomic,weak)id<ZXWaterflowViewDelegate> delegate;

/**
 *  向外部提供cell的宽度
 *
 *  @return cell的宽度
 */
-(CGFloat)cellWidth;

/**
 *  通过外部调用,刷新数据,绘制每个cell
 */
-(void)reloadData;

/**
 *  根据标志符去复用池取cell
 *
 *  @param identifier 标志符
 *
 *  @return 返回复用对象
 */
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


@end
