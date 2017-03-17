//
//  UITabBar+RCCAnimation.m
//  ReactNativeNavigation
//
//  Created by wangjianfei on 2017/3/17.
//  Copyright © 2017年 artal. All rights reserved.
//

#import "UITabBar+RCCAnimation.h"

@implementation UITabBar (RCCAnimation)

- (void)rcc_animateIconWithIndex:(NSInteger)index {
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    UIView *tabBarButton = tabbarbuttonArray[index];
    UIImageView *tabBarIcon = tabBarButton.subviews.firstObject;
    
    if ([tabBarIcon isKindOfClass:[UIImageView class]]) {
        CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulse.duration = 0.25;
        pulse.repeatCount = 1;
        pulse.autoreverses = YES;
        pulse.fromValue = [NSNumber numberWithFloat:0.92];
        pulse.toValue = [NSNumber numberWithFloat:1.08];
        
        [tabBarIcon.layer addAnimation:pulse forKey:nil];
    }
}

@end
