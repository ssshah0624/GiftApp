//
//  GiftHandlingView.m
//  BarTab
//
//  Created by Sunny Shah on 9/1/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "GiftHandlingView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kSending 0
#define kSent 1
#define kReceived 2

#define kQuantity0 0
#define kQuantity1 1
#define kQuantity2 2

#define degreesToRadians(x) (M_PI * x / 180.0)

#define kMasterColor 0x51B0BD
#define kBackgroundColor 0xE9E9E9
#define kSupportingColor 0x51bdb8
#define kCellHeight 120
#define kAchievementFont 20.0f
#define kAchievementFontType @"GillSans-Light"

@implementation GiftHandlingView
{
    CGRect screenRect;
    UILabel* description;
    UITextView *myTextView;
    UILabel* myTextLabel;
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
    
    //Touch handlers
    CGFloat firstX;
    CGFloat firstY;
    
    NSDictionary* theDictionary;
    
    //Address
    UIView* addressView;
    KLCPopup* addressPopup;
    UITextField *nameField;
    UITextField *deliveryAddress;
    UITextField *cityStateZipField;
    
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
        
        theDictionary = dict;
        
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
    NSString* tempNameHelper = [dict objectForKey:@"friendName"];
    NSString* firstName = [NSString stringWithFormat:@"%@",[[tempNameHelper componentsSeparatedByString:@" "]objectAtIndex:0]];
    NSString* imageNameHelper = [NSString stringWithFormat:@"%@.jpg",[firstName lowercaseString]];
    //UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNameHelper]];
    [self setBackgroundImage:imageNameHelper];
    switch ([[dict objectForKey:@"giftStatus"] intValue]) {
        case kSending:
            [self addDrawerImage:@"drawer.png"];
            [self addNavBar:dict];
            [self addDescription:[NSString stringWithFormat:@"Fill %@'s bar tab",self.firstName]];
            [self addTextView];
            [self addButtons];
            break;
        case kSent:
            NSLog(@"Sent");
            [self addDrawerImage:@"drawer.png"];
            [self addNavBar:dict];
            [self addDescription:[NSString stringWithFormat:@"Sent $%@ bar tab to %@",[dict objectForKey:@"giftQuantity"],[dict objectForKey:@"friendName"]]];
            [self addTextView:[dict objectForKey:@"customMessage"] :dict];
            //[self addIdleButtons];
            break;
        case kReceived:
            NSLog(@"Received");
            [self addDrawerImage:@"drawer.png"];
            [self addNavBar:dict];
            [self addDescription:[NSString stringWithFormat:@"Received $%@ bar tab from %@",[dict objectForKey:@"giftQuantity"],[dict objectForKey:@"friendName"]]];
            [self addTextView:[dict objectForKey:@"customMessage"] :dict];
            //[self addIdleButtons];
            break;
        default:
            break;
    }
    
}


-(void)setBackgroundImage:(NSString*)name
{
    UIImageView* backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.origin.x,60,self.frame.size.width,self.frame.size.height*0.4)];
    [backgroundImage setImage:[UIImage imageNamed:name]];
    [self addSubview:backgroundImage];
}

-(void)addDrawerImage:(NSString*)name
{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.43,screenRect.size.width, screenRect.size.height*0.57)];
    [imageView setImage:[UIImage imageNamed:name]];
    [self addSubview:imageView];
}

-(void)addNavBar:(NSDictionary*)dict
{
    UIView* mainNavBar = [[UIView alloc]init];
    if([[dict valueForKey:@"giftStatus"] isEqualToString:@"0"]){
        mainNavBar.frame = CGRectMake(0,-screenRect.origin.y-35,screenRect.size.width, 60);
    }else{
        mainNavBar.frame = CGRectMake(0,-screenRect.origin.y,screenRect.size.width, 60);
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
    
    UILabel *firstName = [[UILabel alloc] initWithFrame:CGRectMake(half-40, stdYoffset, 80, 40)];
    firstName.text = self.firstName;
    firstName.textAlignment = UITextAlignmentCenter;
    firstName.font = [UIFont fontWithName:kAchievementFontType size:kAchievementFont];
    [firstName setTextColor:[UIColor whiteColor]];
    [mainNavBar addSubview:firstName];
    
    /*
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
     */
    
    [self addSubview:mainNavBar];
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
    //[self addSubview:description];
}


-(void)addTextView
{
    //myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, screenRect.size.height*0.60, screenRect.size.width, screenRect.size.height*0.12)];
    
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,screenRect.size.height*0.47,screenRect.size.width, screenRect.size.height*0.1)];
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
    //[self addSubview:characterCount];
    
    
    //[myTextView sizeToFit];
}

