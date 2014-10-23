//
//  GivingViewController.m
//  BarTab
//
//  Created by Sunny Shah on 7/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "GivingViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kMasterColor 0x51B0BD
#define kBackgroundColor 0xE9E9E9
#define kSupportingColor 0x51bdb8
#define kCellColor 0xbd5e51
#define kCellHeight 60
#define kAchievementFont 20.0f
#define kAchievementFontType @"GillSans-Light"


@interface GivingViewController () <UINavigationControllerDelegate>
{
    NSMutableArray *tableData;
    NSMutableArray *friendPictures;
    NSMutableArray *friendEvents;
    NSMutableArray *selectedVenues;
    NSMutableArray *eventTimes;
    
    NSString *selectedValue;
    CGRect screenRect;
    
    //New Gift Giving Screen
    NSMutableArray* tableRowSelected;
    NSMutableDictionary* cellToViewItems;
    UIButton *giftOKButton;
    UIButton *giftCancelButton;
    UIImageView* martiniHelper1;
    UIImageView* martiniHelper2;
    UIImageView* martiniHelper3;
    UISlider* martiniSliderHelper;
    
    //Card + Chocolate Screen
    BOOL cardSelected;
    BOOL chocolateSelected;
    UIButton* tempCardButtonView;
    UIButton* tempChocolateButtonView;
    
    //Popup Related
    KLCPopup* popup;
    UISlider *slider;
    UILabel *sliderValueLabel;
    BOOL popTipShowing;
    
    //Tab value
    NSString* finalName;
    UILabel *giftValue;
    UITextField* tabValueHere;
    
    //Stripe Trick
    UIView *tableCloth;
    UIView* paymentScreenHelper;
    
    //Disappearing Trick
    UIView *glowingBorder;
    UIButton *profilePictureOverlay;
    int originalY;
    int originalFrameY;
    int originalTableFrameY;
    bool fixedOriginalY;
    float tableHomeY;
    float fixedBottomDistance;
    float originalGlowingBorderY;
    float originalGlowingBorderFrameY;
    
    //For Nav Bar + Buttons
    UIView* mainNavBar;
    float mainNavBarOriginY;
    
    //Current Dictionary
    NSDictionary* selectedCellInfo;
    
    
    /**NEW GIVING SCREEN--WITH CONTACTS**/
    UIImageView* martiniImageView1;
    UIImageView* martiniImageView2;
    UIImageView* martiniImageView3;
    UILabel* description;
    
    
    //Contact related
    NSMutableDictionary* allContacts;
    NSString *selectedContactFirstName;
    NSString *selectedContactLastName;
    NSString *selectedContactPhoneNumber;
    
    //Transaction MGMT
    KLCPopup* confirmTransaction;
    
    //SEARCH STUFF
@private
    NSArray *objects;
    NSArray *searchedData;
    BOOL isFiltered;
}

@end

@implementation GivingViewController

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
    //[self startActivityIndicator];
    //[self populateFriendIDFromStatus]; //sets off a chain of events
    
    /***NEW GIFT GIVING SCREEN***/
    self.view.backgroundColor = UIColorFromRGB(kBackgroundColor);
    allContacts = [[NSMutableDictionary alloc]init];
    
    originalY=0.0;
    originalTableFrameY=0.0;
    fixedOriginalY=false;
    tableHomeY = self.infoTable.frame.origin.y;
    screenRect = [[UIScreen mainScreen] bounds];
    fixedBottomDistance = screenRect.size.height - tableHomeY - self.infoTable.frame.size.height;
    [self loadMainNavBar];
    tableData = [[NSMutableArray alloc]init];
    
    [self getAllContacts];
    
    //Add Home Drink View
    [self setBackgroundImage:@"bar bg image.png"];
    //[self addDescription:[NSString stringWithFormat:@"Fill %@'s bar tab",@"Sunny"]];
    [self addDescription:[NSString stringWithFormat:@"$0"]];
    [self addButtons];
    
    //Add contacts
    NSArray* temp = [self getAllContacts];
    for(int i=0; i<temp.count; i++){
        [tableData addObject:[NSString stringWithFormat:@"%@ %@",[[temp objectAtIndex:i] firstNames],[[temp objectAtIndex:i] lastNames]]];
    }
    //objects = tableData;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)setBackgroundImage:(NSString*)name
{
    UIImageView* backgroundImage = [[UIImageView alloc]initWithFrame:self.homeDrinkView.frame];
    [backgroundImage setImage:[UIImage imageNamed:name]];
    [self.homeDrinkView addSubview:backgroundImage];
}

