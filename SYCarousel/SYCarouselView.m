//
//  SYUnlimitedView.m
//  无限轮播工具
//
//  Created by 邵世约 on 16/3/23.
//  Copyright © 2016年 邵世约. All rights reserved.
//

#import "SYCarouselView.h"
#import "SYCarouselImageCell.h"
#import "SYLoadImageTool.h"
#import <objc/runtime.h>

static NSString * const cellID = @"SYUnlimitedCell";

@interface SYCarouselView ()<UICollectionViewDataSource,UICollectionViewDelegate>

/*
 流水布局对象
 */

@property (strong,nonatomic,nonnull) UICollectionViewFlowLayout * flowLayout;

/*
 定时器
 */
@property (strong,nonatomic,nullable) NSTimer * timer;


/*
 分页指示器
 */
@property (strong,nonatomic) UIPageControl * pageControl;


/*
    cell点击block回调
 */
@property (nonatomic,strong,nullable) void(^cellDidSelected)(NSIndexPath *cellIndexPath);

@end

static SYPageControlPalceType pagePlaceType;

@implementation SYCarouselView

#pragma mark - get&set方法

-(UICollectionViewFlowLayout *)flowLayout{
    //设置布局属性
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        //默认颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

-(void)setPagePlace:(SYPageControlPalceType)pagePlace{
    _pagePlace = pagePlace;
    pagePlaceType = pagePlace;
}

-(void)setImageUrls:(NSArray<NSString *> *)imageUrls{
    if (imageUrls) {
        _imageUrls = imageUrls;
        [self prepareReloadData];
    }
    
}

-(void)setModelList:(NSArray *)modelList{
    if (modelList) {
        _modelList = modelList;
        [self prepareReloadData];
    }
}

-(void)prepareReloadData{
    //判断是否有设置了定时器样式 如果设置了定时器样式 则开启定时器
    if (self.pageType) {
        self.pageControl.numberOfPages = self.imageUrls.count;
        CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.imageUrls.count];
        CGFloat w = pageSize.width;
        CGFloat h = pageSize.height;
        switch (pagePlaceType) {
            case SYPageControlPalceCenter:
            {
                CGFloat x = self.frame.origin.x + (self.bounds.size.width - w) * 0.5;
                CGFloat y = self.frame.origin.y + (self.bounds.size.height - h);
                self.pageControl.frame = CGRectMake(x, y, w, h);
                [self.superview addSubview:self.pageControl];
            }
                break;
            case SYPageControlPalceLeft:
            {
                CGFloat x = self.frame.origin.x + 5.0;
                CGFloat y = self.frame.origin.y + (self.bounds.size.height - h);
                self.pageControl.frame = CGRectMake(x, y, w, h);
                [self.superview addSubview:self.pageControl];
            }
                break;
            case SYPageControlPalceRight:
            {
                CGFloat x = self.frame.origin.x + (self.bounds.size.width - w - 5.0);
                CGFloat y = self.frame.origin.y + (self.bounds.size.height - h);
                self.pageControl.frame = CGRectMake(x, y, w, h);
                [self.superview addSubview:self.pageControl];
            }
                break;
        }
    }
    
    [self reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    });
    
    if (self.timerType) {
        //开启定时器
        [self timer];
    }
}

#pragma mark - 自定义初始化构造方法
-(instancetype)initWithImageUrls:(NSArray <NSString *> *) ImageUrls cellDidSelected:(void (^)(NSIndexPath *))cellDidSelected{
    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:self.flowLayout]) {
        //设置代理和数据源
        self.dataSource = self;
        self.delegate = self;
        
        //如果设置了block就给block赋值
        if (cellDidSelected) {
            self.cellDidSelected = cellDidSelected;
        }
        
        //设置分页效果
        self.pagingEnabled = YES;
        //隐藏滑动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        //添加kvo监听frame变化
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        //给数据源赋值
        self.imageUrls = ImageUrls;
        
    }
    return self;
}

