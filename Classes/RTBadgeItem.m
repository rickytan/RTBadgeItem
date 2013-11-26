//
//  RTBadgeItem.m
//  RTBadgeItem
//
//  Created by ricky on 13-11-26.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "RTBadgeItem.h"

@interface RTBadgeView : UIControl
@property (nonatomic, strong) NSString *title;
@property (nonatomic, readonly, getter = isBadgeVisible) BOOL badgeVisible;
@property (nonatomic, retain) UIColor *badgeColor;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)startAnimating;
- (void)stopAnimating;
@end

@implementation RTBadgeItem
{
    RTBadgeView       * badgeView;
}

- (id)initWithBadgeNumber:(NSUInteger)badgeNumber
{
    badgeView = [RTBadgeView new];
    [badgeView addTarget:self
               action:@selector(onTap:event:)
     forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:badgeView];
    if (self) {
        self.badgeNumber = badgeNumber;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithBadgeNumber:0];
}

- (void)onTap:(id)sender event:(UIEvent*)event
{
    if ([event isKindOfClass:[UIEvent class]] && self.target && self.action)
        [self.target performSelector:self.action
                          withObject:self];
}

- (void)setBadgeNumber:(NSUInteger)badgeNumber
{
    _badgeNumber = badgeNumber;
    if (_badgeNumber > 99)
        badgeView.title = @"99";
    else
        badgeView.title = [NSString stringWithFormat:@"%d", _badgeNumber];
}

- (void)setBadgeColor:(UIColor *)badgeColor
{
    _badgeColor = badgeColor;
    badgeView.badgeColor = badgeColor;
}

- (void)setAnimating:(BOOL)animating
{
    _animating = animating;
    if (_animating) {
        [badgeView startAnimating];
    }
    else {
        [badgeView stopAnimating];
    }
}

- (BOOL)isVisible
{
    return badgeView.isBadgeVisible;
}

- (void)show
{
    [badgeView show:YES];
}

- (void)hide
{
    [badgeView hide:YES];
}

@end

@implementation RTBadgeView
{
    UILabel                     * titleLabel;
    UIImageView                 * bgView;
    UIActivityIndicatorView     * spinnerView;
}

@synthesize title = _title;

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 36, 44)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgView.contentMode = UIViewContentModeTop;
        bgView.hidden = YES;
        bgView.center = CGPointMake(self.bounds.size.width/2, -self.bounds.size.height/2);
        bgView.layer.shadowColor = [UIColor grayColor].CGColor;
        bgView.layer.shadowOffset = CGSizeMake(1, 1);
        bgView.layer.shadowRadius = 0.0;
        bgView.layer.shadowOpacity = 0.8;
        
        
        titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.center = CGPointMake(bgView.bounds.size.width/2, bgView.bounds.size.width/2);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [bgView addSubview:titleLabel];
        
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinnerView.hidesWhenStopped = YES;
        spinnerView.autoresizesSubviews =
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin;
        CGFloat s = 12.f;
        spinnerView.bounds = CGRectMake(0,0, s, s);
        spinnerView.center = titleLabel.center;
        
        [bgView addSubview:spinnerView];
        
        self.badgeColor = [UIColor redColor];
        [self addSubview:bgView];
    }
    return self;
}

#define BADGE_WIDTH     24.0f
#define BADGE_HEIGHT    44.0f

- (UIImage*)badgeImageWithColor:(UIColor*)color;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(BADGE_WIDTH, BADGE_HEIGHT), NO, [UIScreen mainScreen].scale);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, BADGE_HEIGHT)];
    [path addLineToPoint:CGPointMake(BADGE_WIDTH / 2, BADGE_HEIGHT - BADGE_WIDTH * tanf(15.0 / 180 * M_PI))];
    [path addLineToPoint:CGPointMake(BADGE_WIDTH, BADGE_HEIGHT)];
    [path addLineToPoint:CGPointMake(BADGE_WIDTH, 0)];
    [path closePath];
    
    [color setFill];
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
    CGContextFillPath(UIGraphicsGetCurrentContext());
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)isBadgeVisible
{
    return !bgView.isHidden;
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        titleLabel.text = _title;
    }
}

- (void)setBadgeColor:(UIColor *)badgeColor
{
    if (_badgeColor != badgeColor) {
        _badgeColor = badgeColor;
        UIImage *image = [self badgeImageWithColor:badgeColor];
        bgView.image = image;
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)
                blendMode:kCGBlendModeDarken
                    alpha:0.6];
        UIImage *highlighted = UIGraphicsGetImageFromCurrentImageContext();
        bgView.highlightedImage = highlighted;
        UIGraphicsEndImageContext();
    }
}

- (void)show:(BOOL)animated
{
    if (!bgView.isHidden)
        return;
    
    bgView.hidden = NO;
    titleLabel.hidden = NO;
    [UIView animateWithDuration:animated?1.2:0.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         bgView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
                     }
                     completion:NULL];
}

- (void)startAnimating
{
    if (spinnerView.isAnimating)
        return;
    
    spinnerView.transform = CGAffineTransformMakeScale(CGFLOAT_MIN, CGFLOAT_MIN);
    [spinnerView startAnimating];
    titleLabel.alpha = 1.f;
    titleLabel.hidden = NO;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         spinnerView.transform = CGAffineTransformIdentity;
                         titleLabel.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         titleLabel.hidden = finished;
                     }];
}

- (void)stopAnimating
{
    if (!spinnerView.isAnimating)
        return;
    
    titleLabel.hidden = NO;
    titleLabel.alpha = 0.f;
    spinnerView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         spinnerView.transform = CGAffineTransformMakeScale(CGFLOAT_MIN, CGFLOAT_MIN);
                         titleLabel.alpha = 1.f;
                     }
                     completion:^(BOOL finished) {
                         if (finished)
                             [spinnerView stopAnimating];
                     }];
    
}


- (void)hide:(BOOL)animated
{
    if (bgView.isHidden)
        return;

    [UIView animateWithDuration:animated?1.2:0.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         bgView.center = CGPointMake(self.bounds.size.width/2, -self.bounds.size.height/2);
                     }
                     completion:^(BOOL finished) {
                         bgView.hidden = finished;
                     }];
    
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    bgView.highlighted = highlighted;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return !bgView.isHidden;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.isTouchInside) {
        [super endTrackingWithTouch:touch withEvent:event];
    }
}

@end