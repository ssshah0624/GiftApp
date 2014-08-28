//
//  MasterRootViewController.h
//  BarTab
//
//  Created by Sunny Shah on 8/20/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GivingViewController.h"
#import "ReceivingViewController.h"

@interface MasterRootViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) GivingViewController *givingVC;

@end
