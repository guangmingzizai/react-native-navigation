#import "RCCTabBarController.h"
#import "RCCViewController.h"
#import <React/RCTConvert.h>
#import "RCCManager.h"
#import "RCTHelpers.h"
#import <React/RCTUIManager.h>
#import "UIViewController+Rotation.h"
#import "UITabBar+RCCBadge.h"
#import "UITabBar+RCCAnimation.h"
#import "RCCImageTabBarItem.h"

@interface RCTUIManager ()

- (void)configureNextLayoutAnimation:(NSDictionary *)config
                        withCallback:(RCTResponseSenderBlock)callback
                       errorCallback:(__unused RCTResponseSenderBlock)errorCallback;

@end

@implementation RCCTabBarController {
  NSInteger _indexFlag;
  BOOL _animateTabBarItem;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return [self supportedControllerOrientations];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  id queue = [[RCCManager sharedInstance].getBridge uiManager].methodQueue;
  dispatch_async(queue, ^{
    [[[RCCManager sharedInstance].getBridge uiManager] configureNextLayoutAnimation:nil withCallback:^(NSArray* arr){} errorCallback:^(NSArray* arr){}];
  });
  
  if (tabBarController.selectedIndex != [tabBarController.viewControllers indexOfObject:viewController]) {
    [RCCTabBarController sendScreenTabChangedEvent:viewController];
  }

  return YES;
}