-(void)addButtons
{
    
    /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     button.frame = CGRectMake(0, screenRect.size.height*0.85, screenRect.size.width*0.85, screenRect.size.height*0.10);
     NSString *imageName = [NSString stringWithFormat:@"send_button.png"];
     UIImage *btnImage = [UIImage imageNamed:imageName];
     [button setImage:btnImage forState:UIControlStateNormal];
     [button addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
     */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, screenRect.size.height*0.91, screenRect.size.width, screenRect.size.height*0.09);
    [button setTitle:@"Send Gift Now" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTintColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont fontWithName:kAchievementFontType size:30];
    [button setBackgroundColor:UIColorFromRGB(kMasterColor)];
    [self.view addSubview:button];
    
    UISlider *martiniSlider = [[UISlider alloc] initWithFrame:CGRectMake(20,self.homeDrinkView.frame.size.height*0.85,self.homeDrinkView.frame.size.width*0.7,60)];
    [martiniSlider addTarget:self action:@selector(martiniValueChanged:) forControlEvents:UIControlEventValueChanged];
    martiniSlider.minimumValue = 0;
    martiniSlider.maximumValue = 100;
    martiniSlider.continuous = YES;
    martiniSlider.tintColor = UIColorFromRGB(kSupportingColor);
    martiniSlider.thumbTintColor = UIColorFromRGB(kSupportingColor);
    [self.homeDrinkView addSubview:martiniSlider];
    
    martiniImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView1.frame = CGRectMake((self.homeDrinkView.frame.size.width/2)-(0.5*100),screenRect.size.height*0.18,100,100);
    [self.homeDrinkView addSubview:martiniImageView1];
    
    martiniImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView2.frame = CGRectMake(screenRect.size.width,screenRect.size.height*0.18,100,100);
    [self.homeDrinkView addSubview:martiniImageView2];
    
    martiniImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView3.frame = CGRectMake(screenRect.size.width,screenRect.size.height*0.18,100,100);
    [self.homeDrinkView addSubview:martiniImageView3];
}

-(void)martiniValueChanged:(id)sender
{
    UISlider* martiniSliderHelper = (UISlider*)sender;
    description.text = [NSString stringWithFormat:@"$%.0f",martiniSliderHelper.value];
    
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
    //check if credit card is linked to account- if not, prompt for info
    
    //Pop up confirmation screen
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColorFromRGB(kCellColor);
    contentView.frame = CGRectMake(20, screenRect.size.height*0.3, screenRect.size.width-40, screenRect.size.height*0.22);
    
    UILabel* confirmationText = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, contentView.frame.size.width-40, contentView.frame.size.height*0.4)];
    confirmationText.text = [NSString stringWithFormat:@"Would you like to send %@ a %@ bar tab?",selectedContactFirstName, description.text];
    [confirmationText setFont:[UIFont fontWithName:kAchievementFontType size:20]];
    [confirmationText setTextColor:[UIColor whiteColor]];
    confirmationText.numberOfLines=0;
    confirmationText.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:confirmationText];
    
    //Add Save + Cancel Buttons
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton addTarget:self
                     action:@selector(cancelTransaction:)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(contentView.frame.origin.x,screenRect.size.height*0.13,contentView.frame.size.width*0.5,50);
    //[cancelButton setBackgroundColor:UIColorFromRGB(kBoxColor2)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentView addSubview:cancelButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton addTarget:self
                   action:@selector(continueTransaction:)
         forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Continue" forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(contentView.frame.size.width*0.5,screenRect.size.height*0.13,contentView.frame.size.width*0.5,50);
    //[saveButton setBackgroundColor:UIColorFromRGB(kBoxColor1)];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentView addSubview:saveButton];
    
    confirmTransaction = [KLCPopup popupWithContentView:contentView];
    [confirmTransaction show];
    
    
    /*
     BOOL valid = YES;
     if(valid){
     //Convert desc to int
     NSString *originalString = description.text;
     NSString *numberString;
     NSScanner *scanner = [NSScanner scannerWithString:originalString];
     NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
     [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
     [scanner scanCharactersFromSet:numbers intoString:&numberString];
     NSLog(@"Bar tab sent to %@ at %@ worth $%li", selectedContactFirstName, selectedContactPhoneNumber, (long)[numberString integerValue]);
     // Create the HUD object; view can be a UIImageView, an icon... you name it
     UIView* tempView = [[UIView alloc]initWithFrame:CGRectMake(0,0,50,20)];
     BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithView:tempView
     text:@"Approved"];
     hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
     
     //SEND THE REQUEST
     ServerCalls *drinkGiftRequest = [[ServerCalls alloc]init];
     NSLog(@"User auth: %@", [drinkGiftRequest userAuthToken]);
     [drinkGiftRequest postGift:[drinkGiftRequest userAuthToken] :@"drinks" :selectedContactPhoneNumber :numberString];
     
     // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
     [self.view addSubview:hud];
     [hud presentWithDuration:1.0f speed:0.5f inView:self completion:^{
     [hud removeFromSuperview];
     //[self performSelector:@selector(backButtonPressed:) withObject:self];
     }];
     }else{
     UIView* tempView = [[UIView alloc]initWithFrame:CGRectMake(0,0,50,20)];
     BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithView:tempView
     text:@"Not Approved"];
     hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
     
     // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
     [self.view addSubview:hud];
     [hud presentWithDuration:1.0f speed:0.5f inView:self completion:^{
     [hud removeFromSuperview];
     
     }];
     NSLog(@"Bar tab not sent");
     }
     */
}