-(void)addTextView:(NSString*)withText :(NSDictionary*)dict
{
    myTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.47,screenRect.size.width, screenRect.size.height*0.1)];
    myTextLabel.text = [NSString stringWithFormat:@"\"%@\"",withText];
    myTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    myTextLabel.numberOfLines = 0;
    myTextLabel.textAlignment = UITextAlignmentCenter;
    int fontSize = [self sizeLabel:myTextLabel toRect:myTextLabel.frame];
    [myTextLabel setFont:[UIFont fontWithName:@"GillSans-Light" size:fontSize]];
    myTextLabel.textColor = UIColorFromRGB(kMasterColor);
    [self addSubview:myTextLabel];
    
    UILabel* item = [[UILabel alloc] initWithFrame:CGRectMake(4,screenRect.size.height*0.60, screenRect.size.width, 20)];
    if([[dict objectForKey:@"giftType"] isEqualToString:@"flower"]){
        item.text = [NSString stringWithFormat:@"Item: %@ dozen roses",[dict objectForKey:@"giftQuantity"]];
    }else if([[dict objectForKey:@"giftType"] isEqualToString:@"drink"]){
        item.text = [NSString stringWithFormat:@"Item: $%@ bar tab",[dict objectForKey:@"giftQuantity"]];
    }else if([[dict objectForKey:@"giftType"] isEqualToString:@"chocolate"]){
        switch ([[dict objectForKey:@"giftQuantity"] intValue]) {
            case kQuantity0:
                item.text =@"Item: 12-pack chocolates";
                break;
            case kQuantity1:
                item.text =@"Item: 24-pack chocolates";
                break;
            case kQuantity2:
                item.text =@"Item: 48-pack chocolates";
                break;
            default:
                break;
        }
    }
    [item setFont:[UIFont fontWithName:@"GillSans-Light" size:16]];
    item.textColor = [UIColor blackColor];
    [self addSubview:item];
    
    BOOL hasAddress = NO;
    if(hasAddress){
        UILabel* address = [[UILabel alloc] initWithFrame:CGRectMake(4,screenRect.size.height*0.60 + 25, screenRect.size.width, 20)];
        address.text = @"Address: SERVER FILL IN PROPER ADDRESS";
        [address setFont:[UIFont fontWithName:@"GillSans-Light" size:16]];
        address.textColor = [UIColor blackColor];
        [self addSubview:address];
    }else{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(addressButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Address: Please enter desired delivery address" forState:UIControlStateNormal];
        button.frame = CGRectMake(-5,screenRect.size.height*0.60 + 25, screenRect.size.width, 20);
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        button.titleLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:button];
    }
    
    UILabel* deliveryDate = [[UILabel alloc] initWithFrame:CGRectMake(4,screenRect.size.height*0.60 + 50, screenRect.size.width, 20)];
    deliveryDate.text = @"Delivery Date: N/A";
    [deliveryDate setFont:[UIFont fontWithName:@"GillSans-Light" size:16]];
    deliveryDate.textColor = [UIColor blackColor];
    [self addSubview:deliveryDate];
    
    UIButton *thankButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [thankButton addTarget:self
                    action:@selector(thankFriend:)
          forControlEvents:UIControlEventTouchUpInside];
    [thankButton setTitle:[NSString stringWithFormat:@"Thank %@",self.firstName] forState:UIControlStateNormal];
    thankButton.frame = CGRectMake(screenRect.size.width*0.1,screenRect.size.height*0.77, screenRect.size.width*0.8, 50);
    [thankButton setBackgroundColor:UIColorFromRGB(kMasterColor)];
    [thankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:thankButton];
    
    UIButton *ignoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ignoreButton addTarget:self
                     action:@selector(backButtonPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    [ignoreButton setTitle:[NSString stringWithFormat:@"Ignore %@",self.firstName] forState:UIControlStateNormal];
    ignoreButton.frame = CGRectMake(screenRect.size.width*0.1,screenRect.size.height*0.77+55, screenRect.size.width*0.8, 50);
    [ignoreButton setBackgroundColor:UIColorFromRGB(0xC4C4C4)];
    [ignoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:ignoreButton];
    
}

