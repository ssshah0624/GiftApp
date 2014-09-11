//
//  GiftHandlingView.h
//  BarTab
//
//  Created by Sunny Shah on 9/1/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrinkGiftScreen.h"

@interface GiftHandlingView : UIView <UITextViewDelegate>

@property NSString* firstName;

-(id)initWithFrame:(CGRect)frame andADictionary:(NSDictionary*)dict;
@property UIDynamicAnimator* animator;

@end