-(void)continueTransaction:(id)sender{
    //Send Abhi Stripe token
    
}

-(void)cancelTransaction:(id)sender{
    //Future: Store details to help with future transactions
    [confirmTransaction removeFromSuperview];
}

-(void)addDescription:(NSString*)text
{
    description = [[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width*0.68,screenRect.size.height*0.43,screenRect.size.width*0.4, screenRect.size.height*0.1)];
    description.text = text;
    description.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f]; //Mess with font
    description.numberOfLines = 1;
    description.adjustsFontSizeToFitWidth = YES;
    description.adjustsLetterSpacingToFitWidth = YES;
    description.minimumScaleFactor = 10.0f/12.0f;
    description.clipsToBounds = YES;
    description.backgroundColor = [UIColor clearColor];
    description.textColor = [UIColor whiteColor];
    description.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:description];
}



-(void)chocolateButtonPressed:(id)sender
{
    NSLog(@"Chocolate pressed");
    ChocolateGiftScreen* chocGiftScreen = [[ChocolateGiftScreen alloc] initWithFrame:CGRectMake(0,mainNavBar.frame.size.height * 0.5,screenRect.size.width,screenRect.size.height) andADictionary:selectedCellInfo];
    [self.view addSubview:chocGiftScreen];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

-(void)roseButtonPressed:(id)sender
{
    RoseGiftScreen *roseGiftScreen = [[RoseGiftScreen alloc] initWithFrame:self.view.frame andADictionary:selectedCellInfo];
    [self.view addSubview:roseGiftScreen];
    
    //    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    //    [roseGiftScreen addGestureRecognizer:pan];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}



-(void)drinkButtonPressed:(id)sender
{
    NSLog(@"Drink pressed");
    DrinkGiftScreen* drinkGiftScreen = [[DrinkGiftScreen alloc] initWithFrame:CGRectMake(0,mainNavBar.frame.size.height * 0.5,screenRect.size.width,screenRect.size.height) andADictionary:selectedCellInfo];
    [self.view addSubview:drinkGiftScreen];
    
    //    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    //    [drinkGiftScreen addGestureRecognizer:pan];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}


-(void)handleRefresh:(id)sender{
    NSLog(@"Refresh handling...");
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
    NSString *imageName = [NSString stringWithFormat:@"settings_solid.png"];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [profPicButton setImage:btnImage forState:UIControlStateNormal];
    [profPicButton addTarget:self action:@selector(profilePictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:profPicButton];
    
    UIImageView*giftButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    giftButton.frame = CGRectMake(half-(90*1.2*0.5), stdYoffset, 90*1.5, 40*1.1);
    [mainNavBar addSubview:giftButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(screenRect.size.width - 60, stdYoffset, 40, 40);
    imageName = [NSString stringWithFormat:@"gift_solid.png"];
    btnImage = [UIImage imageNamed:imageName];
    [searchButton setImage:btnImage forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:searchButton];
    
    [mainNavBar setBackgroundColor:UIColorFromRGB(kMasterColor)];
    
    [self.view addSubview:mainNavBar];
    
    mainNavBarOriginY = mainNavBar.frame.origin.y;
}


//NAV BAR BUTTON FUNCTIONS
-(void)profilePictureButtonPressed:(id)sender{
    
    /*
     MasterRootViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterRootViewController"];
     vc.startingIndex = @"0";
     vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     [self presentViewController:vc animated:YES completion:NULL];
     */
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)searchButtonPressed:(id)sender{
    /*
     MasterRootViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterRootViewController"];
     vc.startingIndex = @"2";
     vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     [self presentViewController:vc animated:YES completion:NULL];
     */
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ReceivingViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

//STRIPE INTEGRATION
- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    // Toggle navigation, for example
    
    NSLog(@"Valid card");
    self.saveButton.enabled = valid;
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
    [self.stripeView removeFromSuperview];
    [tableCloth removeFromSuperview];
    [self loadMainNavBar];
    
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


//Search
- (IBAction)buttonPressed:(id)sender {
    NSLog(@"Search button pressed");
}

-(void)selectedRow:(int)row withString:(NSString *)text{
    
    NSLog(@"%d",row);
    // lblIndex.text = [NSString stringWithFormat:@"%d",row];
    // lblText.text = text;
    
}

//TABLE SETUP
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [tableData count];
    return isFiltered ? searchedData.count : tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        // Remove inset of iOS 7 separators.
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    //Configuring cell frame
    cell.layer.borderColor=self.infoTable.backgroundColor.CGColor;
    cell.layer.borderWidth=5.0;
    cell.layer.cornerRadius=15.0f;
    cell.layer.masksToBounds=YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //We could edit this later
    cell.frame = CGRectMake(100, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
    cell.backgroundColor = UIColorFromRGB(kBackgroundColor);
    
    [[cell.contentView viewWithTag:30] removeFromSuperview]; //friend name label
    [[cell.contentView viewWithTag:31] removeFromSuperview]; //achievement label
    [[cell.contentView viewWithTag:32] removeFromSuperview]; //profile picture
    [[cell.contentView viewWithTag:33] removeFromSuperview]; //money label
    [[cell.contentView viewWithTag:34] removeFromSuperview]; //circle slider
    [[cell.contentView viewWithTag:35] removeFromSuperview]; //martini imageview
    [[cell.contentView viewWithTag:36] removeFromSuperview]; //martini slider
    [[cell.contentView viewWithTag:37] removeFromSuperview]; //martini imageview 2
    [[cell.contentView viewWithTag:38] removeFromSuperview]; //martini imageview 3
    
    //Locked in CGRect position
    
    cell.textLabel.text=@"";
    cell.detailTextLabel.text = @"";
    
    //Rounded tablecloth
    UIView* whiteRoundedCloth = [[UIView alloc]initWithFrame:CGRectMake(4,0,150,150)];
    [whiteRoundedCloth setBackgroundColor:[UIColor whiteColor]];
    whiteRoundedCloth.layer.cornerRadius = whiteRoundedCloth.frame.size.height * 0.5;
    whiteRoundedCloth.layer.masksToBounds = YES;
    //[cell.contentView addSubview:whiteRoundedCloth];
    
    //White Tablecloth
    UIView* whiteTableCloth = [[UIView alloc]initWithFrame:CGRectMake(0,0,screenRect.size.width,150)];
    [whiteTableCloth setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:whiteTableCloth];
    
    //UILabel *friendName = [[UILabel alloc] initWithFrame:CGRectMake(whiteTableCloth.frame.origin.x,95,screenRect.size.width,20)];
    UILabel *friendName = [[UILabel alloc] initWithFrame:CGRectMake(whiteTableCloth.frame.origin.x,0,screenRect.size.width*0.5,30)];
    NSString* nameHelper = [tableData objectAtIndex:indexPath.row];
    //friendName.text = [tableData objectAtIndex:indexPath.row];
    friendName.text = isFiltered ? searchedData[indexPath.row] : tableData[indexPath.row];
    friendName.textColor = UIColorFromRGB(kMasterColor);
    //friendName.textColor = [UIColor whiteColor];
    
    /*
     float red = arc4random() % 255 / 255.0;
     float green = arc4random() % 255 / 255.0;
     float blue = arc4random() % 255 / 255.0;
     UIColor *color = [UIColor colorWithRed:0 green:green blue:blue alpha:1.0];
     */
    // UIColor *color = UIColorFromRGB(kCellColor);
    //friendName.backgroundColor=UIColorFromRGB(kCellColor);
    
    
    friendName.numberOfLines = 2;
    //friendName.transform = CGAffineTransformMakeRotation((M_PI)/2);
    friendName.textAlignment = UITextAlignmentCenter;
    int fontSize = [self sizeLabel:friendName toRect:cell.contentView.frame];
    //int fontSize= 20;
    friendName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    friendName.tag=30;
    [cell.contentView addSubview:friendName];
    
    //Achievement
    UILabel *achievement= [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.44,15,cell.frame.size.width*0.5,75)];
    achievement.text = [friendEvents objectAtIndex:indexPath.row];
    achievement.lineBreakMode = NSLineBreakByWordWrapping;
    achievement.numberOfLines = 0;
    achievement.backgroundColor=[UIColor clearColor];
    if([self quickCheckSizeLabel:achievement toRect:CGRectMake(cell.frame.size.width*0.44,15,cell.frame.size.width*0.5,75)]){
        achievement.font= [UIFont fontWithName:kAchievementFontType size:kAchievementFont];
    }else{
        achievement.font = [UIFont fontWithName:kAchievementFontType size:[self sizeLabel:achievement toRect:CGRectMake(cell.frame.size.width*0.44,15,cell.frame.size.width*0.5,75)]];
    }
    achievement.tag=31;
    [cell.contentView addSubview:achievement];
    
    //https://www.dropbox.com/s/fhy0abdvfwj4f8h/Screenshot%202014-08-21%2023.13.25.png
    /*
     UILabel *friendName = [[UILabel alloc] initWithFrame:CGRectMake(whiteTableCloth.frame.origin.x,0,screenRect.size
     .width,20)];
     NSString* nameHelper = [tableData objectAtIndex:indexPath.row];
     friendName.text = [NSString stringWithFormat:@"%@",[[nameHelper componentsSeparatedByString:@" "]objectAtIndex:0]];
     friendName.textColor = [UIColor whiteColor];
     friendName.backgroundColor=UIColorFromRGB(kMasterColor);
     friendName.numberOfLines = 1;
     //friendName.transform = CGAffineTransformMakeRotation((M_PI)/2);
     friendName.textAlignment = UITextAlignmentCenter;
     int fontSize = [self sizeLabel:friendName toRect:CGRectMake(whiteTableCloth.frame.origin.x,0,screenRect.size
     .width,20)];
     friendName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
     friendName.tag=30;
     [cell.contentView addSubview:friendName];
     
     //Achievement
     UILabel *achievement= [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.44,25,cell.frame.size.width*0.4,94)];
     achievement.text = [friendEvents objectAtIndex:indexPath.row];
     achievement.lineBreakMode = NSLineBreakByWordWrapping;
     achievement.numberOfLines = 0;
     achievement.backgroundColor=[UIColor clearColor];
     //achievement.font= [UIFont fontWithName:@"GillSans-LightItalic" size:15.0f];
     achievement.font = [UIFont fontWithName:@"GillSans-LightItalic" size:[self sizeLabel:achievement toRect:CGRectMake(cell.frame.size.width*0.44,25,cell.frame.size.width*0.4,94)]];
     achievement.tag=31;
     [cell.contentView addSubview:achievement];
     */
    
    //https://www.dropbox.com/s/mt9o80ro1vcrzjl/Screenshot%202014-08-21%2023.08.10.png
    /*
     UILabel *friendName = [[UILabel alloc] initWithFrame:CGRectMake(screenRect.size.width*0.87,0,150,50)];
     NSString* nameHelper = [tableData objectAtIndex:indexPath.row];
     friendName.text = [NSString stringWithFormat:@"%@",[[nameHelper componentsSeparatedByString:@" "]objectAtIndex:0]];
     friendName.textColor = [UIColor whiteColor];
     friendName.backgroundColor=UIColorFromRGB(kMasterColor);
     friendName.numberOfLines = 1;
     friendName.transform = CGAffineTransformMakeRotation((M_PI)/2);
     friendName.textAlignment = UITextAlignmentCenter;
     int fontSize = [self sizeLabel:friendName toRect:CGRectMake(screenRect.size.width*0.87,0,50*0.8,150*0.8)];
     friendName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
     friendName.tag=30;
     [cell.contentView addSubview:friendName];
     
     //Achievement
     UILabel *achievement= [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.44,10,cell.frame.size.width*0.4,94)];
     achievement.text = [friendEvents objectAtIndex:indexPath.row];
     achievement.lineBreakMode = NSLineBreakByWordWrapping;
     achievement.numberOfLines = 0;
     //achievement.textAlignment=UITextAlignmentLeft;
     //achievement.font= [UIFont fontWithName:@"OriyaSangamMN" size:15.0f];
     achievement.backgroundColor=[UIColor clearColor];
     achievement.font = [UIFont fontWithName:@"OriyaSangamMN" size:[self sizeLabel:achievement toRect:CGRectMake(cell.frame.size.width*0.44,10,cell.frame.size.width*0.4,94)]];
     achievement.tag=31;
     [cell.contentView addSubview:achievement];
     */
    
    //Profile picture in circle
    UIImage* image = [[UIImage alloc] init];
    image = [UIImage imageNamed:[friendPictures objectAtIndex:indexPath.row]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(10,5,110,110);
    imageView.layer.cornerRadius = imageView.frame.size.height*0.5;;
    imageView.layer.masksToBounds = YES;
    //imageView.layer.borderWidth = 10.0f;
    //imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.shadowRadius=10.0f;
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.tag=32;
    [cell.contentView addSubview:imageView];
    
    //Martini Glasses
    UIImageView* martiniImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView.frame = CGRectMake((self.view.frame.size.width/2)-(0.5*100),60,100,100);
    martiniImageView.hidden=YES;
    martiniImageView.tag = 35;
    [cell.contentView addSubview:martiniImageView];
    
    UIImageView* martiniImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView2.frame = CGRectMake(screenRect.size.width,60,100,100);
    martiniImageView2.hidden=YES;
    martiniImageView2.tag = 37;
    [cell.contentView addSubview:martiniImageView2];
    
    UIImageView* martiniImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"martini_icon1.png"]];
    martiniImageView3.frame = CGRectMake(screenRect.size.width,60,100,100);
    martiniImageView3.hidden=YES;
    martiniImageView3.tag = 38;
    [cell.contentView addSubview:martiniImageView3];
    
    //Martini Slider
    // UISlider *martiniSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, martiniImageView.frame.size.height+martiniImageView.frame.origin.y+10, screenRect.size.width-120, 40)];
    UISlider *martiniSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, martiniImageView.frame.size.height+martiniImageView.frame.origin.y+100, screenRect.size.width-120, 40)];
    [martiniSlider addTarget:self action:@selector(martiniValueChanged:) forControlEvents:UIControlEventValueChanged];
    martiniSlider.minimumValue = 0;
    martiniSlider.maximumValue = 100;
    martiniSlider.continuous = YES;
    martiniSlider.hidden=YES;
    martiniSlider.tag = 36;
    [cell.contentView addSubview:martiniSlider];
    
    //Green Cell Overlay on Click
    UIView* greenTableCloth = [[UIView alloc]initWithFrame:CGRectMake(0,0,screenRect.size.width,kCellHeight)];
    [greenTableCloth setBackgroundColor:UIColorFromRGB(kMasterColor)];
    greenTableCloth.alpha=0.95f;
    greenTableCloth.hidden=YES;
    
    UIButton *chocolateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chocolateButton.frame = CGRectMake(20,
                                       greenTableCloth.frame.size.height*0.5 - (0.5*89*0.5),
                                       152*0.5,
                                       89*0.5);
    NSString *imageName = [NSString stringWithFormat:@"chocolate_icon.png"];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [chocolateButton setImage:btnImage forState:UIControlStateNormal];
    [chocolateButton addTarget:self action:@selector(chocolateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [greenTableCloth addSubview:chocolateButton];
    
    UIButton *roseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    roseButton.frame = CGRectMake(greenTableCloth.frame.size.width*0.5-(0.5*104*0.5),
                                  greenTableCloth.frame.size.height*0.5 - (0.5*97*0.5),
                                  104*0.5,
                                  97*0.5);
    NSString *imageName1 = [NSString stringWithFormat:@"rose_icon.png"];
    UIImage *btnImage1 = [UIImage imageNamed:imageName1];
    [roseButton setImage:btnImage1 forState:UIControlStateNormal];
    [roseButton addTarget:self action:@selector(roseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [greenTableCloth addSubview:roseButton];
    
    UIButton *drinkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    drinkButton.frame = CGRectMake(greenTableCloth.frame.size.width-(40+87*0.5),
                                   greenTableCloth.frame.size.height*0.5 - (0.5*100*0.5),
                                   87*0.5,
                                   100*0.5);
    NSString *imageName2 = [NSString stringWithFormat:@"martini_icon.png"];
    UIImage *btnImage2 = [UIImage imageNamed:imageName2];
    [drinkButton setImage:btnImage2 forState:UIControlStateNormal];
    [drinkButton addTarget:self action:@selector(drinkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [greenTableCloth addSubview:drinkButton];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          friendName, @"friendName",
                          achievement, @"achievement",
                          imageView, @"imageView",
                          martiniImageView, @"martiniImageView",
                          martiniSlider, @"martiniSlider",
                          martiniImageView2, @"martiniImageView2",
                          martiniImageView3, @"martiniImageView3",
                          greenTableCloth, @"greenTableCloth",
                          @"0",@"giftStatus",
                          @"Custom Message",@"customMessage",
                          nil];
    
    NSMutableArray* viewObjects = [[NSMutableArray alloc]initWithObjects:friendName, achievement,imageView, martiniImageView, martiniSlider, martiniImageView2, martiniImageView3, dict, nil];
    
    [cellToViewItems setObject:viewObjects forKey:[NSNumber numberWithInt:indexPath.row]];
    
    return cell;
}


- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)switchSelectedStatusByIndexPath:(NSIndexPath*)indexPath
{
    BOOL current = [[tableRowSelected objectAtIndex:indexPath.row]boolValue];
    [tableRowSelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!current]];
    self.selectedRowIndex = indexPath;
    [self.infoTable beginUpdates];
    [self.infoTable endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Update master dictionary values
    selectedCellInfo = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:7];
    selectedValue = [tableData objectAtIndex:indexPath.row];
    UITableViewCell* tempCell = [tableView cellForRowAtIndexPath:indexPath];
    
    BOOL current = [[tableRowSelected objectAtIndex:indexPath.row]boolValue];
    [tableRowSelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!current]];
    
    finalName = [tableData objectAtIndex:indexPath.row];
    
    if([[tableRowSelected objectAtIndex:indexPath.row]boolValue]){
        
        NSDictionary* dict = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:7];
        UIView* greenView = [dict objectForKey:@"greenTableCloth"];
        greenView.hidden=NO;
        [tempCell addSubview:greenView];
        
    }else{
        NSDictionary* dict = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:7];
        UIView* greenView = [dict objectForKey:@"greenTableCloth"];
        greenView.hidden=YES;
        [greenView removeFromSuperview];
    }
    
    if(self.searchBar.text.length >0){
        NSLog(@"Test contact: %@", [searchedData objectAtIndex:indexPath.row]);
    }
    else{
        NSLog(@"Test contact %@ %@ @ %@",
              [(Contact*)[allContacts objectForKey:[NSString stringWithFormat:@"%li",(long)indexPath.row]] firstName],
              [(Contact*)[allContacts objectForKey:[NSString stringWithFormat:@"%li",(long)indexPath.row]] lastName],
              [(Contact*)[allContacts objectForKey:[NSString stringWithFormat:@"%li",(long)indexPath.row]] mobileNumber]
              );
    }
    
    selectedContactFirstName = [(Contact*)[allContacts objectForKey:[NSString stringWithFormat:@"%li",(long)indexPath.row]] firstName];
    selectedContactLastName = [(Contact*)[allContacts objectForKey:[NSString stringWithFormat:@"%li",(long)indexPath.row]] lastName];
    selectedContactPhoneNumber = [(Contact*)[allContacts objectForKey:[NSString stringWithFormat:@"%li",(long)indexPath.row]] mobileNumber];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Logic for dynamic heights
    
    return kCellHeight;
}


//Textfield editing
#pragma mark TextFieldDelegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self performAnimations:20];
}

-(void)performAnimations:(float)bywhat
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    //FOR POPUP VIEW!!!
    //popup.frame = CGRectMake(popup.frame.origin.x, (popup.frame.origin.y -bywhat), popup.frame.size.width, popup.frame.size.height);
    self.view.frame=CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y -bywhat), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    popup.frame=CGRectMake(0, 0, popup.frame.size.width, popup.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard {
    //Nothing yet =)
    [self.view endEditing:YES];
}

//FOR TRANSITION EFFECTS!!

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    NSLog(@"Inside transitioning method");
    if (operation != UINavigationControllerOperationNone) {
        // Return your preferred transition operation
        return [AMWaveTransition transitionWithOperation:operation];
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
    [self.interactive attachInteractiveGestureToNavigationController:self.navigationController];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.interactive detachInteractiveGesture];
}

