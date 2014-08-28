//
//  BarTabViewController.h
//  BarTab
//
//  Created by Sunny Shah on 7/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GivingViewController.h"
#import "PageContentViewController.h"
#import "GivingViewController.h"
#import "MasterRootViewController.h"


@interface BarTabViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property id<FBGraphUser> facebookUser;

//Page View Controller Tutorial
- (IBAction)startWalkthrough:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) GivingViewController *givingViewController;
@property (strong, nonatomic) MasterRootViewController *masterRootViewController;


@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
