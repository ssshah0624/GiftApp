//
//  GivingViewController.m
//  BarTab
//
//  Created by Sunny Shah on 7/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "GivingViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#define kMasterColor 0x3cb878
//#define kSupportingColor 0x5dca92
#define kMasterColor 0x51B0BD
#define kBackgroundColor 0xE9E9E9
#define kSupportingColor 0x51bdb8
#define kCellHeight 120
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
    EFCircularSlider* sliderHelper;
    TOMSMorphingLabel* moneyHelper;
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
    AMPopTip* popTip0;
    
    //Tab value
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
    tableData =  [NSMutableArray arrayWithObjects:
                  @"Abhi Ramesh",
                  @"Edward Lando",
                  @"Varshil Patel",
                  @"Nisha Shah",
                  @"Shiv Patel",
                  @"Nilesh Kavthekar",
                  @"Max Wolff",
                  @"Krishan Nagin",
                  @"Apoorva Shah",
                  nil];
    friendPictures = [NSMutableArray arrayWithObjects:
                      @"sampleAbhiSunny.jpg",
                      @"sampleEdward.jpg",
                      @"sampleVarshil.jpg",
                      @"sampleNisha.jpg",
                      @"shiv.jpg",
                      @"nilesh.jpg",
                      @"max.jpg",
                      @"krishan.jpg",
                      @"apoorva.jpg",
                      nil];
    friendEvents = [NSMutableArray arrayWithObjects:
                    @"Voting has officially begun. Abhi Ramesh for President. Make the Abhious Choice!!!",
                    @"You asked for flying cars and eternal youth. We made Notice 2.0. Under-promise, over-deliver.",
                    @"Goodbye New York, hello San Francisco. Cheers to a new chapter!",
                    @"Congradulations to me...can't believe it's been 4 years",
                    @"Finally legal, 18 years strong. #SigRho18",
                    @"Welcome to Dorm Room Fund Lauren Reeder, Matthew Gibstein, Nilesh Kavthekar and Tim Miller!!",
                    @"Signed @ Insight",
                    @"Bittersweet.. so sad to leave all my wonderful friends at penn, but glad to go home. It's been the four best months of my life",
                    @"First day of dental school! And so begins my addiction to coffee",
                    nil];
    eventTimes = [NSMutableArray arrayWithObjects:@"Today",@"Today",@"Yesterday",@"2 days ago", nil];
    selectedVenues = [NSMutableArray arrayWithObjects:@"City Tap House",@"Churrasco",@"Stroller Pizza",@"Quizne",@"KFC",@"Fabio",@"Excelente", nil];
    
    popTipShowing=false;
    
    self.view.backgroundColor = UIColorFromRGB(kBackgroundColor);
    self.infoTable.backgroundColor = self.view.backgroundColor;
    self.infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTable.separatorColor = [UIColor clearColor];
    self.infoTable.frame = CGRectMake(self.infoTable.frame.origin.x,
                                      self.infoTable.frame.origin.y,
                                      self.infoTable.frame.size.width,
                                      self.infoTable.frame.size.height+self.infoCell.frame.size.height);
    
    self.interactive = [[AMWaveTransition alloc] init];
    
    originalY=0.0;
    originalTableFrameY=0.0;
    fixedOriginalY=false;
    tableHomeY = self.infoTable.frame.origin.y;
    screenRect = [[UIScreen mainScreen] bounds];
    fixedBottomDistance = screenRect.size.height - tableHomeY - self.infoTable.frame.size.height;
    
    BOOL newUser = true;
    if(newUser) [self promptPaymentInfo];
    
    //Configure new gift giving screen
    tableRowSelected = [[NSMutableArray alloc]init];
    int temp = 0;
    while(temp<tableData.count){
        [tableRowSelected addObject:[NSNumber numberWithBool:NO]];
        temp++;
    }
    
    cellToViewItems = [[NSMutableDictionary alloc]init];
    selectedCellInfo = [[NSDictionary alloc]init];
}