- (UIImage *)image:(UIImage*)image withColor:(UIColor *)color1
{
  UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, 0, image.size.height);
  CGContextScaleCTM(context, 1.0, -1.0);
  CGContextSetBlendMode(context, kCGBlendModeNormal);
  CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
  CGContextClipToMask(context, rect, image.CGImage);
  [color1 setFill];
  CGContextFillRect(context, rect);
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
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

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children globalProps:(NSDictionary*)globalProps bridge:(RCTBridge *)bridge
{
  self = [super init];
  if (!self) return nil;

  self.delegate = self;

  self.tabBar.translucent = YES; // default

  UIColor *buttonColor = nil;
  UIColor *selectedButtonColor = nil;
  NSDictionary *tabsStyle = props[@"style"];
  if (tabsStyle)
  {
    NSString *tabBarButtonColor = tabsStyle[@"tabBarButtonColor"];
    if (tabBarButtonColor)
    {
      UIColor *color = tabBarButtonColor != (id)[NSNull null] ? [RCTConvert UIColor:tabBarButtonColor] : nil;
      self.tabBar.tintColor = color;
      buttonColor = color;
      selectedButtonColor = color;
    }

    NSString *tabBarSelectedButtonColor = tabsStyle[@"tabBarSelectedButtonColor"];
    if (tabBarSelectedButtonColor)
    {
      UIColor *color = tabBarSelectedButtonColor != (id)[NSNull null] ? [RCTConvert UIColor:tabBarSelectedButtonColor] : nil;
      self.tabBar.tintColor = color;
      selectedButtonColor = color;
    }

    NSNumber *removeBorderLine = tabsStyle[@"removeBorderLine"];
    NSString *tabBarBackgroundColor = tabsStyle[@"tabBarBackgroundColor"];
    if (tabBarBackgroundColor)
    {
      UIColor *color = tabBarBackgroundColor != (id)[NSNull null] ? [RCTConvert UIColor:tabBarBackgroundColor] : nil;
      if (color && removeBorderLine.boolValue) {
        self.tabBar.backgroundImage = [self imageWithColor:color size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 49)];
      } else {
        self.tabBar.barTintColor = color;
      }
    }
    
    NSString *shadowImageColor = tabsStyle[@"shadowImageColor"];
    if (removeBorderLine.boolValue) {
      self.tabBar.shadowImage = [UIImage new];
    } else if (shadowImageColor) {
      UIColor *color = shadowImageColor != (id)[NSNull null] ? [RCTConvert UIColor:shadowImageColor] : nil;
      if (color) {
        self.tabBar.shadowImage = [self imageWithColor:color size:CGSizeMake([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale, 1)];
      }
    }
    
    NSNumber *animateTabBarItem = tabsStyle[@"animateTabBarItem"];
    if (animateTabBarItem && animateTabBarItem.boolValue) {
      _animateTabBarItem = YES;
    }
  }

  NSMutableArray *viewControllers = [NSMutableArray array];

  // go over all the tab bar items
  for (NSDictionary *tabItemLayout in children)
  {
    // make sure the layout is valid
    if (![tabItemLayout[@"type"] isEqualToString:@"TabBarControllerIOS.Item"]) continue;
    if (!tabItemLayout[@"props"]) continue;

    // get the view controller inside
    if (!tabItemLayout[@"children"]) continue;
    if (![tabItemLayout[@"children"] isKindOfClass:[NSArray class]]) continue;
    if ([tabItemLayout[@"children"] count] < 1) continue;
    NSDictionary *childLayout = tabItemLayout[@"children"][0];
    UIViewController *viewController = [RCCViewController controllerWithLayout:childLayout globalProps:globalProps bridge:bridge];
    if (!viewController) continue;

    // create the tab icon and title
    NSString *title = tabItemLayout[@"props"][@"title"];
    UIImage *iconImage = nil;
    id icon = tabItemLayout[@"props"][@"icon"];
    if (icon)
    {
      iconImage = [RCTConvert UIImage:icon];
      if (buttonColor)
      {
        iconImage = [[self image:iconImage withColor:buttonColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      }
    }
    UIImage *iconImageSelected = nil;
    id selectedIcon = tabItemLayout[@"props"][@"selectedIcon"];
    if (selectedIcon) {
      iconImageSelected = [RCTConvert UIImage:selectedIcon];
    } else {
      iconImageSelected = [RCTConvert UIImage:icon];
    }

    if (title == nil || title == [NSNull null] || title.length == 0) {
      viewController.tabBarItem = [[RCCImageTabBarItem alloc] initWithTitle:title image:iconImage tag:0];
    } else {
      viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:iconImage tag:0];
    }
    viewController.tabBarItem.accessibilityIdentifier = tabItemLayout[@"props"][@"testID"];
    viewController.tabBarItem.selectedImage = iconImageSelected;
    
    NSMutableDictionary *unselectedAttributes = [RCTHelpers textAttributesFromDictionary:tabsStyle withPrefix:@"tabBarText" baseFont:[UIFont systemFontOfSize:10]];
    if (!unselectedAttributes[NSForegroundColorAttributeName] && buttonColor) {
      unselectedAttributes[NSForegroundColorAttributeName] = buttonColor;
    }
    
    [viewController.tabBarItem setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal]
    ;
    
    NSMutableDictionary *selectedAttributes = [RCTHelpers textAttributesFromDictionary:tabsStyle withPrefix:@"tabBarSelectedText" baseFont:[UIFont systemFontOfSize:10]];
    if (!selectedAttributes[NSForegroundColorAttributeName] && selectedButtonColor) {
      selectedAttributes[NSForegroundColorAttributeName] = selectedButtonColor;
    }
    
    [viewController.tabBarItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    NSString *badgeColorString = tabItemLayout[@"props"][@"badgeColor"];
    if (badgeColorString && [viewController.tabBarItem respondsToSelector:@selector(setBadgeColor:)])
    {
      viewController.tabBarItem.badgeColor = [RCTConvert UIColor:badgeColorString];
    }
    
    // create badge
    NSObject *badge = tabItemLayout[@"props"][@"badge"];
    if (badge == nil || [badge isEqual:[NSNull null]])
    {
      viewController.tabBarItem.badgeValue = nil;
      
      NSNumber *showBadgeDot = tabItemLayout[@"props"][@"showBadgeDot"];
      if (showBadgeDot && showBadgeDot.boolValue) {
        [self.tabBar rcc_setBadgeDotHidden:NO forItem:viewController.tabBarItem];
      } else {
        [self.tabBar rcc_setBadgeDotHidden:YES forItem:viewController.tabBarItem];
      }
    }
    else
    {
      viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", badge];
      
      // if badge exists, hide badgeDot
      [self.tabBar rcc_setBadgeDotHidden:YES forItem:viewController.tabBarItem];
    }

    [viewControllers addObject:viewController];
  }

  // replace the tabs
  self.viewControllers = viewControllers;
  
  [self setRotation:props];

  return self;
}

- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge completion:(void (^)(void))completion
{
  if ([performAction isEqualToString:@"setBadge"])
  {
    UIViewController *viewController = nil;
    NSNumber *tabIndex = actionParams[@"tabIndex"];
    if (tabIndex)
    {
      int i = (int)[tabIndex integerValue];

      if ([self.viewControllers count] > i)
      {
        viewController = [self.viewControllers objectAtIndex:i];
      }
    }
    NSString *contentId = actionParams[@"contentId"];
    NSString *contentType = actionParams[@"contentType"];
    if (contentId && contentType)
    {
      viewController = [[RCCManager sharedInstance] getControllerWithId:contentId componentType:contentType];
    }

    if (viewController)
    {
      NSString *badgeColorString = actionParams[@"badgeColor"];
      if (badgeColorString && [viewController.tabBarItem respondsToSelector:@selector(setBadgeColor:)])
      {
        viewController.tabBarItem.badgeColor = [RCTConvert UIColor:badgeColorString];
      }
      
      NSObject *badge = actionParams[@"badge"];

      if (badge == nil || [badge isEqual:[NSNull null]])
      {
        viewController.tabBarItem.badgeValue = nil;
        
        NSNumber *showBadgeDot = actionParams[@"showBadgeDot"];
        if (showBadgeDot && showBadgeDot.boolValue) {
          [self.tabBar rcc_setBadgeDotHidden:NO forItem:viewController.tabBarItem];
        } else {
          [self.tabBar rcc_setBadgeDotHidden:YES forItem:viewController.tabBarItem];
        }
      }
      else
      {
        viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", badge];
        
        // if badge exists, hide badgeDot
        [self.tabBar rcc_setBadgeDotHidden:YES forItem:viewController.tabBarItem];
      }
    }
  }

  if ([performAction isEqualToString:@"switchTo"])
  {
    UIViewController *viewController = nil;
    NSNumber *tabIndex = actionParams[@"tabIndex"];
    if (tabIndex)
    {
      int i = (int)[tabIndex integerValue];

      if ([self.viewControllers count] > i)
      {
        viewController = [self.viewControllers objectAtIndex:i];
      }
    }
    NSString *contentId = actionParams[@"contentId"];
    NSString *contentType = actionParams[@"contentType"];
    if (contentId && contentType)
    {
      viewController = [[RCCManager sharedInstance] getControllerWithId:contentId componentType:contentType];
    }

    if (viewController)
    {
      [self setSelectedViewController:viewController];
    }
  }

  if ([performAction isEqualToString:@"setTabBarHidden"])
  {
    BOOL hidden = [actionParams[@"hidden"] boolValue];
    [UIView animateWithDuration: ([actionParams[@"animated"] boolValue] ? 0.45 : 0)
                          delay: 0
         usingSpringWithDamping: 0.75
          initialSpringVelocity: 0
                        options: (hidden ? UIViewAnimationOptionCurveEaseIn : UIViewAnimationOptionCurveEaseOut)
                     animations:^()
     {
       self.tabBar.transform = hidden ? CGAffineTransformMakeTranslation(0, self.tabBar.frame.size.height) : CGAffineTransformIdentity;
     }
                     completion:^(BOOL finished)
     {
       if (completion != nil)
       {
         completion();
       }
     }];
    return;
  }
  else if (completion != nil)
  {
    completion();
  }
}

+ (void)sendScreenTabChangedEvent:(UIViewController*)viewController {
  if ([viewController.view isKindOfClass:[RCTRootView class]]){
    RCTRootView *rootView = (RCTRootView *)viewController.view;
    
    if (rootView.appProperties && rootView.appProperties[@"navigatorEventID"]) {
      NSString *navigatorID = rootView.appProperties[@"navigatorID"];
      NSString *screenInstanceID = rootView.appProperties[@"screenInstanceID"];
      
      [[[RCCManager sharedInstance] getBridge].eventDispatcher sendAppEventWithName:rootView.appProperties[@"navigatorEventID"] body:@
       {
         @"id": @"bottomTabSelected",
         @"navigatorID": navigatorID,
         @"screenInstanceID": screenInstanceID
       }];
    }
  }
  
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController*)viewController;
    UIViewController *topViewController = [navigationController topViewController];
    [RCCTabBarController sendScreenTabChangedEvent:topViewController];
  }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  if (_animateTabBarItem) {
    NSInteger index = [tabBar.items indexOfObject:item];
    if (_indexFlag != index) {
      [tabBar rcc_animateIconWithIndex:index];
      
      _indexFlag = index;
    }
  }
}

@end
