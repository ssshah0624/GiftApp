//
//  DrinkGiftScreen.m
//  BarTab
//
//  Created by Sunny Shah on 8/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "DrinkGiftScreen.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation DrinkGiftScreen
{
    CGRect screenRect;
    UILabel* description;
    UITextView *myTextView;
    UILabel* characterCount;
    CGFloat origin_x;
    CGFloat origin_y;
    NSMutableArray* selectedFlowerAmounts;
    
    UIButton* oneDoz;
    UIButton* twoDoz;
    UIButton* threeDoz;
    
    UIImageView* martiniImageView1;
    UIImageView* martiniImageView2;
    UIImageView* martiniImageView3;
    
}


-(id)initWithFrame:(CGRect)frame andADictionary:(NSDictionary*)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        screenRect = [[UIScreen mainScreen] bounds];
        UILabel* label = [dict objectForKey:@"friendName"];
        self.firstName = [[label.text componentsSeparatedByString:@" "]objectAtIndex:0];
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
        [self setBackgroundImage:@"bar bg image.png"];
        [self addDrawerImage:@"drawer.png"];
        [self addDescription];
        [self addTextView];
        [self addButtons];
    }
    return self;
}

-(void)setBackgroundImage:(NSString*)name
{
    UIImageView* backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y-0,self.frame.size.width,self.frame.size.height)];
    [backgroundImage setImage:[UIImage imageNamed:name]];
    [self addSubview:backgroundImage];
}

-(void)addDrawerImage:(NSString*)name
{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.43,screenRect.size.width, screenRect.size.height*0.57)];
    [imageView setImage:[UIImage imageNamed:name]];
    [self addSubview:imageView];
}

-(void)addDescription
{
    description = [[UILabel alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.47,screenRect.size.width, screenRect.size.height*0.1)];
    description.text = [NSString stringWithFormat:@"Fill %@'s bar tab",self.firstName];
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

-(void)addButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenRect.size.width * 0.5 - (300*0.5*0.5), screenRect.size.height*0.84, 300*0.5, 80*0.5);
    NSString *imageName = [NSString stringWithFormat:@"send_button.png"];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UISlider *martiniSlider = [[UISlider alloc] initWithFrame:CGRectMake(20,screenRect.size.height*0.72,screenRect.size.width-50,60)];
    [martiniSlider addTarget:self action:@selector(martiniValueChanged:) forControlEvents:UIControlEventValueChanged];
    martiniSlider.minimumValue = 0;
    martiniSlider.maximumValue = 100;
    martiniSlider.continuous = YES;
    martiniSlider.tintColor = UIColorFromRGB(0x3cb878);
    martiniSlider.thumbTintColor = UIColorFromRGB(0x3cb878);
    [self addSubview:martiniSlider];
    
    martiniImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView1.frame = CGRectMake((self.frame.size.width/2)-(0.5*100),screenRect.size.height*0.26,100,100);
    [self addSubview:martiniImageView1];
    
    martiniImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView2.frame = CGRectMake(screenRect.size.width,screenRect.size.height*0.26,100,100);
    [self addSubview:martiniImageView2];
    
    martiniImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView3.frame = CGRectMake(screenRect.size.width,screenRect.size.height*0.26,100,100);
    [self addSubview:martiniImageView3];
}

-(void)martiniValueChanged:(id)sender
{
    UISlider* martiniSliderHelper = (UISlider*)sender;
    description.text = [NSString stringWithFormat:@"Fill %@'s bar tab ($%.0f)",self.firstName,martiniSliderHelper.value];
    
    if(martiniSliderHelper.value < 33){
        NSString* iconNumber = [NSString stringWithFormat:@"%.f", martiniSliderHelper.value];
        NSString* imageName = [NSString stringWithFormat:@"martini_icon%@.png",iconNumber];
        martiniImageView1.image = [UIImage imageNamed:imageName];
        
        //Get the second martini out of the picture!
        if(martiniImageView2.frame.origin.x < screenRect.size.width){
            martiniImageView2.frame = CGRectMake(martiniImageView2.frame.origin.x+10,
                                              martiniImageView2.frame.origin.y,
                                              martiniImageView2.frame.size.width,
                                              martiniImageView2.frame.size.height);
        }
        
        //move first martini glass towards center
        if(martiniImageView1.frame.origin.x < 110){
            martiniImageView1.frame = CGRectMake(martiniImageView1.frame.origin.x+4,
                                              martiniImageView1.frame.origin.y,
                                              martiniImageView1.frame.size.width,
                                              martiniImageView1.frame.size.height);
        }
    }else if(martiniSliderHelper.value >= 33 && martiniSliderHelper.value < 66){
        //Start moving the first martini glass to the left
        if(martiniImageView1.frame.origin.x > 25){
            martiniImageView1.frame = CGRectMake(martiniImageView1.frame.origin.x-4,
                                              martiniImageView1.frame.origin.y,
                                              martiniImageView1.frame.size.width,
                                              martiniImageView1.frame.size.height);
        }
        //Get the second martini glass to the first glass's old position
        if(martiniImageView2.frame.origin.x > 110){
            martiniImageView2.frame = CGRectMake(martiniImageView2.frame.origin.x-10,
                                              martiniImageView2.frame.origin.y,
                                              martiniImageView2.frame.size.width,
                                              martiniImageView2.frame.size.height);
        }
        //Start filling the second glass
        NSString* iconNumber = [NSString stringWithFormat:@"%.f", martiniSliderHelper.value-33];
        NSString* imageName = [NSString stringWithFormat:@"martini_icon%@.png",iconNumber];
        martiniImageView2.image = [UIImage imageNamed:imageName];
        
        //Get the third glass out of here!
        if(martiniImageView3.frame.origin.x < screenRect.size.width){
            martiniImageView3.frame = CGRectMake(martiniImageView3.frame.origin.x+10,
                                              martiniImageView3.frame.origin.y,
                                              martiniImageView3.frame.size.width,
                                              martiniImageView3.frame.size.height);
        }
        
    }else{
        //Move third glass in
        if(martiniImageView3.frame.origin.x > 200){
            martiniImageView3.frame = CGRectMake(martiniImageView3.frame.origin.x-10,
                                              martiniImageView3.frame.origin.y,
                                              martiniImageView3.frame.size.width,
                                              martiniImageView3.frame.size.height);
        }
        
        //Fill the third glass
        NSString* iconNumber = [NSString stringWithFormat:@"%.f", martiniSliderHelper.value-66];
        NSString* imageName = [NSString stringWithFormat:@"martini_icon%@.png",iconNumber];
        martiniImageView3.image = [UIImage imageNamed:imageName];
    }

}

-(void)sendPressed:(id)sender
{
    NSLog(@"Send pressed");
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

@end