- (NSArray*)visibleCells
{
    NSLog(@"Inside visible cells");
    return [self.infoTable visibleCells];
}

- (void)dealloc
{
    NSLog(@"Inside dealloc");
    [self.navigationController setDelegate:nil];
}

//SCROLLING RELATED
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    aScrollView.showsVerticalScrollIndicator=NO;
    
    //Disappearing trick!
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    
    float numerator = offset.y;
    int denominator = bounds.size.height;
    float percentHidden = (numerator*1.0)/(denominator*1.0);
    
    /*
     if(percentHidden>-20.0){
     
     mainNavBar.frame = CGRectMake(mainNavBar.frame.origin.x,
     mainNavBarOriginY-(mainNavBar.frame.size.height*(2*percentHidden)),
     mainNavBar.frame.size.width,
     mainNavBar.frame.size.height);
     mainNavBar.alpha=1-percentHidden;
     
     CGRect tvbounds = [self.infoTable bounds];
     float new = tableHomeY*(1-(1.8*percentHidden));
     float bottomCorrection = screenRect.size.height - fixedBottomDistance - self.infoTable.frame.size.height - new;
     
     if(tvbounds.origin.y<300 && new>20) self.infoTable.frame =CGRectMake(tvbounds.origin.x, new, tvbounds.size.width, tvbounds.size.height+bottomCorrection);
     }
     */
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        // NSLog(@"load more rows");
    }
}

