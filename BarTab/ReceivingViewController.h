//
//  ReceivingViewController.h
//  BarTab
//
//  Created by Sunny Shah on 7/24/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RCLighting.h>
#import <AMWaveTransition.h>
#import "KLCPopup.h"
#import "RoseGiftScreen.h"
#import "ChocolateGiftScreen.h"
#import "DrinkGiftScreen.h"
#import "MasterRootViewController.h"

@interface ReceivingViewController : UIViewController

@property NSUInteger pageIndex;

@property (strong, nonatomic) IBOutlet UITableView *infoTable;
@property (strong, nonatomic) IBOutlet AMWaveTransition *interactive;
@property UIDynamicAnimator* animator;

@end
