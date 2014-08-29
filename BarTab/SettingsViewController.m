//
//  SettingsViewController.m
//  BarTab
//
//  Created by Sunny Shah on 8/27/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "SettingsViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kMasterColor 0x51B0BD
#define kBackgroundColor 0xE9E9E9
#define kSupportingColor 0x51bdb8
#define kCellHeight 120
#define kAchievementFont 20.0f
#define kAchievementFontType @"GillSans-Light"

#define kBoxColor1 0xD9BA98
#define kBoxColor2 0x0A498C
#define kBoxColor3 0x5D7894
#define kBoxColor4 0x92BBDE
#define kBoxColor5 0xBD9451

@interface SettingsViewController (){
    UIView* mainNavBar;
    CGRect screenRect;
}

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    screenRect = [[UIScreen mainScreen] bounds];
    [self loadMainNavBar];
    [self loadPaymentSourceButton];
    [self loadShareButton];
    [self loadContactUsButton];
    [self loadLogOutButton];
    [self loadPrivacyPolicyButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMainNavBar{
    mainNavBar = [[UIView alloc]initWithFrame:CGRectMake(screenRect.origin.x,screenRect.origin.y,screenRect.size.width, 70)];
    
    float stdYoffset =screenRect.origin.y+20;
    
    UIImageView* logoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(screenRect.origin.x,stdYoffset, 150, 40)];
    [logoIcon setImage:[UIImage imageNamed:@"gift.png"]];
    //[mainNavBar addSubview:logoIcon];
    
    float half = (screenRect.origin.x + screenRect.size.width) * 0.5;
    
    UIButton *profPicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    profPicButton.frame = CGRectMake(20, stdYoffset, 40, 40);
    NSString *imageName = [NSString stringWithFormat:@"logo_simplified.png"];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [profPicButton setImage:btnImage forState:UIControlStateNormal];
    [profPicButton addTarget:self action:@selector(profilePictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[mainNavBar addSubview:profPicButton];
    
    UIButton *giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    giftButton.frame = CGRectMake(half-20, stdYoffset, 40, 40);
    //imageName = [NSString stringWithFormat:@"logo.png"];
    imageName = [NSString stringWithFormat:@"settings_solid.png"];
    btnImage = [UIImage imageNamed:imageName];
    [giftButton setImage:btnImage forState:UIControlStateNormal];
    [giftButton addTarget:self action:@selector(giftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:giftButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(screenRect.size.width - 60, stdYoffset, 40, 40);
    imageName = [NSString stringWithFormat:@"logo_simplified.png"];
    btnImage = [UIImage imageNamed:imageName];
    [searchButton setImage:btnImage forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:searchButton];
    
    [mainNavBar setBackgroundColor:UIColorFromRGB(kMasterColor)];
    
    [self.view addSubview:mainNavBar];
}

-(void)loadPaymentSourceButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,
                              mainNavBar.frame.size.height,
                              screenRect.size.width*0.5,
                              screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5));
    [button setTitle:@"Manage Payment Source" forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setBackgroundColor:UIColorFromRGB(kBoxColor1)];
    [button addTarget:self action:@selector(paymentSourcePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)loadShareButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenRect.size.width*0.5,
                              mainNavBar.frame.size.height,
                              screenRect.size.width*0.5,
                              screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5));
    [button setTitle:@"Share Treat" forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setBackgroundColor:UIColorFromRGB(kBoxColor2)];
    [button addTarget:self action:@selector(loadShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)loadContactUsButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,
                              screenRect.size.height*0.5+(mainNavBar.frame.size.height*0.5),
                              screenRect.size.width*0.5,
                              screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5));
    [button setTitle:@"Contact Us" forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setBackgroundColor:UIColorFromRGB(kBoxColor3)];
    [button addTarget:self action:@selector(contactUsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)loadPrivacyPolicyButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenRect.size.width*0.5,
                              screenRect.size.height*0.5+(mainNavBar.frame.size.height*0.5),
                              screenRect.size.width*0.5,
                              (screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5))*0.5);
    [button setTitle:@"Privacy Policy" forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setBackgroundColor:UIColorFromRGB(kBoxColor4)];
    [button addTarget:self action:@selector(privacyPolicyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)loadLogOutButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenRect.size.width*0.5,
                              screenRect.size.height*0.5+(mainNavBar.frame.size.height*0.5)+(screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5))*0.5,
                              screenRect.size.width*0.5,
                              (screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5))*0.5);
    [button setTitle:@"Log Out" forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setBackgroundColor:UIColorFromRGB(kBoxColor5)];
    [button addTarget:self action:@selector(logOutPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}



- (void)showEmail{
    // Email Subject
    NSString *emailTitle = @"Treat Feedback";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@treatapp.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)paymentSourcePressed:(id)sender
{
    NSLog(@"paymentSourcePressed");
}

-(void)sharePressed:(id)sender
{
    NSLog(@"sharePressed");
    
}

-(void)contactUsPressed:(id)sender
{
    NSLog(@"contactUsPressed");
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
    [self showEmail];
}

-(void)privacyPolicyPressed:(id)sender
{
    NSLog(@"Privacy policy pressed");
    
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0.0, 0.0, screenRect.size.width*0.9, screenRect.size.height*0.9);
    
    //Add privacy stuff

    NSString* path = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicy"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    UITextView *myTextView = [[UITextView alloc] initWithFrame:contentView.frame];
    myTextView.text = content;
    [contentView addSubview:myTextView];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView];
    [popup show];
}

-(void)logOutPressed:(id)sender
{
    NSLog(@"logOutPressed");
    if (FBSession.activeSession.isOpen)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        [self performSegueWithIdentifier:@"logOutTransition" sender:self];
    }
    
}

@end
