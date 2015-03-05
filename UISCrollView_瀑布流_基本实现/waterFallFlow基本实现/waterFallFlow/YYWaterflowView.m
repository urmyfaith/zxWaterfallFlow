
#import "YYWaterflowView.h"
#import "YYWaterflowViewCell.h"
#define YYWaterflowViewDefaultNumberOfClunms  3
#define YYWaterflowViewDefaultCellH  100
#define YYWaterflowViewDefaultMargin 10

@interface YYWaterflowView()
@property(nonatomic,strong)NSMutableArray *cellFrames;
@end

@implementation YYWaterflowView

#pragma mark-懒加载
-(NSMutableArray *)cellFrames
{
    if (_cellFrames==nil) {
        _cellFrames=[NSMutableArray array];
    }
    return _cellFrames;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/**
 *  刷新数据
 *  1.计算每个cell的frame
 */
-(void)reloadData
{
    //cell的总数是多少
    int numberOfCells=[self.dadaSource numberOfCellsInWaterflowView:self];
    
    //cell的列数
    int numberOfColumns=[self numberOfColumns];
    
    //间距
    CGFloat leftM=[self marginForType:YYWaterflowViewMarginTypeLeft];
    CGFloat rightM=[self marginForType:YYWaterflowViewMarginTypeRight];
    CGFloat columnM=[self marginForType:YYWaterflowViewMarginTypeColumn];
    CGFloat topM=[self marginForType:YYWaterflowViewMarginTypeTop];
    CGFloat rowM=[self marginForType:YYWaterflowViewMarginTypeRow];
    CGFloat bottomM=[self marginForType:YYWaterflowViewMarginTypeBottom];
    
    //（1）cell的宽度
    //cell的宽度=（整个view的宽度-左边的间距-右边的间距-（列数-1）X每列之间的间距）/总列数
    CGFloat cellW=(self.frame.size.width-leftM-rightM-(numberOfColumns-1)*columnM)/numberOfColumns;
    
    
    
    //用一个C语言的数组来存放所有列的最大的Y值
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i=0; i<numberOfColumns; i++) {
        //初始化数组的数值全部为0
        maxYOfColumns[i]=0.0;
    }
    
    
    //计算每个cell的fram
    for (int i=0; i<numberOfCells; i++) {
        
        //(2)cell的高度
        //询问代理i位置的高度
        CGFloat cellH=[self heightAtIndex:i];
        
        //cell处在第几列（最短的一列）
        NSUInteger cellAtColumn=0;
        
        //cell所处那列的最大的Y值（当前最短的那一列的最大的Y值）
        //默认设置最短的一列为第一列（优化性能）
        CGFloat maxYOfCellAtColumn=maxYOfColumns[cellAtColumn];
        
        //求出最短的那一列
        for (int j=0; j<numberOfColumns; j++) {
            if (maxYOfColumns[j]<maxYOfCellAtColumn) {
                cellAtColumn=j;
                maxYOfCellAtColumn=maxYOfColumns[j];
            }
        }
        
        //（3）cell的位置（X,Y）
        //cell的X=左边的间距+列号*（cell的宽度+每列之间的间距）
        CGFloat cellX=leftM+cellAtColumn*(cellW +columnM);
        //cell的Y，先设定为0
        CGFloat cellY=0;
        if (maxYOfCellAtColumn==0.0) {//首行
            cellY=topM;
        }else
        {
            cellY=maxYOfCellAtColumn+rowM;
        }
        
        //（4）设置cell的frame并添加到数组中
        CGRect cellFrame=CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        //更新最短那一列的最大的Y值
        maxYOfColumns[cellAtColumn]=CGRectGetMaxY(cellFrame);
        
        //显示cell
        YYWaterflowViewCell *cell=[self.dadaSource waterflowView:self cellAtIndex:i];
        cell.frame=cellFrame;
        [self addSubview:cell];
    }
    
    //设置contentSize
    CGFloat contentH=maxYOfColumns[0];
    for (int i=1; i<numberOfColumns; i++) {
        if (maxYOfColumns[i]>contentH) {
            contentH=maxYOfColumns[i];
        }
    }
    contentH += bottomM;
    self.contentSize=CGSizeMake(0, contentH);
}

#pragma mark-私有方法
-(CGFloat)marginForType:(YYWaterflowViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        return  [self.delegate waterflowView:self marginForType:type];
    }else
    {
        return YYWaterflowViewDefaultMargin;
    }
}

-(NSUInteger)numberOfColumns
{
    if ([self.dadaSource respondsToSelector:@selector(numberOfColumnsInWaterflowView:)]) {
        return [self.dadaSource numberOfColumnsInWaterflowView:self];
    }else
    {
        return  YYWaterflowViewDefaultNumberOfClunms;
    }
}

-(CGFloat)heightAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
        return [self.delegate waterflowView:self heightAtIndex:index];
    }else
    {
        return YYWaterflowViewDefaultCellH;
    }
}
@end