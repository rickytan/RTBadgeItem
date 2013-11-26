//
//  RTBadgeItem.h
//  RTBadgeItem
//
//  Created by ricky on 13-11-26.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !__has_feature(objc_arc)
#error This Needs ARC!!!
#endif

@interface RTBadgeItem : UIBarButtonItem
@property (nonatomic, assign) NSUInteger badgeNumber;   // Default 0
@property (nonatomic, assign, getter = isAnimating) BOOL animating;
@property (nonatomic, assign, readonly, getter = isVisible) BOOL visible;
@property (nonatomic, retain) UIColor *badgeColor;      // Default Red

- (id)initWithBadgeNumber:(NSUInteger)badgeNumber;
- (void)show;
- (void)hide;

@end