//ALLOW ROWS TO BE DELETED!!!

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /*
         [tableData removeObjectAtIndex:[indexPath row]];
         
         // delete the row from the data source
         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
         */
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    static UIAttachmentBehavior *attachment;
    static CGPoint               startCenter;
    
    // variables for calculating angular velocity
    
    static CFAbsoluteTime        lastTime;
    static CGFloat               lastAngle;
    static CGFloat               angularVelocity;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        [self.animator removeAllBehaviors];
        
        startCenter = gesture.view.center;
        
        // calculate the center offset and anchor point
        
        CGPoint pointWithinAnimatedView = [gesture locationInView:gesture.view];
        
        UIOffset offset = UIOffsetMake(pointWithinAnimatedView.x - gesture.view.bounds.size.width / 2.0,
                                       pointWithinAnimatedView.y - gesture.view.bounds.size.height / 2.0);
        
        CGPoint anchor = [gesture locationInView:gesture.view.superview];
        
        // create attachment behavior
        
        attachment = [[UIAttachmentBehavior alloc] initWithItem:gesture.view
                                               offsetFromCenter:offset
                                               attachedToAnchor:anchor];
        
        // code to calculate angular velocity (seems curious that I have to calculate this myself, but I can if I have to)
        
        lastTime = CFAbsoluteTimeGetCurrent();
        lastAngle = [self angleOfView:gesture.view];
        
        attachment.action = ^{
            CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
            CGFloat angle = [self angleOfView:gesture.view];
            if (time > lastTime) {
                angularVelocity = (angle - lastAngle) / (time - lastTime);
                lastTime = time;
                lastAngle = angle;
            }
        };
        
        // add attachment behavior
        
        [self.animator addBehavior:attachment];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // as user makes gesture, update attachment behavior's anchor point, achieving drag 'n' rotate
        
        CGPoint anchor = [gesture locationInView:gesture.view.superview];
        attachment.anchorPoint = anchor;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.animator removeAllBehaviors];
        
        CGPoint velocity = [gesture velocityInView:gesture.view.superview];
        
        // if we aren't dragging it down, just snap it back and quit
        
        if (fabs(atan2(velocity.y, velocity.x) - M_PI_2) > M_PI_4) {
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
            [self.animator addBehavior:snap];
            
            return;
        }
        
        // otherwise, create UIDynamicItemBehavior that carries on animation from where the gesture left off (notably linear and angular velocity)
        
        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[gesture.view]];
        [dynamic addLinearVelocity:velocity forItem:gesture.view];
        [dynamic addAngularVelocity:angularVelocity forItem:gesture.view];
        [dynamic setAngularResistance:2];
        
        // when the view no longer intersects with its superview, go ahead and remove it
        
        dynamic.action = ^{
            if (!CGRectIntersectsRect(gesture.view.superview.bounds, gesture.view.frame)) {
                [self.animator removeAllBehaviors];
                [gesture.view removeFromSuperview];
                
                //[[[UIAlertView alloc] initWithTitle:nil message:@"View is gone!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        };
        [self.animator addBehavior:dynamic];
        
        // add a little gravity so it accelerates off the screen (in case user gesture was slow)
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[gesture.view]];
        gravity.magnitude = 0.7;
        [self.animator addBehavior:gravity];
    }
}

