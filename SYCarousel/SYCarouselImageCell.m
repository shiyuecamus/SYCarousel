//
//  SYUnlimitedCell.m
//  无限轮播工具
//
//  Created by 邵世约 on 16/3/23.
//  Copyright © 2016年 邵世约. All rights reserved.
//

#import "SYCarouselImageCell.h"
#import "SYLoadImageTool.h"


@interface SYCarouselImageCell ()

@property (nonatomic,nonnull,strong) UIImageView * iv_image;

@end

@implementation SYCarouselImageCell

#pragma mark - 懒加载
-(UIImageView *)iv_image{
    if (!_iv_image) {
        _iv_image = [[UIImageView alloc] init];
    }
    return _iv_image;
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [SYLoadImageTool setImageWithImageUrlString:imageUrl loadView:self.iv_image];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加子控件
        [self.contentView addSubview:self.iv_image];
    }
    return self;
}

/*
    布局子控件
 */

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //布局imageView
    self.iv_image.frame = self.contentView.bounds;
}



@end
