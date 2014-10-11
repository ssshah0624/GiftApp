//
//  ServerCalls.h
//  BarTab
//
//  Created by Sunny Shah on 9/10/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerCalls : UIViewController

@property NSString *userAuthToken;

-(void)postFBAuthToken:(NSString*)authToken;
-(void)postGift:(NSString*)authToken :(NSString*)giftType :(NSString*)amount;
-(void)getAllSentGifts:(NSString*)authToken;
-(void)getAllReceivedGifts:(NSString*)authToken;

-(NSString*)getAuthToken;

@end
