//
//  UIImage+RCCColor.m
//  ReactNativeNavigation
//
//  Created by wangjianfei on 2017/3/21.
//  Copyright © 2017年 artal. All rights reserved.
//

#import "UIImage+RCCColor.h"

@implementation UIImage (RCCColor)

+ (UIImage *)rcc_imageWithColor:(UIColor *)color size:(CGSize)size
{
    if ((size.height == 0 || size.width == 0)) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
