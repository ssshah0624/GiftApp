//
//  ChocolateGiftScreen.m
//  BarTab
//
//  Created by Sunny Shah on 8/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "ChocolateGiftScreen.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define degreesToRadians(x) (M_PI * x / 180.0)

#define kSending 0
#define kSent 1
#define kReceived 2

#define kQuantity0 0
#define kQuantity1 1
#define kQuantity2 2

#define kMasterColor 0x51B0BD
#define kBackgroundColor 0xE9E9E9
#define kSupportingColor 0x51bdb8
#define kCellHeight 120
#define kAchievementFont 20.0f
#define kAchievementFontType @"GillSans-Light"

@implementation ChocolateGiftScreen
{
    CGRect screenRect;
    UIImageView* backgroundImage;
    UILabel* description;
    UITextView *myTextView;
    UILabel* characterCount;
    CGFloat origin_x;
    CGFloat origin_y;
    NSMutableArray* selectedFlowerAmounts;
    
    UIButton* oneDoz;
    UIButton* twoDoz;
    UIButton* threeDoz;}

-(id)initWithFrame:(CGRect)frame andADictionary:(NSDictionary*)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        screenRect = [[UIScreen mainScreen] bounds];
        
        UILabel* label = [dict objectForKey:@"friendName"];
        if([label isKindOfClass:[NSString class]]){
            self.firstName = [[[dict objectForKey:@"friendName"] componentsSeparatedByString:@" "]objectAtIndex:0];
        }else{
            self.firstName = [[label.text componentsSeparatedByString:@" "]objectAtIndex:0];
        }
        
        origin_x = frame.origin.x;
        origin_y = frame.origin.y;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [self addGestureRecognizer:tap];
        selectedFlowerAmounts = [[NSMutableArray alloc]init];
        [selectedFlowerAmounts addObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts addObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts addObject:[NSNumber numberWithBool:NO]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        [self handleLayout:dict];
    }
    return self;
}

-(void)handleLayout:(NSDictionary*)dict
{
    switch ([[dict objectForKey:@"giftStatus"] intValue]) {
        case kSending:
            [self setBackgroundImage:@"18ct.png"];
            [self addDrawerImage:@"drawer.png"];
            [self addNavBar:dict];
            [self addDescription:[NSString stringWithFormat:@"Send Chocolates to %@",self.firstName]];
            [self addTextView];
            [self addButtons];
            break;
        case kSent:
            NSLog(@"Sent");
            switch ([[dict objectForKey:@"giftQuantity"] intValue]) {
                case kQuantity0:
                    [self setBackgroundImage:@"18ct.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Sent 18-piece Chocolate Set to %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                case kQuantity1:
                    [self setBackgroundImage:@"24ct.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Sent 24-piece Chocolate Set to %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                case kQuantity2:
                    [self setBackgroundImage:@"48ct.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Sent 48-piece Chocolate Set to %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                default:
                    break;
            }
            break;
        case kReceived:
            NSLog(@"Received");
            switch ([[dict objectForKey:@"giftQuantity"] intValue]) {
                case kQuantity0:
                    [self setBackgroundImage:@"18ct.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Received 18-piece Chocolate Set from %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                case kQuantity1:
                    [self setBackgroundImage:@"24ct.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Received 24-piece Chocolate Set from %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                case kQuantity2:
                    [self setBackgroundImage:@"48ct.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Received 48-piece Chocolate Set from %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
}

-(void)addDescription:(NSString*)text
{
    description = [[UILabel alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.47,screenRect.size.width, screenRect.size.height*0.1)];
    description.text = text;
    description.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f]; //Mess with font
    description.numberOfLines = 1;
    description.adjustsFontSizeToFitWidth = YES;
    description.adjustsLetterSpacingToFitWidth = YES;
    description.minimumScaleFactor = 10.0f/12.0f;
    description.clipsToBounds = YES;
    description.backgroundColor = [UIColor clearColor];
    description.textColor = UIColorFromRGB(kSupportingColor);
    description.textAlignment = NSTextAlignmentCenter;
    [self addSubview:description];
}


-(void)setBackgroundImage:(NSString*)name
{
    backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.origin.x,-screenRect.origin.y-35,self.frame.size.width,self.frame.size.height)];
    [backgroundImage setImage:[UIImage imageNamed:name]];
    [self addSubview:backgroundImage];
}

-(void)addDrawerImage:(NSString*)name
{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.43,screenRect.size.width, screenRect.size.height*0.57)];
    [imageView setImage:[UIImage imageNamed:name]];
    [self addSubview:imageView];
}

-(void)addTextView
{
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, screenRect.size.height*0.60, screenRect.size.width, screenRect.size.height*0.12)];
    myTextView.text = @"Custom Message";
    myTextView.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:16.0];
    myTextView.textColor = [UIColor grayColor];
    [myTextView setEditable:YES];
    myTextView.delegate = self;
    [self addSubview:myTextView];
    
    characterCount = [[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width-50,screenRect.size.height*0.66,50, screenRect.size.height*0.1)];
    characterCount.text = @"104";
    characterCount.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]; //Mess with font
    characterCount.textColor = UIColorFromRGB(kSupportingColor);
    characterCount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:characterCount];
    
    
    //[myTextView sizeToFit];
}

-(void)addTextView:(NSString*)withText
{
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, screenRect.size.height*0.60, screenRect.size.width, screenRect.size.height*0.12)];
    myTextView.text = withText;
    myTextView.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:16.0];
    myTextView.textColor = [UIColor grayColor];
    [myTextView setEditable:NO];
    myTextView.delegate = self;
    [self addSubview:myTextView];
}

