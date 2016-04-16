//
//  SYUnlimitedView.h
//  无限轮播工具
//
//  Created by 邵世约 on 16/3/23.
//  Copyright © 2016年 邵世约. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    定时器模式
 */
typedef NS_OPTIONS(NSUInteger, SYCarouselTimerType) {
    SYCarouselStateNone = 0,     //默认状态
    SYCarouselStateHasTimer = 1  //定时轮播状态
};

/*
    cell样式
 */
typedef NS_OPTIONS(NSUInteger, SYCarouselCellType) {
    SYCarouselCellImage = 0,  //显示图片
    SYCarouselCellCustom = 1  //用户自定义cell
};

/*
    分页模式
 */
typedef NS_OPTIONS(NSUInteger, SYCarouselPageType) {
    SYCarouselPageTypeNone = 0,         //默认(没有分页指示器)
    SYCarouselPageTypeHasPage = 1       //用户自定义cell
};

typedef NS_ENUM(NSInteger){
    SYPageControlPalceCenter= 0, //中间
    SYPageControlPalceLeft = 1,  //左下角
    SYPageControlPalceRight = 2  //右下角
}SYPageControlPalceType;

@interface SYCarouselView : UICollectionView

/*  参数皆为可空类型 
 参数1:cell无限轮播显示的数据源(支持格式如下)
 1->网络图片传网络路径:网络获取图片 自动使用SDWebImage进行图片缓存和操作缓存 不用担心缓存和网络请求重复问题
 2->本地图片传本地路径:图片较多的时候传递图片本地路径 或自动使用通过路径加载图片的方法 不会将图片加入本地缓存当中
 3->本地图片名称:图片较少时使用此参数
 
 参数2:cell点击block回调 参数为cell的索引
 */
- (instancetype)initWithImageUrls:(NSArray<NSString *> *)ImageUrls cellDidSelected:(void(^)(NSIndexPath * cellIndexPath))cellDidSelected;

/*  参数皆为可空类型
 参数1:cell无限轮播显示的数据源(支持格式如下)
 1->网络图片传网络路径:网络获取图片 自动使用SDWebImage进行图片缓存和操作缓存 不用担心缓存和网络请求重复问题
 2->本地图片传本地路径:图片较多的时候传递图片本地路径 或自动使用通过路径加载图片的方法 不会将图片加入本地缓存当中
 3->本地图片名称:图片较少时使用此参数
 
 参数2:cell点击block回调 参数为cell的索引
 */
- (instancetype)initWithModelList:(NSArray<NSObject *> *)modelList cellDidSelected:(void(^)(NSIndexPath * cellIndexPath))cellDidSelected;

/*
 数据源
 */
@property (nonatomic,strong) NSArray <NSString *> * imageUrls;

/*
 模型数据源
 */
@property (nonatomic,strong) NSArray * modelList;

/*
    滚动方向
    默认横向滚动
 */
@property (assign,nonatomic) UICollectionViewScrollDirection direction;

/*
    定时器模式
    默认没有定时器
 
 */
@property (assign,nonatomic) SYCarouselTimerType timerType;

/*
 定时器时间间隔
 */
@property (assign,nonatomic) NSTimeInterval timeInterval;

/*
 暂停定时器
 */
-(void)timerPause;

/*
 开启定时器
 */
-(void)timerStart;

/*
    cell样式
 */
@property (assign,nonatomic) SYCarouselCellType cellType;

/*
 注册cell的类型
 默认为SYUnlimitedView
 */
@property (assign,nonatomic) Class cellClass;

/*
    分页模式
 */
@property (assign,nonatomic) SYCarouselPageType pageType;


/*
    分页指示器的当前页图片
 */
@property (strong,nonatomic) UIImage * pageCurrentImage;

/*
    分页指示器的其他页图片
 */
@property (strong,nonatomic) UIImage * pageOtherImage;

/*
    分页指示器当前页颜色
 */
@property (strong,nonatomic) UIColor * pageCurrentColor;

/*
    分页指示器其他页颜色
 */
@property (strong,nonatomic) UIColor * pageOtherColor;

/*
 分页指示器位置
 */
@property (assign,nonatomic) SYPageControlPalceType pagePlace;

@end