- (instancetype)initWithModelList:(NSArray<NSObject *> *)modelList cellDidSelected:(void(^)(NSIndexPath * cellIndexPath))cellDidSelected{
    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:self.flowLayout]) {
        //设置代理和数据源
        self.dataSource = self;
        self.delegate = self;
        
        //如果设置了block就给block赋值
        if (cellDidSelected) {
            self.cellDidSelected = cellDidSelected;
        }
        
        //设置分页效果
        self.pagingEnabled = YES;
        //隐藏滑动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        //添加kvo监听frame变化
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        //给数据源赋值
        self.modelList = modelList;
    }
    return self;
}

#pragma mark - kvo

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([object isKindOfClass:[self class]]) {
        //当frame为0 0的时候我们不设置itemSize
        NSValue * value = change[@"new"];
        
        if (value.CGRectValue.size.width != 0 && value.CGRectValue.size.height != 0) {
            self.flowLayout.itemSize = value.CGRectValue.size;
        }
    }
}

//移除kvo
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - dataSource
//如果有数据源直接返回2组执行无限轮播 如果没有则返回0组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.imageUrls || self.modelList) {
        return 3;
    }
    return 0;
}

//返回数据源数组的count
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageUrls) {
        return self.imageUrls.count;
    }
    if (self.modelList) {
        return self.modelList.count;
    }
    return 0;
}

//返回对应的cell
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (self.imageUrls) {
        if (self.cellType == SYCarouselCellImage) {
            SYCarouselImageCell * imageCell = (SYCarouselImageCell *)cell;
            imageCell.imageUrl = self.imageUrls[indexPath.item];
            return imageCell;
        }
    }
    if (self.modelList) {
        if (self.cellType) {
            [self foundModelWithClass:self.cellClass setModelObj:cell parameter:self.modelList[indexPath.item]];
        }
    }
    return cell;
}

#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
-(SEL)creatSetterWithPropertyName: (NSString *) propertyName{
    
    //1.首字母大写
    propertyName = propertyName.capitalizedString;
    
    //2.拼接上set关键字
    propertyName = [NSString stringWithFormat:@"set%@:", propertyName];
    
    //3.返回set方法
    return NSSelectorFromString(propertyName);
}