-(void)addButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenRect.size.width * 0.5 - (300*0.5*0.5), screenRect.size.height*0.84, 300*0.5, 80*0.5);
    NSString *imageName = [NSString stringWithFormat:@"send_button.png"];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    //One dozen
    oneDoz = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    oneDoz.frame = CGRectMake(10,screenRect.size.height*0.72,100,60);
    [oneDoz setTitle:@"18-piece" forState:UIControlStateNormal];
    [oneDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [oneDoz addTarget:self action:@selector(flowerAmountSelected:) forControlEvents:UIControlEventTouchUpInside];
    oneDoz.tag = 1;
    [self addSubview:oneDoz];
    
    //Two dozen
    twoDoz = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    twoDoz.frame = CGRectMake(screenRect.size.width*0.5-50,screenRect.size.height*0.72,100,60);
    [twoDoz setTitle:@"24-piece" forState:UIControlStateNormal];
    [twoDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [twoDoz setTitleColor:UIColorFromRGB(0x3cb878) forState:UIControlStateSelected];
    [twoDoz addTarget:self action:@selector(flowerAmountSelected:) forControlEvents:UIControlEventTouchUpInside];
    twoDoz.tag = 2;
    [self addSubview:twoDoz];
    
    //Three dozen
    threeDoz = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    threeDoz.frame = CGRectMake(screenRect.size.width-110,screenRect.size.height*0.72,100,60);
    [threeDoz setTitle:@"48-piece" forState:UIControlStateNormal];
    [threeDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [threeDoz setTitleColor:UIColorFromRGB(0x3cb878) forState:UIControlStateSelected];
    [threeDoz addTarget:self action:@selector(flowerAmountSelected:) forControlEvents:UIControlEventTouchUpInside];
    threeDoz.tag = 3;
    [self addSubview:threeDoz];
    
    
}

-(void)sendPressed:(id)sender
{
    NSLog(@"Send pressed");
}

-(void)flowerAmountSelected:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if(button.tag == 1){
        [button setTitleColor:UIColorFromRGB(kSupportingColor) forState:UIControlStateNormal];
        [twoDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [threeDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [selectedFlowerAmounts replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
        [selectedFlowerAmounts replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
        description.text = [NSString stringWithFormat:@"Send Chocolate to %@ ($20)",self.firstName];
        backgroundImage.image = [UIImage imageNamed:@"18ct.png"];
    }else if(button.tag == 2){
        [button setTitleColor:UIColorFromRGB(kSupportingColor) forState:UIControlStateNormal];
        [oneDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [threeDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [selectedFlowerAmounts replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
        [selectedFlowerAmounts replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
        description.text = [NSString stringWithFormat:@"Send Chocolate to %@ ($25)",self.firstName];
        backgroundImage.image = [UIImage imageNamed:@"24ct.png"];
    }else if(button.tag == 3){
        [button setTitleColor:UIColorFromRGB(kSupportingColor) forState:UIControlStateNormal];
        [oneDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [twoDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [selectedFlowerAmounts replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
        description.text = [NSString stringWithFormat:@"Send Chocolate to %@ ($30)",self.firstName];
        backgroundImage.image = [UIImage imageNamed:@"36ct.png"];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

//Textfield editing
#pragma mark TextFieldDelegates
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"Custom Message"]){
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self performAnimations:100];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    characterCount.text = [NSString stringWithFormat:@"%i",104 - (int)[myTextView.text length]];
    if([[textView text] length] - range.length + text.length > 104){
        NSLog(@"Fit condition");
        return NO;
    }
    return YES;
}


-(void)performAnimations:(float)bywhat
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.frame=CGRectMake(self.frame.origin.x, (self.frame.origin.y -bywhat), self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.frame=CGRectMake(origin_x, origin_y, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    if([textView.text length] == 0){
        textView.text = @"Custom Message";
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard {
    [myTextView resignFirstResponder];
}

-(void)addNavBar:(NSDictionary*)dict
{
    UIView* mainNavBar = [[UIView alloc]init];
    if([[dict valueForKey:@"giftStatus"] isEqualToString:@"0"]){
        mainNavBar.frame = CGRectMake(0,-screenRect.origin.y-35,screenRect.size.width, 70);
    }else{
        mainNavBar.frame = CGRectMake(0,-screenRect.origin.y,screenRect.size.width, 70);
    }
    
    [mainNavBar setBackgroundColor:UIColorFromRGB(kMasterColor)];
    mainNavBar.alpha=0.95;
    float stdYoffset =screenRect.origin.y+20;
    
    UIImageView* logoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(screenRect.origin.x,stdYoffset, 150, 40)];
    [logoIcon setImage:[UIImage imageNamed:@"gift.png"]];
    
    float half = (screenRect.origin.x + screenRect.size.width) * 0.5;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(20, stdYoffset, 40, 40);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:backButton];
    
    [self addSubview:mainNavBar];
}

-(void)backButtonPressed:(id)sender
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self setTransform:CGAffineTransformMakeRotation(degreesToRadians(20))];
                         self.frame = CGRectMake(0,50,self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         // code to run when animation completes
                         // (in this case, another animation:)
                         [UIView animateWithDuration:1.0
                                          animations:^{
                                              self.frame = CGRectMake(0,screenRect.size.height,self.frame.size.width, self.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              [self removeFromSuperview];
                                          }];
                     }];
}

@end