-(void)chocolateButtonPressed:(id)sender
{
    NSLog(@"Chocolate pressed");
    ChocolateGiftScreen* chocGiftScreen = [[ChocolateGiftScreen alloc] initWithFrame:CGRectMake(0,mainNavBar.frame.size.height * 0.5,screenRect.size.width,screenRect.size.height) andADictionary:selectedCellInfo];
    [self.view addSubview:chocGiftScreen];
    
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [chocGiftScreen addGestureRecognizer:pan];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

-(void)roseButtonPressed:(id)sender
{
    //RoseGiftScreen *roseGiftScreen = [[RoseGiftScreen alloc] initWithFrame:CGRectMake(0,mainNavBar.frame.size.height * 0.5,screenRect.size.width,screenRect.size.height) andADictionary:selectedCellInfo];
    
    RoseGiftScreen *roseGiftScreen = [[RoseGiftScreen alloc] initWithFrame:self.view.frame andADictionary:selectedCellInfo];
    [self.view addSubview:roseGiftScreen];
    
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [roseGiftScreen addGestureRecognizer:pan];
    
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
    
    UIButton *giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    giftButton.frame = CGRectMake(half-70, stdYoffset, 140, 40);
    imageName = [NSString stringWithFormat:@"logo.png"];
    btnImage = [UIImage imageNamed:imageName];
    [giftButton setImage:btnImage forState:UIControlStateNormal];
    [giftButton addTarget:self action:@selector(giftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    NSLog(@"Settings functionality coming soon =)");
}

-(void)giftButtonPressed:(id)sender{
    NSLog(@"Gift button selected");
    [self performSegueWithIdentifier:@"toReceive" sender:self];
}

-(void)searchButtonPressed:(id)sender{
    NSLog(@"Search functionality coming soon =)");
}

-(void)profilePictureClicked:(id)sender{
    NSLog(@"PROFILE PICTURE CLICKED");
    [self performSegueWithIdentifier:@"toReceive" sender:self];
}

-(void)promptPaymentInfo{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    tableCloth = [[UIView alloc]init];
    tableCloth.frame = CGRectMake(0,0,screenRect.size.width,screenRect.size.height);
    [tableCloth setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tableCloth];
    
    
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,20,290,55)
                                              andKey:@"pk_test_6pRNASCoBOKtIshFeQd4XMUh"];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(screenRect.size.width/2 - 40,120,60,60);
    [btn setTitle:@"Skip" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(paymentInformationSkipped:) forControlEvents:UIControlEventTouchUpInside];
    [tableCloth addSubview:btn];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.saveButton.frame = CGRectMake(screenRect.size.width/2+20,120,60,60);
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.enabled=false;
    [tableCloth addSubview:self.saveButton];
}

-(void)paymentInformationSkipped:(id)sender
{
    NSLog(@"Skip recognized");
    [self.stripeView removeFromSuperview];
    [tableCloth removeFromSuperview];
    
    UIImage *icon = [UIImage imageNamed:@"gift.png"];
    UIColor *color = [UIColor blueColor];
    CBZSplashView *splashView = [[CBZSplashView alloc] initWithIcon:icon backgroundColor:color];
    
    // customize duration, icon size, or icon color here;
    
    [self loadMainNavBar];
    [self.view addSubview:splashView];
    [splashView startAnimation];
    
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
    return [tableData count];
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
    UIView* whiteTableCloth = [[UIView alloc]initWithFrame:CGRectMake(70,0,screenRect.size.width,150)];
    [whiteTableCloth setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:whiteTableCloth];
    
    UILabel *friendName = [[UILabel alloc] initWithFrame:CGRectMake(whiteTableCloth.frame.origin.x,95,screenRect.size
                                                                    .width,20)];
    NSString* nameHelper = [tableData objectAtIndex:indexPath.row];
    friendName.text = [NSString stringWithFormat:@"%@",[[nameHelper componentsSeparatedByString:@" "]objectAtIndex:0]];
    friendName.textColor = [UIColor whiteColor];
    friendName.backgroundColor=UIColorFromRGB(kSupportingColor);
    friendName.numberOfLines = 1;
    //friendName.transform = CGAffineTransformMakeRotation((M_PI)/2);
    friendName.textAlignment = UITextAlignmentCenter;
    int fontSize = [self sizeLabel:friendName toRect:CGRectMake(whiteTableCloth.frame.origin.x,95,screenRect.size
                                                                .width,20)];
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
    
    //Money label
    TOMSMorphingLabel* moneyValueLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 10, 80, 42)];
    moneyValueLabel.font = [UIFont boldSystemFontOfSize:20];
    moneyValueLabel.text = @"$0.00";
    moneyValueLabel.tag = 33;
    moneyValueLabel.hidden=YES;
    [cell.contentView addSubview:moneyValueLabel];
    
    //Circle Slider
    CGRect sliderFrame = CGRectMake((cell.frame.size.width/2)-(0.5*190),50,190,190);
    EFCircularSlider* circularSlider = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    circularSlider.minimumValue=0.0f;
    circularSlider.maximumValue=100.0f;
    circularSlider.lineWidth = 6;
    circularSlider.handleType = doubleCircleWithClosedCenter;
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    circularSlider.handleColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    circularSlider.unfilledColor = [UIColor grayColor];
    [circularSlider setFilledColor:UIColorFromRGB(0x006400)];
    [circularSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    circularSlider.tag=34;
    circularSlider.hidden=YES;
    [cell.contentView addSubview:circularSlider];
    
    
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
    UISlider *martiniSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, martiniImageView.frame.size.height+martiniImageView.frame.origin.y+10, screenRect.size.width-120, 40)];
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
                          moneyValueLabel, @"moneyValueLabel",
                          circularSlider, @"circularSlider",
                          martiniImageView, @"martiniImageView",
                          martiniSlider, @"martiniSlider",
                          martiniImageView2, @"martiniImageView2",
                          martiniImageView3, @"martiniImageView3",
                          greenTableCloth, @"greenTableCloth",
                          @"0",@"giftStatus",
                          @"Custom Message",@"customMessage",
                          nil];
    
    NSMutableArray* viewObjects = [[NSMutableArray alloc]initWithObjects:friendName, achievement,imageView, moneyValueLabel, circularSlider, martiniImageView, martiniSlider, martiniImageView2, martiniImageView3, dict, nil];
    
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
    selectedCellInfo = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:9];
    
    selectedValue = [tableData objectAtIndex:indexPath.row];
    UITableViewCell* tempCell = [tableView cellForRowAtIndexPath:indexPath];
    
    BOOL current = [[tableRowSelected objectAtIndex:indexPath.row]boolValue];
    [tableRowSelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!current]];
    
    if([[tableRowSelected objectAtIndex:indexPath.row]boolValue]){
        
        NSDictionary* dict = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:9];
        UIView* greenView = [dict objectForKey:@"greenTableCloth"];
        greenView.hidden=NO;
        [tempCell addSubview:greenView];
        
    }else{
        NSDictionary* dict = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:9];
        UIView* greenView = [dict objectForKey:@"greenTableCloth"];
        greenView.hidden=YES;
        [greenView removeFromSuperview];
    }
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
    popup.frame = CGRectMake(popup.frame.origin.x, (popup.frame.origin.y -bywhat), popup.frame.size.width, popup.frame.size.height);
    //self.view.frame=CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y -bywhat), self.view.frame.size.width, self.view.frame.size.height);
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


/*****MEMORY RELATED******/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
