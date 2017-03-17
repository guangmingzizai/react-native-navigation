//
//  UITabBar+RCCBadge.m
//  ReactNativeNavigation
//
//  Created by wangjianfei on 2017/3/17.
//  Copyright © 2017年 artal. All rights reserved.
//

#import "UITabBar+RCCBadge.h"
#import <objc/runtime.h>

static const CGFloat kBadgeDotViewDimension = 8;
static const CGFloat kBadgeDotOffset = 2;

static const int kBadgeDotMark;

@interface RCCTabBarBadgeDotView : UIView

@end

@implementation RCCTabBarBadgeDotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.width / 2.0;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = frame.size.width / 2.0;
}

@end

@implementation UITabBar (RCCBadge)

- (void)rcc_setBadgeDotHidden:(BOOL)hidden forItem:(UITabBarItem *)item {
    RCCTabBarBadgeDotView *badgeDotView = objc_getAssociatedObject(item, &kBadgeDotMark);
    if (hidden) {
        if (badgeDotView) {
            [badgeDotView removeFromSuperview];
            objc_setAssociatedObject(item, &kBadgeDotMark, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        if (!badgeDotView) {
            badgeDotView = [[RCCTabBarBadgeDotView alloc] initWithFrame:CGRectMake(0, 0, kBadgeDotViewDimension, kBadgeDotViewDimension)];
            [self rcc_addBadgeDotView:badgeDotView ToItem:item];
            
        }
    }
}

- (void)rcc_addBadgeDotView:(RCCTabBarBadgeDotView *)badgeDotView ToItem:(UITabBarItem *)item {
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.25;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.92];
    pulse.toValue = [NSNumber numberWithFloat:1.08];
    
    NSInteger index = [self.items indexOfObject:item];
    UIView *tabBarButton = tabbarbuttonArray[index];
    UIImageView *tabBarIcon = tabBarButton.subviews.firstObject;
    
    [self addSubview:badgeDotView];
    
    CGPoint position = CGPointMake(tabBarIcon.frame.size.width - kBadgeDotViewDimension / 2.0 + kBadgeDotOffset, kBadgeDotViewDimension / 2.0 - kBadgeDotOffset);
    badgeDotView.center = [self convertPoint:position fromView:tabBarIcon];
    
    if ([item respondsToSelector:@selector(badgeColor)]) {
        UIColor *badgeColor = [item badgeColor];
        badgeDotView.backgroundColor = badgeColor ?: [UIColor redColor];
    }
    
    objc_setAssociatedObject(item, &kBadgeDotMark, badgeDotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
