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
#import <AMPopTip.h>
#import <MCSwipeTableViewCell.h>
#import "RoseGiftScreen.h"
#import "ChocolateGiftScreen.h"
#import "DrinkGiftScreen.h"

@interface ReceivingViewController : UIViewController <MCSwipeTableViewCellDelegate>

@property NSUInteger pageIndex;

@property (strong, nonatomic) IBOutlet UITableView *infoTable;
@property MCSwipeTableViewCell* cellToDelete;
@property (strong, nonatomic) IBOutlet AMWaveTransition *interactive;
@property UIDynamicAnimator* animator;

@end
