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


@interface ReceivingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *giftWindow;
@property (strong, nonatomic) IBOutlet AMWaveTransition *interactive;

@end
