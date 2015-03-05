旧版本,使用协议/代理

## 第一步:

在`MJRefresh_old_delgate/demo/zxWaterFallFlow/ZXViewController.m`中引入代理:

~~~objectivec
@interface ZXViewController ()<ZXWaterflowViewDataSource,ZXWaterflowViewDelegate,MJRefreshBaseViewDelegate>
~~~

## 第二步:

声明两个私有实例变量,
~~~objectivec
 MJRefreshHeaderView *_headerView;
 MJRefreshFooterView *_footerView;
~~~
 
## 第三步:  

将头视图和尾部视图添加到滚动视图上:


~~~objectivec
_headerView = [MJRefreshHeaderView header];
_headerView.scrollView = _waterflowView;
_headerView.delegate = self;
    
_footerView = [MJRefreshFooterView footer];
_footerView.scrollView = _waterflowView;
_footerView.delegate = self;
~~~

## 第四步:

实现上拉,下拉的回调方法:

更新数据源,重新绘制UI(主线程),移除刷新视图.

~~~objectivec
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(refreshView == _headerView)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray *newShop=[ZXShop objectArrayWithFilename:@"shopData.plist"];
            [self.shops insertObjects:newShop atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShop.count)]];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_waterflowView reloadData];
            [_headerView endRefreshing];
        });
    }
    if(refreshView == _footerView)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            NSArray *newShop=[ZXShop objectArrayWithFilename:@"shopData2.plist"];
            [self.shops addObjectsFromArray:newShop];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_waterflowView reloadData];
            [_footerView endRefreshing];
        });
    }
}
~~~
