//
//  RoseGiftScreen.m
//  BarTab
//
//  Created by Sunny Shah on 8/15/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "RoseGiftScreen.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kSending 0
#define kSent 1
#define kReceived 2

#define kQuantity0 0
#define kQuantity1 1
#define kQuantity2 2



@implementation RoseGiftScreen
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
    UIButton* threeDoz;
}

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
            [self setBackgroundImage:@"rose_background.png"];
            [self addDrawerImage:@"drawer.png"];
            [self addNavBar:dict];
            [self addDescription:[NSString stringWithFormat:@"Send Roses to %@",self.firstName]];
            [self addTextView];
            [self addButtons];
            break;
        case kSent:
            NSLog(@"Sent");
            switch ([[dict objectForKey:@"giftQuantity"] intValue]) {
                case kQuantity0:
                    [self setBackgroundImage:@"1dozen.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Sent 1 dozen Roses to %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                case kQuantity1:
                    [self setBackgroundImage:@"2dozen.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Sent 2 dozen Roses to %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                case kQuantity2:
                    [self setBackgroundImage:@"3dozen.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Sent 3 dozen Roses to %@",self.firstName]];
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
                    [self setBackgroundImage:@"1dozen.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Received 1 dozen Roses from %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                case kQuantity1:
                    [self setBackgroundImage:@"2dozen.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Received 2 dozen Roses from %@",self.firstName]];
                    [self addTextView:[dict objectForKey:@"customMessage"]];
                    [self addButtons];
                    break;
                case kQuantity2:
                    [self setBackgroundImage:@"3dozen.png"];
                    [self addDrawerImage:@"drawer.png"];
                    [self addNavBar:dict];
                    [self addDescription:[NSString stringWithFormat:@"Received 3 dozen Roses from %@",self.firstName]];
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

-(void)setBackgroundImage:(NSString*)name{
    backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.origin.x,-screenRect.origin.y,self.frame.size.width,self.frame.size.height)];
    [backgroundImage setImage:[UIImage imageNamed:name]];
    [self addSubview:backgroundImage];
}

-(void)addDrawerImage:(NSString*)name
{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.43,screenRect.size.width, screenRect.size.height*0.57)];
    [imageView setImage:[UIImage imageNamed:name]];
    [self addSubview:imageView];
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
    description.textColor = UIColorFromRGB(0x3cb878);
    description.textAlignment = NSTextAlignmentCenter;
    [self addSubview:description];
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
    characterCount.textColor = UIColorFromRGB(0x3cb878);
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
    [oneDoz setTitle:@"One dozen" forState:UIControlStateNormal];
    [oneDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [oneDoz addTarget:self action:@selector(flowerAmountSelected:) forControlEvents:UIControlEventTouchUpInside];
    oneDoz.tag = 1;
    [self addSubview:oneDoz];
    
    //Two dozen
    twoDoz = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    twoDoz.frame = CGRectMake(screenRect.size.width*0.5-50,screenRect.size.height*0.72,100,60);
    [twoDoz setTitle:@"Two dozen" forState:UIControlStateNormal];
    [twoDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [twoDoz setTitleColor:UIColorFromRGB(0x3cb878) forState:UIControlStateSelected];
    [twoDoz addTarget:self action:@selector(flowerAmountSelected:) forControlEvents:UIControlEventTouchUpInside];
    twoDoz.tag = 2;
    [self addSubview:twoDoz];
    
    //Three dozen
    threeDoz = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    threeDoz.frame = CGRectMake(screenRect.size.width-110,screenRect.size.height*0.72,100,60);
    [threeDoz setTitle:@"Three dozen" forState:UIControlStateNormal];
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
        [button setTitleColor:UIColorFromRGB(0x3cb878) forState:UIControlStateNormal];
        [twoDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [threeDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [selectedFlowerAmounts replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
        [selectedFlowerAmounts replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
        [backgroundImage setImage:[UIImage imageNamed:@"1dozen.png"]];
        description.text = [NSString stringWithFormat:@"Send Roses to %@ ($15)",self.firstName];
    }else if(button.tag == 2){
        [button setTitleColor:UIColorFromRGB(0x3cb878) forState:UIControlStateNormal];
        [oneDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [threeDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [selectedFlowerAmounts replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
        [selectedFlowerAmounts replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
        [backgroundImage setImage:[UIImage imageNamed:@"2dozen.png"]];
        description.text = [NSString stringWithFormat:@"Send Roses to %@ ($30)",self.firstName];
    }else if(button.tag == 3){
        [button setTitleColor:UIColorFromRGB(0x3cb878) forState:UIControlStateNormal];
        [oneDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [twoDoz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [selectedFlowerAmounts replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:NO]];
        [selectedFlowerAmounts replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
        [backgroundImage setImage:[UIImage imageNamed:@"3dozen.png"]];
        description.text = [NSString stringWithFormat:@"Send Roses to %@ ($40)",self.firstName];
    }
}

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
        //UIView* mainNavBar = [[UIView alloc]initWithFrame:CGRectMake(0,-screenRect.origin.y-35,screenRect.size.width, 70)];
        mainNavBar.frame = CGRectMake(0,-screenRect.origin.y,screenRect.size.width, 70);
    }else{
        mainNavBar.frame = CGRectMake(0,-screenRect.origin.y,screenRect.size.width, 70);
    }
    
    
    float stdYoffset =screenRect.origin.y+20;
    
    UIImageView* logoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(screenRect.origin.x,stdYoffset, 150, 40)];
    [logoIcon setImage:[UIImage imageNamed:@"gift.png"]];
    //[mainNavBar addSubview:logoIcon];
    
    float half = (screenRect.origin.x + screenRect.size.width) * 0.5;
    
    UIButton *profPicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    profPicButton.frame = CGRectMake(20, stdYoffset, 40, 40);
    NSString *imageName = [NSString stringWithFormat:@"person_solid.png"];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [profPicButton setImage:btnImage forState:UIControlStateNormal];
    [profPicButton addTarget:self action:@selector(profilePictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:profPicButton];
    
    UIButton *giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    giftButton.frame = CGRectMake(half-20, stdYoffset, 40, 40);
    imageName = [NSString stringWithFormat:@"gift_outline.png"];
    btnImage = [UIImage imageNamed:imageName];
    [giftButton setImage:btnImage forState:UIControlStateNormal];
    [giftButton addTarget:self action:@selector(giftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:giftButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(screenRect.size.width - 60, stdYoffset, 40, 40);
    imageName = [NSString stringWithFormat:@"search_outline.png"];
    btnImage = [UIImage imageNamed:imageName];
    [searchButton setImage:btnImage forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:searchButton];
    
    [mainNavBar setBackgroundColor:UIColorFromRGB(0x3cb878)];
    
    [self addSubview:mainNavBar];
}



@end
