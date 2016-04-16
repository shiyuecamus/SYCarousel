//
//  SYLoadImageTool.m
//  无限轮播工具
//
//  Created by 邵世约 on 16/3/23.
//  Copyright © 2016年 邵世约. All rights reserved.
//

#import "SYLoadImageTool.h"

typedef NS_OPTIONS(NSUInteger, SYLoadImageType) {
    SYLoadImageTypeImageName = 0,   //本地图片名称
    SYLoadImageTypeContentFile = 1, //本地路径
    SYLoadImageTypeUrl = 2          //网络加载图片
};

@implementation SYLoadImageTool
+(void)setImageWithImageUrlString:(NSString *)urlString loadView:(UIView *)loadView{
    if ([loadView isKindOfClass:[UIButton class]]) {
        //按钮
        UIButton * btn = (UIButton *)loadView;
        switch ([self returnWithUrlString:urlString]) {
            case SYLoadImageTypeUrl:
                [btn yy_setBackgroundImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal options:0];
                break;
                
            case SYLoadImageTypeImageName:
                [btn setBackgroundImage:[UIImage imageNamed:urlString] forState:UIControlStateNormal];
                break;
                
            case SYLoadImageTypeContentFile:
                [btn setBackgroundImage:[UIImage imageWithContentsOfFile:urlString] forState:UIControlStateNormal];
            default:
                break;
        }
        
    }else if ([loadView isKindOfClass:[UIImageView class]]){
        //图片
        UIImageView * iv = (UIImageView *)loadView;
        switch ([self returnWithUrlString:urlString]) {
            case SYLoadImageTypeUrl:
                [iv yy_setImageWithURL:[NSURL URLWithString:urlString] options:0];
                break;
                
            case SYLoadImageTypeImageName:
                iv.image = [UIImage imageNamed:urlString];
                break;
                
            case SYLoadImageTypeContentFile:
                iv.image = [UIImage imageWithContentsOfFile:urlString];
            default:
                break;
        }
    }
}

+(SYLoadImageType)returnWithUrlString:(NSString *)urlString{
    if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
        //网络图片
        return SYLoadImageTypeUrl;
    }else if ([urlString hasPrefix:@"/Users/"]){
        //本地图片
        return SYLoadImageTypeContentFile;
    }else{
        return SYLoadImageTypeImageName;
    }
}

@end
