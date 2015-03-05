新版本里,上下啦刷新的方法做成了UIScrollView的代理

## 第一步

引入头文件

~~~objectivec
#import "MJRefresh.h"
~~~

## 第二步

设置Target-Action回调

由于使用的是分类方法编写的,所以,不需要代理等.直接在UITableView/UICollectionView/UITableView上添加方法就可以了.
    
~~~objectivec
[_waterflowView addHeaderWithTarget:self action:@selector(loadNewShops)];
[_waterflowView addFooterWithTarget:self action:@selector(loadMoreShops)];
~~~

## 第三步

完成回调方法的编写: 更新数据源,更新UI,移除刷新UI.

~~~objectivec
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
~~~