- (CGFloat)angleOfView:(UIView *)view
{
    // http://stackoverflow.com/a/2051861/1271826
    
    return atan2(view.transform.b, view.transform.a);
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

//ADDRESS
-(NSArray *)getAllContacts
{
    
    CFErrorRef *error = nil;
    
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
#ifdef DEBUG
        NSLog(@"Fetching contact info ----> ");
#endif
        
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
        
        
        for (int i = 0; i < nPeople; i++)
        {
            ContactsData *contacts = [ContactsData new];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name and Last Name
            
            contacts.firstNames = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            
            contacts.lastNames =  (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
            
            if (!contacts.firstNames) {
                contacts.firstNames = @"";
            }
            if (!contacts.lastNames) {
                contacts.lastNames = @"";
            }
            
            // get contacts picture, if pic doesn't exists, show standart one
            
            NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
            contacts.image = [UIImage imageWithData:imgData];
            if (!contacts.image) {
                contacts.image = [UIImage imageNamed:@"NOIMG.png"];
            }
            //get Phone Numbers
            
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                [phoneNumbers addObject:phoneNumber];
                
                //NSLog(@"All numbers %@", phoneNumbers);
                
            }
            
            
            [contacts setNumbers:phoneNumbers];
            
            //get Contact email
            
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                NSString *contactEmail = (__bridge NSString *)contactEmailRef;
                
                [contactEmails addObject:contactEmail];
                // NSLog(@"All emails are:%@", contactEmails);
                
            }
            
            [contacts setEmails:contactEmails];
            
            
            
            [items addObject:contacts];
            
#ifdef DEBUG
            //NSLog(@"Person is: %@", contacts.firstNames);
            //NSLog(@"Phones are: %@", contacts.numbers);
            //NSLog(@"Email is:%@", contacts.emails);
#endif
            //Initialize Contact Object
            Contact *newContact = [[Contact alloc]init];
            newContact.firstName = contacts.firstNames;
            newContact.lastName = contacts.lastNames;
            newContact.otherNumbers = contacts.numbers;
            
            //UNCLEAR HOW TO GET MOBILE NUMBER!!!!
            if(newContact.otherNumbers.count > 0) newContact.mobileNumber=[newContact.otherNumbers objectAtIndex:0];
            [allContacts setObject:newContact forKey:[NSString stringWithFormat:@"%i",i]];
            
            
            
        }
        return items;
        
        
        
    } else {
#ifdef DEBUG
        NSLog(@"Cannot fetch Contacts :( ");
#endif
        return NO;
        
        
    }
    
}

//SEARCH
#pragma mark - SearchBar Delegate -

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0)
        isFiltered = NO;
    else
        isFiltered = YES;
    
    NSMutableArray *tmpSearched = [[NSMutableArray alloc] init];
    
    for (NSString *string in tableData) {
        if(searchText.length <= string.length){
            NSString* tempString = [string substringToIndex:searchText.length];
            //we are going for case insensitive search here
            NSRange range = [tempString rangeOfString:searchText
                                              options:NSCaseInsensitiveSearch];
            
            if (range.location != NSNotFound)
                [tmpSearched addObject:string];
        }
    }
    
    searchedData = tmpSearched.copy;
    
    /*
    [tableData removeAllObjects];
    for(int i=0; i<searchedData.count; i++){
        [tableData addObject:[NSString stringWithFormat:@"%@ %@",[[searchedData objectAtIndex:i] firstNames],[[searchedData objectAtIndex:i] lastNames]]];
    }
    */
    
    [self.infoTable reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBar button clicked");
    [self dismissKeyboard];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self performAnimations:150];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self performAnimations:-150];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}





/*****MEMORY RELATED******/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
