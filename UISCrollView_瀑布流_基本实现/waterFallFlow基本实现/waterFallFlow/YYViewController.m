
#import "YYViewController.h"
#import "YYWaterflowView.h"
#import "YYWaterflowViewCell.h"

@interface YYViewController ()<YYWaterflowViewDelegate,YYWaterflowViewDataSource>

@end

@implementation YYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    YYWaterflowView *waterflow=[[YYWaterflowView alloc]init];
    waterflow.frame=self.view.bounds;
    waterflow.delegate=self;
    waterflow.dadaSource=self;
    [self.view addSubview:waterflow];
    
    //刷新数据
    [waterflow reloadData];
}

#pragma mark-数据源方法
-(NSUInteger)numberOfCellsInWaterflowView:(YYWaterflowView *)waterflowView
{
    return 100;
}
-(NSUInteger)numberOfColumnsInWaterflowView:(YYWaterflowView *)waterflowView
{
    return 3;
}
-(YYWaterflowViewCell *)waterflowView:(YYWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index
{
    YYWaterflowViewCell *cell=[[YYWaterflowViewCell alloc]init];
    //给cell设置一个随机色
    cell.backgroundColor=[UIColor redColor];
    return cell;
}


#pragma mark-代理方法
-(CGFloat)waterflowView:(YYWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index
{
    switch (index%3) {
        case 0:return 90;
        case 1:return 110;
        case 2:return 80;
        default:return 120;
    }
}
-(CGFloat)waterflowView:(YYWaterflowView *)waterflowView marginForType:(YYWaterflowViewMarginType)type
{
    switch (type) {
        case YYWaterflowViewMarginTypeTop:
        case YYWaterflowViewMarginTypeBottom:
        case YYWaterflowViewMarginTypeLeft:
        case YYWaterflowViewMarginTypeRight:
            return 10;
        case YYWaterflowViewMarginTypeColumn:
        case YYWaterflowViewMarginTypeRow:
            return 5;
    }
}
-(void)waterflowView:(YYWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"点击了%d的cell",index);
}
@end