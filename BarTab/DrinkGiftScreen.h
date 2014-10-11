//
//  DrinkGiftScreen.h
//  BarTab
//
//  Created by Sunny Shah on 8/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDKNotifyHUD.h>
#import "MasterRootViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import "ServerCalls.h"

@interface DrinkGiftScreen : UIView <UITextViewDelegate>

@property NSString* firstName;

-(id)initWithFrame:(CGRect)frame andADictionary:(NSDictionary*)dict;
@property UIDynamicAnimator* animator;

@end
