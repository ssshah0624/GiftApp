//
//  Contact.h
//  BarTab
//
//  Created by Sunny Shah on 10/13/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property NSString* uniqueIdentifier;
@property NSString* firstName;
@property NSString* lastName;
@property NSString* mobileNumber;
@property NSArray* otherNumbers;

@end
