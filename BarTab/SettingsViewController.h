//
//  SettingsViewController.h
//  BarTab
//
//  Created by Sunny Shah on 8/27/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import "STPView.h"
#import "KLCPopup.h"

#import "MasterRootViewController.h"


@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property STPView* stripeView;
@property NSUInteger pageIndex;

@end
