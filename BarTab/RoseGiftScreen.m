//
//  RoseGiftScreen.m
//  BarTab
//
//  Created by Sunny Shah on 8/15/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "RoseGiftScreen.h"

@implementation RoseGiftScreen
{
    CGRect screenRect;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        screenRect = [[UIScreen mainScreen] bounds];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundImage:@"rose_background cropped.png"];
        [self addDrawerImage:@"drawer.png"];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andADictionary:(NSDictionary*)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        screenRect = [[UIScreen mainScreen] bounds];
        
        UILabel* label = [dict objectForKey:@"friendName"];
        self.firstName = label.text;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundImage:@"rose_background cropped.png"];
        [self addDrawerImage:@"drawer.png"];
    }
    return self;
}

-(void)setBackgroundImage:(NSString*)name
{
    UIImageView* backgroundImage = [[UIImageView alloc]initWithFrame:self.frame];
    [backgroundImage setImage:[UIImage imageNamed:name]];
    [self addSubview:backgroundImage];
}

-(void)addDrawerImage:(NSString*)name
{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.5,screenRect.size.width, screenRect.size.height*0.5)];
    [imageView setImage:[UIImage imageNamed:name]];
    [self addSubview:imageView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
