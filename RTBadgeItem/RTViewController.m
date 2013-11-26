//
//  RTViewController.m
//  RTBadgeItem
//
//  Created by ricky on 13-11-26.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "RTViewController.h"
#import "RTBadgeItem.h"

@interface RTViewController ()
@property (nonatomic, retain) IBOutlet RTBadgeItem *leftItem;
@property (nonatomic, retain) IBOutlet RTBadgeItem *rightItem;

- (IBAction)toggleLeftShow:(id)sender;
- (IBAction)toggleRightShow:(id)sender;

- (IBAction)toggleAnimating:(id)sender;

- (IBAction)badgeTapped:(id)sender;

@end

@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.leftItem.badgeColor = [UIColor blueColor];
    self.leftItem.badgeNumber = 24;
    self.rightItem.badgeNumber = 120;
    
    [self.leftItem show];
    [self.rightItem show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleLeftShow:(id)sender
{
    if (self.leftItem.isVisible)
        [self.leftItem hide];
    else
        [self.leftItem show];
}

- (IBAction)toggleRightShow:(id)sender
{
    if (self.rightItem.isVisible)
        [self.rightItem hide];
    else
        [self.rightItem show];
}

- (IBAction)toggleAnimating:(id)sender
{
    self.leftItem.animating = !self.leftItem.isAnimating;
}

- (IBAction)badgeTapped:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Message"
                                message:@"Badge Tapped!"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
}

@end
