//
//  ContactsData.h
//  BarTab
//
//  Created by Sunny Shah on 10/2/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsData : NSObject

@property (strong, nonatomic) NSMutableArray *numbers;

@property (strong, nonatomic) NSMutableArray *emails;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSString *firstNames;

@property (strong, nonatomic) NSString *lastNames;

@end