-(void)foundModelWithClass:(Class)class setModelObj:(id)obj parameter:(id)parameter{

    
    unsigned int count = 0;
    objc_property_t * propertyList = class_copyPropertyList(class, &count);
    
    if (count == 0) {
        return;
    }
    
    //遍历属性数组
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        
        //从属性中获取属性名称
        const char * cName = property_getName(property);
        
        //转换成OC字符串
        NSString * name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        if ([name rangeOfString:@"model"].location != NSNotFound || [name rangeOfString:@"Model"].location != NSNotFound) {
            SEL setSel = [self creatSetterWithPropertyName:name];
            if ([obj respondsToSelector:setSel]) {
                [obj performSelectorOnMainThread:setSel withObject:parameter waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
    
    //释放数组
    free(propertyList);
    
    return;
}


#pragma mark - 即将添加到新的父视图上面
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    if (self.direction) {
        _flowLayout.scrollDirection = self.direction;
    }else{
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    if (self.cellType) {
        [self registerClass:self.cellClass forCellWithReuseIdentifier:cellID];
    }else{
        [self registerClass:[SYCarouselImageCell class] forCellWithReuseIdentifier:cellID];
    }
    
}

#pragma mark - 配置分页指示器
-(void)setPageCurrentImage:(UIImage *)pageCurrentImage{
    _pageCurrentImage = pageCurrentImage;
    [self.pageControl setValue:pageCurrentImage forKey:@"_pageImage"];
}

-(void)setPageOtherImage:(UIImage *)pageOtherImage{
    _pageOtherImage = pageOtherImage;
    [self.pageControl setValue:pageOtherImage forKey:@"_currentPageImage"];
}

-(void)setPageCurrentColor:(UIColor *)pageCurrentColor{
    _pageCurrentColor = pageCurrentColor;
    self.pageControl.currentPageIndicatorTintColor = pageCurrentColor;
}

-(void)setPageOtherColor:(UIColor *)pageOtherColor{
    _pageOtherColor = pageOtherColor;
    self.pageControl.pageIndicatorTintColor = pageOtherColor;
}

-(void)updatePageControlWithIndexPath:(NSIndexPath *)indexPath{
    self.pageControl.currentPage = indexPath.item;
}

/**正在拖拽动作*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //1.根据 scrollView的水平方向的位移
    CGPoint center = scrollView.center;
    //确定cell 的中心点
    center.x += scrollView.contentOffset.x;
    
    //可以判断当前屏幕中显示最多有两个cell  获取cell的frame
    //判断frame 中是否包含了cell的中心点 如果包含了 就获取对应cell的indexPath
    NSArray * indexPaths = [self indexPathsForVisibleItems];
    //遍历indexPath  获取对应 cell
    for (NSIndexPath * indexPath in indexPaths) {
        UICollectionViewCell * cell = [self cellForItemAtIndexPath:indexPath];
        if (CGRectContainsPoint(cell.frame, center)) {
            //就是我们需要找的indexPath
            [self updatePageControlWithIndexPath:indexPath];
        }
    }
}

#pragma mark - 配置定时器
-(NSTimeInterval)timeInterval{
    if (_timeInterval <= 0) {
        return 2;
    }
    return _timeInterval;
}

#pragma mark - 代理方法
//cell选中事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellDidSelected) {
        self.cellDidSelected(indexPath);
    }
}

#pragma -mark  timer懒加载
//重写全局属性timer get方法 当使用get方法时候如果timer为空那么就创建设置一个定时器并座位返回值
-(NSTimer *)timer{
    if (_timer == nil) {
        //第一个参数是定时器调用方法的间距事件
        //第二个参数是给谁添加定时器
        //第三个参数是定时器调用的方法
        //第四个参数是可以传递一个额外的信息(属性) 在调用方法中可以通过 对象.userInfo属性访问传递的信息
        //第五个参数是一个BOOL值 表示是否重复定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];

        // 需要把定时器添加到当前的运行循环中,并设置它为通用模式
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
    
}

//动画跳到下一个cell(下一张图片)
-(void)nextPage{
    //获取当前cell的索引
    NSIndexPath * indexPath = [self indexPathForItemAtPoint:self.contentOffset];
    if ((indexPath.item == self.imageUrls.count - 1 || indexPath.item == self.modelList.count - 1) && indexPath.section != 2) {
        
        NSIndexPath * nextPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section + 1];
        NSLog(@"%@",nextPath);
        //让它自动动画滚动到下一个cell
        [self scrollToItemAtIndexPath:nextPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        return;
    }
    
    NSIndexPath * nextPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
    NSLog(@"%@",nextPath);
    //让它自动动画滚动到下一个cell
    [self scrollToItemAtIndexPath:nextPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

//当动画去滚动每一页 当一页滚动完成之后就会来调用此方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //获取当前滚动到的位置cell的索引
    NSIndexPath * indexPath = [self indexPathForItemAtPoint:scrollView.contentOffset];
    NSLog(@"%@",indexPath);
    //如果是最后一组的最后一个则默认让它回到第0组的最后一个
    if (indexPath.section == 2 && indexPath.item == self.modelList.count - 1){
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.modelList.count - 1 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    if (indexPath.section == 2 && indexPath.item == self.imageUrls.count - 1) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.imageUrls.count - 1 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

//手动去滚动时  当cell完成停下时会来调用此方法(代理方法)
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前滚动到的位置cell的索引
    NSIndexPath * indexPath = [self indexPathForItemAtPoint:scrollView.contentOffset];
    //判断如果滚动到了第零组的第零个cell的时候就不开启动画的让它滚动到第一组的零个
    if (indexPath.section == 0 && indexPath.item == 0) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    //判断如果滚动到了第二组的第最后一个cell的时候就不开启动画的让它滚动到第一组的最后一个cell
    else if (indexPath.section == 2 && indexPath.item == self.imageUrls.count - 1){
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.imageUrls.count - 1 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }else if (indexPath.section == 2 && indexPath.item == self.modelList.count - 1){
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.modelList.count - 1 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}
/** 用户将要开始拖拽是停止定时器(销毁) **/
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self timerPause];
}
/** 用户停止拖拽时再来开启定时器 **/
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self timerStart];
}

/*
 暂停定时器
 */
-(void)timerPause{
    [self.timer invalidate];
    self.timer = nil;
}

/*
 开启定时器
 */
-(void)timerStart{
    [self timer];
}

@end