-(void)thankFriend:(id)sender
{
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [theDictionary objectForKey:@"friendName"], @"friendName",
                              @"0",@"giftStatus",
                              @"Custom Message",@"customMessage",
                              nil];
    
    DrinkGiftScreen *drinkScreen = [[DrinkGiftScreen alloc]initWithFrame:CGRectMake(0,30,screenRect.size.width,screenRect.size.height) andADictionary:tempDict];
    [self addSubview:drinkScreen];
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
    martiniSlider.tintColor = UIColorFromRGB(kSupportingColor);
    martiniSlider.thumbTintColor = UIColorFromRGB(kSupportingColor);
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

-(void)addIdleButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenRect.size.width * 0.5 - (300*0.5*0.5), screenRect.size.height*0.84, 300*0.5, 80*0.5);
    NSString *imageName = [NSString stringWithFormat:@"send_button.png"];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    martiniImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon33.png"]];
    martiniImageView1.frame = CGRectMake((self.frame.size.width/2)-(0.5*100),screenRect.size.height*0.26,100,100);
    [self addSubview:martiniImageView1];
}


-(void)martiniValueChanged:(id)sender
{
    UISlider* martiniSliderHelper = (UISlider*)sender;
    //description.text = [NSString stringWithFormat:@"Fill %@'s bar tab ($%.0f)",self.firstName,martiniSliderHelper.value];
    description.text = [NSString stringWithFormat:@"($%.0f)",martiniSliderHelper.value];
    
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

- (UIImage *) changeColorForImage:(UIImage *)image toColor:(UIColor*)color {
    UIGraphicsBeginImageContext(image.size);
    
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [image size];
    // Retrieve source image and begin image context
    CGSize itemImageSize = [image size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
    
    UIGraphicsBeginImageContext(contextRect.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [image CGImage]);
    // Fill and end the transparency layer
    
    
    const float* colors = CGColorGetComponents( color.CGColor );
    CGContextSetRGBFillColor(c, colors[0], colors[1], colors[2], .75);
    
    contextRect.size.height = -contextRect.size.height;
    contextRect.size.height -= 15;
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)backButtonPressed:(id)sender
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self setTransform:CGAffineTransformMakeRotation(degreesToRadians(20))];
                         self.frame = CGRectMake(0,50,self.frame.size.width, self.frame.size.height);
                         martiniImageView1.frame = CGRectMake(screenRect.size.width*0.5,-20,martiniImageView1.frame.size.width, martiniImageView1.frame.size.width);
                         martiniImageView2.frame = CGRectMake(screenRect.size.width*0.1,-40,martiniImageView1.frame.size.width, martiniImageView1.frame.size.width);
                         martiniImageView3.frame = CGRectMake(screenRect.size.width*0.2,-4,martiniImageView1.frame.size.width, martiniImageView1.frame.size.width);
                     }
                     completion:^(BOOL finished){
                         // code to run when animation completes
                         // (in this case, another animation:)
                         [UIView animateWithDuration:1.0
                                          animations:^{
                                              self.frame = CGRectMake(0,screenRect.size.height,self.frame.size.width, self.frame.size.height);
                                              martiniImageView1.frame = CGRectMake(screenRect.size.width*0.5,100,martiniImageView1.frame.size.width, martiniImageView1.frame.size.width);
                                              martiniImageView2.frame = CGRectMake(screenRect.size.width*0.1,140,martiniImageView1.frame.size.width, martiniImageView1.frame.size.width);
                                              martiniImageView3.frame = CGRectMake(screenRect.size.width*0.2,180,martiniImageView1.frame.size.width, martiniImageView1.frame.size.width);
                                          }
                                          completion:^(BOOL finished){
                                              [self removeFromSuperview];
                                          }];
                     }];
}

