//
//  RCCImageTabBarItem.m
//  ReactNativeNavigation
//
//  Created by wangjianfei on 2017/3/17.
//  Copyright © 2017年 artal. All rights reserved.
//

#import "RCCImageTabBarItem.h"

@implementation RCCImageTabBarItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:nil];
}

@end
