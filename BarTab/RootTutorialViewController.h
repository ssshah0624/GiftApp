//
//  RootTutorialViewController.h
//  BarTab
//
//  Created by Sunny Shah on 7/23/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
#import "GivingViewController.h"
#import "ReceivingViewController.h"
#import "BarTabViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RootTutorialViewController : UIViewController <UIPageViewControllerDataSource, FBLoginViewDelegate>

- (IBAction)startWalkthrough:(id)sender;
- (IBAction)startReceiving:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) GivingViewController *givingViewController;
@property (strong, nonatomic) ReceivingViewController *receivingViewController;
@property (strong, nonatomic) BarTabViewController *barTabViewController;

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property id<FBGraphUser> facebookUser;

@end
