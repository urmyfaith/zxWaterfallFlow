
##API设计

1.电商应用要展示商品信息通常是通过瀑布流的方式，因为每个商品的展示图片，长度和商都都不太一样。

如果不用瀑布流的话，展示这样的格子数据，还有一种办法是使用九宫格。

但利用九宫格有一个缺点，那就是每个格子的宽高是一样的，如果一定要使用九宫格来展示，那么展示的商品图片可能会变形。

为了保证商品图片能够按照原来的宽高比进行展示，一般采用的是瀑布流的方式。

2.瀑布流的特点：
由很多的格子组成，但是每个格子的宽度和高速都是不确定的，是在动态改变的，就像瀑布一样，是一条线一条线的。
说明:使用tableView不能实现瀑布流式的布局，因为tableView是以行为单位的，它要求每行（cell）的高度在内部是一致的。
本系列文章介绍了如何自定义一个瀑布流控件来展示商品信息，本文介绍自定义瀑布流的接口设计。
 
3.自定义瀑布流控件的实现思路
　　参考UITbaleView控件的设计。
　　
（1）设置数据源（强制的，可选的）
1)告诉有多少个数据（cell）
2)每一个索引对应的cell
3)告诉显示多少列

（2）设置代理
代理方法都是可选的。
1）设置第index位置对应的高度
2）监听选中了第index的cell（控件)
3）设计返回的间距那么

> 参考资料

- http://www.cnblogs.com/wendingding/p/3873937.html#commentform


## cell的复用:

当滚动的时候，向数据源要cell。

　　当UIScrollView滚动的时候会调用layoutSubviews在tableView中也是一样的，因此，可以用这个方法来监听scrollView的滚动，可以在在这个地方向数据源索要对应位置的cell（frame在屏幕上的cell）。

　　当scrollView在屏幕上滚动的时候，离开屏幕的cell应该放到缓存池中去，询问即将（已经）进入到屏幕的cell，对于还没有进入到屏幕的cell不作处理。
判断cell有没有在屏幕上？
　　cell的最大的Y值>contentoffset的y值，并且小于contentoffset的y值+UIView的高度

参考资料:
 - http://www.cnblogs.com/wendingding/p/3876444.html


## 遍历字典

方式一(不需要key)

~~~objectivec
   [self.reusableCells enumerateObjectsUsingBlock:^(ZXWaterflowViewCell *cell, BOOL *stop)
    {
        if ([cell.identifier isEqualToString:identifier]) {
            resuableCell = cell;
            *stop = YES;
        }
    }];
~~~

方式二,需要字典的key值

~~~objectivec
    [self.displingCells enumerateKeysAndObjectsUsingBlock:^(id key, ZXWaterflowViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectedIndex = key;
            *stop = YES;
        }
    }];
~~~

> 参考资料:

 - http://www.cnblogs.com/wendingding/p/3877601.html

## 图片按照比例缩放

真实的宽度/真实的高度 = cell的宽度/ cell的高度

