//
//  ChocolateGiftScreen.h
//  BarTab
//
//  Created by Sunny Shah on 8/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChocolateGiftScreen : UIView <UITextViewDelegate>

@property NSString* firstName;

-(id)initWithFrame:(CGRect)frame andADictionary:(NSDictionary*)dict;

@end