-(void)addressButtonPressed:(id)sender
{
    NSLog(@"Enter your address here");
    addressView = [[UIView alloc] init];
    addressView.backgroundColor = [UIColor whiteColor];
    addressView.frame = CGRectMake(0.0, screenRect.size.height*0.2, screenRect.size.width*0.87, screenRect.size.height*0.5);
    
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(0,0,addressView.frame.size.width, 30)];
    title.textAlignment = UITextAlignmentCenter;
    title.text = @"Your Delivery Information";
    title.backgroundColor = UIColorFromRGB(kMasterColor);
    title.font = [UIFont fontWithName:kAchievementFontType size:24];
    title.textColor = [UIColor whiteColor];
    [addressView addSubview:title];
    
    //    Name or attention line:	JANE L MILLER
    //    Company:	MILLER ASSOCIATES
    //    Delivery address:	1960 W CHELSEA AVE STE 2006
    //    City, state, ZIP Code:	ALLENTOWN PA 18104
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(5,addressView.frame.size.height*0.15,addressView.frame.size.width*0.94, addressView.frame.size.height*0.15)];
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.font = [UIFont systemFontOfSize:15];
    nameField.placeholder = @"Address Nickname i.e. Home";
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.keyboardType = UIKeyboardTypeDefault;
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.delegate = self;
    [addressView addSubview:nameField];
    
    deliveryAddress = [[UITextField alloc] initWithFrame:CGRectMake(5,addressView.frame.size.height*0.35,addressView.frame.size.width*0.94, addressView.frame.size.height*0.15)];
    deliveryAddress.borderStyle = UITextBorderStyleRoundedRect;
    deliveryAddress.font = [UIFont systemFontOfSize:15];
    deliveryAddress.placeholder = @"Delivery Address";
    deliveryAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    deliveryAddress.keyboardType = UIKeyboardTypeDefault;
    deliveryAddress.returnKeyType = UIReturnKeyDone;
    deliveryAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    deliveryAddress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    deliveryAddress.delegate = self;
    [addressView addSubview:deliveryAddress];
    
    cityStateZipField = [[UITextField alloc] initWithFrame:CGRectMake(5,addressView.frame.size.height*0.55,addressView.frame.size.width*0.94, addressView.frame.size.height*0.15)];
    cityStateZipField.borderStyle = UITextBorderStyleRoundedRect;
    cityStateZipField.font = [UIFont systemFontOfSize:15];
    cityStateZipField.placeholder = @"City, State, Zip";
    cityStateZipField.autocorrectionType = UITextAutocorrectionTypeNo;
    cityStateZipField.keyboardType = UIKeyboardTypeDefault;
    cityStateZipField.returnKeyType = UIReturnKeyDone;
    cityStateZipField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cityStateZipField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cityStateZipField.delegate = self;
    [addressView addSubview:cityStateZipField];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(5,addressView.frame.size.height*0.75,addressView.frame.size.width*0.94, addressView.frame.size.height*0.2);
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setBackgroundColor:UIColorFromRGB(kMasterColor)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(addressSubmitted:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.alpha = 0.7;
    [addressView addSubview:submitButton];
    
    addressPopup = [KLCPopup popupWithContentView:addressView];
    [addressPopup show];
}

-(void)addressSubmitted:(id)sender
{
    NSLog(@"SERVER CALL TO SAVE ADDRESS \n %@ \n %@ \n %@",nameField.text, deliveryAddress.text, cityStateZipField.text);
}

-(BOOL)verifyDeliveryAddress:(NSString*)address
{
    return YES;
}

-(BOOL)verifyCityStateZip:(NSString*)cityStateZip
{
    return YES;
}


//EXPERIMENT
- (int) sizeLabel: (UILabel *) label toRect: (CGRect) labelRect  {
    
    // Set the frame of the label to the targeted rectangle
    label.frame = labelRect;
    
    // Try all font sizes from largest to smallest font size
    int fontSize = 300;
    int minFontSize = 5;
    
    // Fit label width wize
    CGSize constraintSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    
    do {
        // Set current font size
        label.font = [UIFont fontWithName:label.font.fontName size:fontSize];
        
        // Find label size for current font size
        CGRect textRect = [[label text] boundingRectWithSize:constraintSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:label.font}
                                                     context:nil];
        
        CGSize labelSize = textRect.size;
        
        // Done, if created label is within target size
        if( labelSize.height <= label.frame.size.height )
            break;
        
        // Decrease the font size and try again
        fontSize -= 2;
        
    } while (fontSize > minFontSize);
    
    return fontSize;
}

- (BOOL) quickCheckSizeLabel: (UILabel *) label toRect: (CGRect) labelRect  {
    
    // Set the frame of the label to the targeted rectangle
    label.frame = labelRect;
    
    // Try all font sizes from largest to smallest font size
    int fontSize = kAchievementFont;
    
    // Fit label width wize
    CGSize constraintSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    
    // Set current font size
    label.font = [UIFont fontWithName:label.font.fontName size:fontSize];
    
    // Find label size for current font size
    CGRect textRect = [[label text] boundingRectWithSize:constraintSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:label.font}
                                                 context:nil];
    
    CGSize labelSize = textRect.size;
    
    if(labelSize.height <= label.frame.size.height) return true;
    
    return false;
}

@end