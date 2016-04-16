//
//  SYLoadImageTool.h
//  无限轮播工具
//
//  Created by 邵世约 on 16/3/23.
//  Copyright © 2016年 邵世约. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCarouselView.h"

@interface SYLoadImageTool : NSObject
/*
    动态加载图片
 */
+(void)setImageWithImageUrlString:(NSString *)urlString loadView:(UIView *)loadView;

@end
