
#import <UIKit/UIKit.h>

//使用瀑布流形式展示内容的控件
typedef enum {
    YYWaterflowViewMarginTypeTop,
    YYWaterflowViewMarginTypeBottom,
    YYWaterflowViewMarginTypeLeft,
    YYWaterflowViewMarginTypeRight,
    YYWaterflowViewMarginTypeColumn,//每一列
    YYWaterflowViewMarginTypeRow,//每一行
    
}YYWaterflowViewMarginType;

@class YYWaterflowViewCell,YYWaterflowView;

/**
 *  1.数据源方法
 */
@protocol YYWaterflowViewDataSource <NSObject>
//要求强制实现
@required
/**
 * （1）一共有多少个数据
 */
-(NSUInteger)numberOfCellsInWaterflowView:(YYWaterflowView *)waterflowView;
/**
 *  (2)返回index位置对应的cell
 */
-(YYWaterflowViewCell *)waterflowView:(YYWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index;

//不要求强制实现
@optional
/**
 *  (3)一共有多少列
 */
-(NSUInteger)numberOfColumnsInWaterflowView:(YYWaterflowView *)waterflowView;

@end


/**
 *  2.代理方法
 */
@protocol YYWaterflowViewDelegate <UIScrollViewDelegate>
//不要求强制实现
@optional
/**
 *  (1)第index位置cell对应的高度
 */
-(CGFloat)waterflowView:(YYWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index;
/**
 *  (2)选中第index位置的cell
 */
-(void)waterflowView:(YYWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index;
/**
 *  (3)返回间距
 */
-(CGFloat)waterflowView:(YYWaterflowView *)waterflowView marginForType:(YYWaterflowViewMarginType)type;
@end


/**
 *  3.瀑布流控件
 */
@interface YYWaterflowView : UIScrollView
/**
 *  (1)数据源
 */
@property(nonatomic,weak)id<YYWaterflowViewDataSource> dadaSource;
/**
 *  (2)代理
 */
@property(nonatomic,weak)id<YYWaterflowViewDelegate> delegate;

/**
 *  刷新数据
 */
-(void)reloadData;
@end