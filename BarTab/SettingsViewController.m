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
#define kBoxColor6 0x94795D

@interface SettingsViewController ()
{
    UIView* mainNavBar;
    CGRect screenRect;
    KLCPopup* paymentPopup;
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
    [self loadPrivacyPolicyButton];
    [self loadTermsAndConditionsButton];
    [self loadLogOutButton];
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
    imageName = [NSString stringWithFormat:@"backarrow2.png"];
    btnImage = [UIImage imageNamed:imageName];
    [searchButton setImage:btnImage forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:searchButton];
    
    [mainNavBar setBackgroundColor:UIColorFromRGB(kMasterColor)];
    
    [self.view addSubview:mainNavBar];
}

-(void)giftButtonPressed:(id)sender
{
    NSLog(@"settings icon pressed -- do nothing");
}

-(void)homeButtonPressed:(id)sender
{
    MasterRootViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterRootViewController"];
    vc.startingIndex = @"1";
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
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
    [button addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)loadContactUsButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,
                              screenRect.size.height*0.5+(mainNavBar.frame.size.height*0.5),
                              screenRect.size.width*0.5,
                              (screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5))*0.5);
    [button setTitle:@"Contact Us" forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setBackgroundColor:UIColorFromRGB(kBoxColor3)];
    [button addTarget:self action:@selector(contactUsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)loadTermsAndConditionsButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,
                              screenRect.size.height*0.5+(mainNavBar.frame.size.height*0.5) + (screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5))*0.5,
                              screenRect.size.width*0.5,
                              (screenRect.size.height*0.5-(mainNavBar.frame.size.height*0.5))*0.5);
    [button setTitle:@"Terms & Conditions" forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setBackgroundColor:UIColorFromRGB(kBoxColor6)];
    [button addTarget:self action:@selector(termsAndConditionsPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.frame = CGRectMake(0.0, screenRect.size.height*0.2, screenRect.size.width, screenRect.size.height*0.8);
    
    //Add privacy stuff
    
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,0,290,55)
                                              andKey:@"pk_test_6pRNASCoBOKtIshFeQd4XMUh"];
    self.stripeView.delegate = self;
    [contentView addSubview:self.stripeView];
    
    //Add money images
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect.size.width*0.2,screenRect.size.height*0.2,screenRect.size.width*0.6,screenRect.size.height*0.1)];
    imgView.image = [UIImage imageNamed:@"cardtypes.png"];
    imgView.alpha=0.98;
    [contentView addSubview:imgView];
    
    //Add Save + Cancel Buttons
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton addTarget:self
               action:@selector(cancelPaymentManagement:)
     forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0,screenRect.size.height-216-100,screenRect.size.width*0.5,50);
    [cancelButton setBackgroundColor:UIColorFromRGB(kBoxColor2)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentView addSubview:cancelButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton addTarget:self
                   action:@selector(save:)
     forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(screenRect.size.width*0.5,screenRect.size.height-216-100,screenRect.size.width*0.5,50);
    [saveButton setBackgroundColor:UIColorFromRGB(kBoxColor1)];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentView addSubview:saveButton];
    
    
    paymentPopup = [KLCPopup popupWithContentView:contentView];
    [paymentPopup show];
}

-(void)cancelPaymentManagement:(id)sender
{
    [paymentPopup dismiss:YES];
}

-(void)sharePressed:(id)sender
{
    NSLog(@"sharePressed");
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        NSLog(@"Trying to share");
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    } else {
        // Present the feed dialog
        NSLog(@"Trying to share failed");
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing Tutorial", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)contactUsPressed:(id)sender
{
    NSString *emailTitle = @"Treat Feedback";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@treatapp.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void)privacyPolicyPressed:(id)sender
{
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

-(void)termsAndConditionsPressed:(id)sender
{
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0.0, 0.0, screenRect.size.width*0.9, screenRect.size.height*0.9);
    NSString* path = [[NSBundle mainBundle] pathForResource:@"TermsAndConditions"
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
    if (FBSession.activeSession.isOpen)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        [self performSegueWithIdentifier:@"logOutTransition" sender:self];
    }
    
}


//STRIPE INFO
//STRIPE INTEGRATION
- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    // Toggle navigation, for example
    
    NSLog(@"Valid card");
}

//Once the STPView is valid, you can call the createToken method, instructing the library to send off the credit card data to Stripe and return a token.
- (IBAction)save:(id)sender
{
    // Call 'createToken' when the save button is tapped
    [self.stripeView createToken:^(STPToken *token, NSError *error) {
        if (error) {
            // Handle error
            [self handleError:error];
        } else {
            // Send off token to your server
            [self handleToken:token];
        }
    }];}

//Handling error messages and network pending notifications are up to you. In the full example we use MBProgressHUD to show a spinner whenever the network's pending, and handle network errors by showing a UIAlertView.
- (void)handleError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

//The block you gave to createToken will be called whenever Stripe returns with a token (or error). You'll need to send the token off to your server so you can, for example, charge the card.
- (void)handleToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    [paymentPopup dismiss:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://example.com"]];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   // Handle error
                               }
                           }];
}


@end
