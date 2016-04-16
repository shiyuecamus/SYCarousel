#SYCarouse(无限轮播)


#**** 使用本工具之前必须在SYCarouseView.h中导入SDWebImage头文件 工作中的网络数据开发请参考---->网络开发使用步骤 ****#


**目前支持功能
1->使用工具自带cell(SYCarouselImageCell) 默认cell里面有一个UIImageView 会自动根据参数类型判断是本地图片还是网络图片

2->使用用户自定义cell 自动完成注册 (#** 如果想通过模型展示数据 只需实现模型数据set方法设置数据即可     ##  模型属性字符串命名必须含有model或Model ## **#)

3->定时器模式 自动轮播

4->分页指示器模式 可自定义分页指示器的当前页和其他页的图片及颜色 可选择分页指示器显示位置(中间,左下角,右下角)

5->支持横竖两个方向的轮播


##只需将图片路径或者图片名称包装成一个数组类型作为参数传递即可

#<基本使用1:创建的时候已经有了数据源>#
!!图片数据源
NSString * url1 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/cff/54bf320ku0ku00000o4h5ss";
NSString * url2 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/e32/f7ff320ku0ku00000o4h5vz";
NSString * url3 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/9ca/0114f20ku0ku00000o4h4vt";

!!实例化轮播视图
SYCarouselView * carouselV = [[SYCarouselView alloc] initWithImageUrls:@[str1,str2,str3] cellDidSelected:nil];

!!设置轮播视图frame
carouselV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.5);

!!添加到作用父视图上
[self.view addSubview:CarouselV];

#<基本使用2:需要从网络请求中来获取数据源,创建的时候没有数据源>#


!!实例化轮播视图
SYCarouselView * carouselV = [[SYCarouselView alloc] initWithImageUrls:nil cellDidSelected:nil];

!!设置轮播视图frame
carouselV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.5);

!!添加到作用父视图上
[self.view addSubview:CarouselV];

!!图片数据源
NSString * url1 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/cff/54bf320ku0ku00000o4h5ss";
NSString * url2 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/e32/f7ff320ku0ku00000o4h5vz";
NSString * url3 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/9ca/0114f20ku0ku00000o4h4vt";

carouselV.imageUrls = @[url1,url2,url3];

#<基本使用3:需要从网络请求中来获取数据源,创建的时候没有数据源>#


!!实例化轮播视图
SYCarouselView * carouselV = [[SYCarouselView alloc] initWithImageUrls:nil cellDidSelected:nil];

!!设置轮播视图frame
carouselV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.5);

!!添加到作用父视图上
[self.view addSubview:CarouselV];


carouselV.modelList = @[模型....];

#** 在cell中重写模型set方法 会制动根据index给model赋值 **#
-(void)setModel:(SYHeaderModel *)model{
_model = model;
_titleLab.text = model.title;
[_imageview sd_setBackgroundImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal];
}

#<图片路径 支持格式:>#
1)本地图片路径
2)本地图片名称
3)网络图片url字符串

//网络图片类型
NSString * url1 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/cff/54bf320ku0ku00000o4h5ss";
NSString * url2 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/e32/f7ff320ku0ku00000o4h5vz";
NSString * url3 = @"http://image.haohaozhu.com/App-imageShow/sq_phone/9ca/0114f20ku0ku00000o4h4vt";

//本地图片路径
NSString * imagePath1 = [[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil];
NSString * imagePath2 = [[NSBundle mainBundle] pathForResource:@"2.png" ofType:nil];
NSString * imagePath3 = [[NSBundle mainBundle] pathForResource:@"3.png" ofType:nil];

//本地图片名称
NSString * imageName1 = @"";
NSString * imageName2 = @"";
NSString * imageName3 = @"";

##创建图片路径或者图片名称或者图片url的途径有很多种 这样写只是为了方便理解 在真正的开发当中我们大多数用的都是动态获取图片的数据源


                                ##网络开发使用步骤
#* 必填 *#
                                创建无限轮播器对象
1->         SYCarouselView * carouselV = [[SYCarouselView alloc] initWithmodelList:nil cellDidSelected:^(NSIndexPath *cellIndexPath) {
NSLog(@"%@",cellIndexPath);
}];
参数:1)数据源数组 可空参数
    2)cell点击block回调
                                
                                设置轮播器的frame
2->         carouselV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.5);
                                

#*可填 (以下属性必须在添加到父视图之前完成设置 且先设置样式再设置配置属性 否则无效) *#

#设置定时器模式 以下属性为可空属性 默认不开启定时器模式
carouselV.timerType = SYCarouselStateHasTimer;
carouselV.timeInterval = 0.5;

#使用自定义样式的cell 以下属性不设置默认为只显示图片的工具类cell
carouselV.cellType = SYCarouselCellCustom;
carouselV.cellClass = [SYTestCell2 class];

#设置分页器模式 以下属性为可空属性 默认不开启分页器模式
carouselV.pageType = SYCarouselPageTypeHasPage;

#设置分页器当前页和其他页颜色 以下属性为可空属性 默认当前页为白色 其他页为灰色
carouselV.pageCurrentColor = [UIColor orangeColor];
carouselV.pageOtherColor = [UIColor blueColor];

#设置分页器当前页和其他页图片 以下属性为可空属性 默认无图片
carouselV.pageCurrentImage = [UIImage imageNamed:@"1.png"];
carouselV.pageOtherImage = [UIImage imageNamed:@"2.png"];

#设置分页器显示位置 以下属性为可空属性 默认显示在中间
_carouselView.pagePlace = SYPageControlPalceRight;

#
typedef NS_ENUM(NSInteger){
SYPageControlPalceCenter= 0, //中间
SYPageControlPalceLeft = 1,  //左下角
SYPageControlPalceRight = 2  //右下角
}SYPageControlPalceType;
#

#*可填 (以上属性必须在添加到父视图之前完成设置 且先设置样式再设置配置属性 否则无效) *#

#* 必填 *#
                                添加到要作用的父视图上
                [self.view addSubview:carouselV];
last->          carouselV.modelList = @[模型数组];
#(
    例如:
    //请求数据
    [SYHeaderModel headerLineListWithIndex:self.index success:^(NSArray<SYHeaderModel *> *result) {
    carouselV.modelList = result;
    } fail:^(NSError *error) {
    NSLog(@"%@",error);
    }];
)#

                                




***
* 
*                               未完待续
*                               谢谢使用
* 
***
