//
//  GivingViewController.m
//  BarTab
//
//  Created by Sunny Shah on 7/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "GivingViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


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
    tableData =  [NSMutableArray arrayWithObjects:@"Abhi Ramesh", @"Edward Lando", @"Varshil Patel",@"Nisha Shah", nil];
    friendPictures = [NSMutableArray arrayWithObjects:@"sampleAbhiSunny.jpg", @"sampleEdward.jpg", @"sampleVarshil.jpg",@"sampleNisha.jpg", nil];
    friendEvents = [NSMutableArray arrayWithObjects:@"Dropped out of school...ended up on a yacht!", @"You asked for flying cars and eternal youth. We made Notice 2.0. Under-promise, over-deliver.", @"Cleaned my room!",@"I'm the best sister anyone could ever ask for!", nil];
    eventTimes = [NSMutableArray arrayWithObjects:@"Today",@"Today",@"Yesterday",@"2 days ago", nil];
    
    selectedVenues = [NSMutableArray arrayWithObjects:@"City Tap House",@"Churrasco",@"Stroller Pizza",@"Quizne",@"KFC",@"Fabio",@"Excelente", nil];
    
    popTipShowing=false;

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
    
    self.view.backgroundColor = UIColorFromRGB(0xE9E9E9);
    self.infoTable.backgroundColor = self.view.backgroundColor;
    self.infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTable.separatorColor = [UIColor clearColor];
    
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
}

-(void)roseButtonPressed:(id)sender
{
    NSLog(@"Rose pressed");
    
    RoseGiftScreen *roseGiftScreen = [[RoseGiftScreen alloc] initWithFrame:CGRectMake(0,mainNavBar.frame.size.height * 0.5,screenRect.size.width,screenRect.size.height) andADictionary:selectedCellInfo];
    [self.view addSubview:roseGiftScreen];
}

-(void)drinkButtonPressed:(id)sender
{
    NSLog(@"Drink pressed");
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
    NSArray *persons = [NSArray arrayWithObjects:@"Abhi Ramesh", @"Edward Lando", @"Varshil Patel", nil];
    YHCPickerView *objYHCPickerView = [[YHCPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withNSArray:persons];
    objYHCPickerView.delegate = self;
    [self.view addSubview:objYHCPickerView];
    [objYHCPickerView showPicker];
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
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // Remove inset of iOS 7 separators.
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    //Configuring cell frame
    cell.layer.borderColor=self.infoTable.backgroundColor.CGColor;
    cell.layer.borderWidth=5.0;
    cell.layer.cornerRadius=15.0f;
    cell.layer.masksToBounds=YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //We could edit this later
    
    //Configuring the trigger percentages
    cell.secondTrigger=0.66;
    
    // Configuring the views and colors.
    CGRect helperRectangle = CGRectMake(40,0,130,145);
    
    UIImageView* checkView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"regift1.png"]];
    checkView.frame = helperRectangle;
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIImageView* crossView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"regift1.png"]];
    crossView.frame =helperRectangle;
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    UIImageView* clockView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"martini_white_icon.png"]];
    clockView.frame = CGRectMake(40,0,130,145);
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    UIImageView* listView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hallmark_card_icon.png"]];
    listView.frame=CGRectMake(60,0,120,180);
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:self.infoTable.backgroundView.backgroundColor];
    
    [cell.textLabel setText:@"Switch Mode Cell"];
    [cell.detailTextLabel setText:@"Swipe to switch"];
    
    // Adding gestures per state basis.
    __weak GivingViewController *weakSelf = self;
    
    [cell setSwipeGestureWithView:checkView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        //used to be Green Color
        NSLog(@"Did swipe \"Checkmark\" cell");
        NSLog(@"I want to delete this cell");
        __strong GivingViewController *strongSelf = weakSelf;
        strongSelf.cellToDelete = cell;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete?"
                                                            message:@"Are you sure you want to delete the cell?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
    }];
    
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        NSLog(@"Did swipe \"Cross\" cell");
        NSLog(@"I want to delete this cell");
        __strong GivingViewController *strongSelf = weakSelf;
        strongSelf.cellToDelete = cell;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete?"
                                                            message:@"Are you sure you want to delete the cell?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
        
    }];
    
    [cell setSwipeGestureWithView:clockView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Drink\" cell");
        
        [self switchSelectedStatusByIndexPath:indexPath]; //TEST
        [self expandDrinkCellWithIndexPath:indexPath];
        //[self expandCellWithIndexPath:indexPath]; //TEST
    }];
    
    [cell setSwipeGestureWithView:listView color:brownColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        //Used to be brownColor
        NSLog(@"Did swipe \"Card\" cell");
        [self switchSelectedStatusByIndexPath:indexPath]; //TEST
        [self expandCardCellWithIndexPath:indexPath];
        
    }];
    
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
    
    //Friend Name
    UILabel *friendName = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2,10,cell.frame.size.width/2,44)];
    friendName.text = [tableData objectAtIndex:indexPath.row];
    friendName.textAlignment=UITextAlignmentLeft;
    friendName.textColor = UIColorFromRGB(0x3cb878);
    friendName.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
    friendName.backgroundColor=[UIColor clearColor];
    friendName.tag=30;
    [cell.contentView addSubview:friendName];
    
    //Achievement
    UILabel *achievement= [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2,50,cell.frame.size.width/2-10,94)];
    achievement.text = [friendEvents objectAtIndex:indexPath.row];
    achievement.lineBreakMode = NSLineBreakByWordWrapping;
    achievement.numberOfLines = 0;
    achievement.textAlignment=UITextAlignmentLeft;
    achievement.font= [UIFont italicSystemFontOfSize:14];
    achievement.backgroundColor=[UIColor clearColor];
    achievement.tag=31;
    [cell.contentView addSubview:achievement];
    
    //Profile picture in circle
    UIImage* image = [[UIImage alloc] init];
    image = [UIImage imageNamed:[friendPictures objectAtIndex:indexPath.row]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(10,30,130,130);
    imageView.layer.cornerRadius = imageView.frame.size.height*0.5;
    imageView.layer.masksToBounds = YES;
    //imageView.layer.borderWidth = 2.0f;
    //imageView.layer.borderColor = [UIColor blackColor].CGColor;
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
    UIView* greenTableCloth = [[UIView alloc]initWithFrame:CGRectMake(0,0,screenRect.size.width,200)];
    [greenTableCloth setBackgroundColor:UIColorFromRGB(0x3cb878)];
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
                          nil];
    
    NSMutableArray* viewObjects = [[NSMutableArray alloc]initWithObjects:friendName, achievement,imageView, moneyValueLabel, circularSlider, martiniImageView, martiniSlider, martiniImageView2, martiniImageView3, dict, nil];
   
    [cellToViewItems setObject:viewObjects forKey:[NSNumber numberWithInt:indexPath.row]];
    
    return cell;
}

//Actions card + chocolate screen
-(void)cardButtonToggle:(id)sender
{
    cardSelected = !cardSelected;
    if(cardSelected){
        [tempCardButtonView setImage:[UIImage imageNamed:@"card_green.png"] forState:UIControlStateNormal];
    }else{
        [tempCardButtonView setImage:[UIImage imageNamed:@"card_faded.png"] forState:UIControlStateNormal];
    }
}

-(void)chocolateButtonToggle:(id)sender
{
    chocolateSelected = !chocolateSelected;
    if(chocolateSelected){
        [tempChocolateButtonView setImage:[UIImage imageNamed:@"chocolate_green.png"] forState:UIControlStateNormal];
    }else{
        [tempChocolateButtonView setImage:[UIImage imageNamed:@"chocolate_faded.png"] forState:UIControlStateNormal];
    }
}

-(void)cardPrompt1Selected:(id)sender
{
    
}

-(void)cardPrompt2Selected:(id)sender
{
    
}

-(void)cardPrompt3Selected:(id)sender
{
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // No
    if (buttonIndex == 0) {
        [_cellToDelete swipeToOriginWithCompletion:^{
            NSLog(@"Swiped back");
        }];
        _cellToDelete = nil;
    }
    
    // Yes
    else {
        // Code to delete your cell.
        int removal = [self.infoTable indexPathForCell:_cellToDelete].row;
        [tableData removeObjectAtIndex:removal];
        [friendEvents removeObjectAtIndex:removal];
        [friendPictures removeObjectAtIndex:removal];
        NSLog(@"table data: %@",[tableData objectAtIndex:0]);
        NSLog(@"friendEvents: %@",[friendEvents objectAtIndex:0]);
        NSLog(@"friendPictures: %@",[friendPictures objectAtIndex:0]);
        NSLog(@"tableRowSelected: %@",[tableRowSelected objectAtIndex:0]);
        [self.infoTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self.infoTable indexPathForCell:_cellToDelete]] withRowAnimation:YES];
        
        NSLog(@"DELETING CELL NOW MUAHAHAHA");
    }
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
    MCSwipeTableViewCell* tempCell = (MCSwipeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [tempCell setShouldDrag:YES];
    
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
    
    
    //TEMPORARILY DISABLE HEIGHT ADJUSTMENTS
    /*
    self.selectedRowIndex = indexPath;
    [self.infoTable beginUpdates];
    [self.infoTable endUpdates];
     */
     
    /*
    BOOL current = [[tableRowSelected objectAtIndex:indexPath.row]boolValue];
    [tableRowSelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!current]];
    
    self.selectedRowIndex = indexPath;
    [tableView beginUpdates];
    [tableView endUpdates];
     */
    
    /*
    MCSwipeTableViewCell* selectedCell = (MCSwipeTableViewCell*)[self.infoTable cellForRowAtIndexPath:indexPath];
    
    BOOL current = [[tableRowSelected objectAtIndex:indexPath.row]boolValue];
    [tableRowSelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!current]];
    
    if([[tableRowSelected objectAtIndex:indexPath.row]boolValue]){
        tableRowIsSelected=true;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            
            selectedCell.frame = CGRectMake(selectedCell.frame.origin.x,
                                            selectedCell.frame.origin.y,
                                            selectedCell.frame.size.width,
                                            selectedCell.frame.size.height * 2);
            
            MCSwipeTableViewCell* tempCell = selectedCell;
            int increment = [self.infoTable indexPathForCell:tempCell].row+1;
            while(increment < [tableData count]){
                tempCell = (MCSwipeTableViewCell*)[self.infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:increment inSection:0]];
                tempCell.frame = CGRectMake(tempCell.frame.origin.x,
                                                tempCell.frame.origin.y+tempCell.frame.size.height,
                                                tempCell.frame.size.width,
                                                tempCell.frame.size.height);
                increment++;
            }
            [UIView commitAnimations];
        });
    }else{
        tableRowIsSelected=false;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            selectedCell.frame = CGRectMake(selectedCell.frame.origin.x,
                                            selectedCell.frame.origin.y,
                                            selectedCell.frame.size.width,
                                            selectedCell.frame.size.height * 0.5);
            
            MCSwipeTableViewCell* tempCell = selectedCell;
            int increment = [tableData count]-1;
            while([self.infoTable indexPathForCell:selectedCell].row < increment){
                tempCell = (MCSwipeTableViewCell*)[self.infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:increment inSection:0]];
                tempCell.frame = CGRectMake(tempCell.frame.origin.x,
                                            tempCell.frame.origin.y-tempCell.frame.size.height,
                                            tempCell.frame.size.width,
                                            tempCell.frame.size.height);
                increment--;
            }
            [UIView commitAnimations];
        });
    }
     */
    
    //TEMPORARY DISABLE
    //[self displayGiftPopup:indexPath.row];
    
    
    /*
     if(indexPath.row == 0){
     NSLog(@"Transitioning now...");
     //[self performSegueWithIdentifier:@"toReceive" sender:self];
     }else{
     [self displayGiftPopup:indexPath.row];
     }
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    
    if(self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row && [[tableRowSelected objectAtIndex:indexPath.row]boolValue]) {
        [self expandCellWithIndexPath:indexPath];
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            
            MCSwipeTableViewCell* tempCell = (MCSwipeTableViewCell*)[self.infoTable cellForRowAtIndexPath:indexPath];
            [tempCell setShouldDrag:NO];//TEMPORARY
            
            //Adjust image
            UIImageView* reconstructedImageView = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:2];
            reconstructedImageView.frame = CGRectMake((self.view.frame.size.width/2)-(0.5*170),60,170,170);
            [reconstructedImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [reconstructedImageView.layer setBorderWidth: 2.0];
            reconstructedImageView.layer.cornerRadius=reconstructedImageView.frame.size.height/2;
            reconstructedImageView.layer.masksToBounds=YES;
            
            //Circular Slider
            CGRect sliderFrame = CGRectMake((tempCell.frame.size.width/2)-(0.5*190),50,190,190);
            circularSlider = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
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
            [tempCell addSubview:circularSlider];
            
            //Show dollar value!
            moneyValueLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(tempCell.frame.size.width-80, 10, 80, 42)];
            moneyValueLabel.font = [UIFont boldSystemFontOfSize:20];
            moneyValueLabel.text = @"$0.00";
            [tempCell addSubview:moneyValueLabel];
            
            //Hide achievement
            [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:1] setHidden:YES];
            
            //Move friend name
            UILabel *friendName = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:0];
            friendName.frame = CGRectMake(15,10,screenRect.size.width*0.6,44);
            
            [UIView commitAnimations]; //ANIMATIONS DONE!!!
            
            //ADD Logos
            //[self loadRestaurantLogos:tempCell];
            
            //ADD ACCEPT & CANCEL BUTTONS
            giftOKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            giftOKButton.frame = CGRectMake((tempCell.frame.origin.x+tempCell.frame.size.width)*0.3, tempCell.frame.size.height-50, 140, 20);
            [giftOKButton setTitle:@"Send Gift!" forState:UIControlStateNormal];
            [giftOKButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [giftOKButton addTarget:self action:@selector(okPressed) forControlEvents:UIControlEventTouchUpInside];
            [tempCell addSubview:giftOKButton];
        });
         */
        
        return 400;
    }

    UIImageView* reconstructedImageView = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:2];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        reconstructedImageView.frame = CGRectMake(10,30,130,130);
        reconstructedImageView.layer.cornerRadius = reconstructedImageView.frame.size.height*0.5;
        reconstructedImageView.layer.masksToBounds = YES;
        UILabel *friendName = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:0];
        friendName.frame = CGRectMake(self.view.frame.size.width/2,10,self.view
                                      .frame.size.width/2,44);
        [UIView commitAnimations];
    });
    
    //RETRACT POSITION
    [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:1] setHidden:NO];
    [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:2] setHidden:NO];
    [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:3] setHidden:YES];
    [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:4] setHidden:YES];
    [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:5] setHidden:YES];
    [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:6] setHidden:YES];
    [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:7] setHidden:YES];
    [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:8] setHidden:YES];


    NSDictionary* ccObjects = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:9];
    [[ccObjects objectForKey:@"cardAndChocolateView"] setHidden:YES];
    [[ccObjects objectForKey:@"lifeIsLikeAView"] setHidden:YES];
    
    //[ccObjects setValue:[NSNumber numberWithBool:cardSelected] forKey:@"cardSelected"];
    //[ccObjects setValue:[NSNumber numberWithBool:chocolateSelected] forKey:@"chocolateSelected"];
    [giftOKButton removeFromSuperview];
    
    return 200;
}

-(void)expandCardCellWithIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"The prodigal son has returned");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        MCSwipeTableViewCell* tempCell = (MCSwipeTableViewCell*)[self.infoTable cellForRowAtIndexPath:indexPath];
        [tempCell setShouldDrag:NO];//TEMPORARY
        
        //Adjust image
        UIImageView* reconstructedImageView = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:2];
        reconstructedImageView.frame = CGRectMake((self.view.frame.size.width/2)-(0.5*170),60,170,170);
        [reconstructedImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [reconstructedImageView.layer setBorderWidth: 2.0];
        reconstructedImageView.layer.cornerRadius=reconstructedImageView.frame.size.height/2;
        reconstructedImageView.layer.masksToBounds=YES;
        
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:1] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:2] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:3] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:4] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:5] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:6] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:7] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:8] setHidden:YES];
        
        //Move friend name
        UILabel *friendName = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:0];
        friendName.frame = CGRectMake(15,10,screenRect.size.width*0.6,44);
        
        
        //Load chocolate items!!!
        NSDictionary* ccObjects = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:9];
        [[ccObjects objectForKey:@"cardAndChocolateView"] setHidden:NO];
        [[ccObjects objectForKey:@"lifeIsLikeAView"] setHidden:NO];
        [tempCell addSubview:[ccObjects objectForKey:@"cardAndChocolateView"]];
        [tempCell addSubview:[ccObjects objectForKey:@"lifeIsLikeAView"]];
        
        cardSelected = [[ccObjects objectForKey:@"cardSelected"] boolValue];
        chocolateSelected = [[ccObjects objectForKey:@"chocolateSelected"] boolValue];
        tempCardButtonView= [ccObjects objectForKey:@"cardButton"];
        tempChocolateButtonView = [ccObjects objectForKey:@"chocolateButton"];
        
        [UIView commitAnimations]; //ANIMATIONS DONE!!!
        
        //ADD ACCEPT & CANCEL BUTTONS
        /*
        giftOKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        giftOKButton.frame = CGRectMake((tempCell.frame.origin.x+tempCell.frame.size.width)*0.3, tempCell.frame.size.height-50, 140, 20);
        [giftOKButton setTitle:@"Send Gift!" forState:UIControlStateNormal];
        [giftOKButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [giftOKButton addTarget:self action:@selector(okPressed) forControlEvents:UIControlEventTouchUpInside];
        [tempCell addSubview:giftOKButton];
         */
    });
}

-(void)expandDrinkCellWithIndexPath:(NSIndexPath*)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        MCSwipeTableViewCell* tempCell = (MCSwipeTableViewCell*)[self.infoTable cellForRowAtIndexPath:indexPath];
        [tempCell setShouldDrag:NO];//TEMPORARY
        
        //Adjust image
        UIImageView* reconstructedImageView = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:2];
        reconstructedImageView.frame = CGRectMake((self.view.frame.size.width/2)-(0.5*170),60,170,170);
        [reconstructedImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [reconstructedImageView.layer setBorderWidth: 2.0];
        reconstructedImageView.layer.cornerRadius=reconstructedImageView.frame.size.height/2;
        reconstructedImageView.layer.masksToBounds=YES;
        
        
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:1] setHidden:YES];
        //Hide profile picture
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:2] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:3] setHidden:NO];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:4] setHidden:YES];
        //Show martini glass
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:5] setHidden:NO];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:6] setHidden:NO];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:7] setHidden:NO];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:8] setHidden:NO];
        
        moneyHelper = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:3];
        sliderHelper = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:4];
        martiniHelper1= [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:5];
        martiniSliderHelper = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:6];
        martiniHelper2 = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:7];
        martiniHelper3 = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:8];
        
        //Move friend name
        UILabel *friendName = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:0];
        friendName.frame = CGRectMake(15,10,screenRect.size.width*0.6,44);
        
        
        
        [UIView commitAnimations]; //ANIMATIONS DONE!!!
        
        //ADD Logos
        //[self loadRestaurantLogos:tempCell];
        
        //ADD ACCEPT & CANCEL BUTTONS
        giftOKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        giftOKButton.frame = CGRectMake((tempCell.frame.origin.x+tempCell.frame.size.width)*0.3, tempCell.frame.size.height-50, 140, 20);
        [giftOKButton setTitle:@"Send Gift!" forState:UIControlStateNormal];
        [giftOKButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [giftOKButton addTarget:self action:@selector(okPressed) forControlEvents:UIControlEventTouchUpInside];
        [tempCell addSubview:giftOKButton];
    });
}

-(void)expandCellWithIndexPath:(NSIndexPath*)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        MCSwipeTableViewCell* tempCell = (MCSwipeTableViewCell*)[self.infoTable cellForRowAtIndexPath:indexPath];
        [tempCell setShouldDrag:NO];//TEMPORARY
        
        //Adjust image
        UIImageView* reconstructedImageView = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:2];
        reconstructedImageView.frame = CGRectMake((self.view.frame.size.width/2)-(0.5*170),60,170,170);
        [reconstructedImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [reconstructedImageView.layer setBorderWidth: 2.0];
        reconstructedImageView.layer.cornerRadius=reconstructedImageView.frame.size.height/2;
        reconstructedImageView.layer.masksToBounds=YES;
        
        
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:1] setHidden:YES];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:3] setHidden:NO];
        [[[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:4] setHidden:NO];
        moneyHelper = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:3];
        sliderHelper = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:4];
        
        //Move friend name
        UILabel *friendName = [[cellToViewItems objectForKey:[NSNumber numberWithInt:indexPath.row]]objectAtIndex:0];
        friendName.frame = CGRectMake(15,10,screenRect.size.width*0.6,44);
        
        [UIView commitAnimations]; //ANIMATIONS DONE!!!
        
        //ADD Logos
        //[self loadRestaurantLogos:tempCell];
        
        //ADD ACCEPT & CANCEL BUTTONS
        giftOKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        giftOKButton.frame = CGRectMake((tempCell.frame.origin.x+tempCell.frame.size.width)*0.3, tempCell.frame.size.height-50, 140, 20);
        [giftOKButton setTitle:@"Send Gift!" forState:UIControlStateNormal];
        [giftOKButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [giftOKButton addTarget:self action:@selector(okPressed) forControlEvents:UIControlEventTouchUpInside];
        [tempCell addSubview:giftOKButton];

    });
}

-(void)loadRestaurantLogos:(UIView*)contentView{
    int counter = 0;
    int logoSquareDimensions = 45;
    int horizontalSpacing = 53;
    int verticalSpacing = 240;
    int edge = 8;
    while(counter<8)
    {
        if(counter==0){
            //nothing we're all set!
        }else if(counter==4){
            horizontalSpacing = 53;
            verticalSpacing += logoSquareDimensions+edge;
        }else if(counter==8){
            horizontalSpacing=75;
            verticalSpacing += logoSquareDimensions+edge;
        }else if(counter==9){
            horizontalSpacing=150;
        }else{
            horizontalSpacing += logoSquareDimensions+edge;
        }
        
        if(counter<7){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = counter;
            btn.frame = CGRectMake(horizontalSpacing, verticalSpacing, logoSquareDimensions, logoSquareDimensions);
            NSString *imageName = [NSString stringWithFormat:@"logo%i.png",(counter+1)];
            UIImage *btnImage = [UIImage imageNamed:imageName];
            [btn setImage:btnImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(logoPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [btn.layer setBorderWidth: 2.0];
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            [contentView addSubview:btn];
        }else if(counter==7){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(horizontalSpacing, verticalSpacing, logoSquareDimensions, logoSquareDimensions);
            NSString *imageName = [NSString stringWithFormat:@"plus.png"];
            UIImage *btnImage = [UIImage imageNamed:imageName];
            [btn setImage:btnImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(plusPressed) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [btn.layer setBorderWidth: 2.0];
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            [contentView addSubview:btn];
        }
        counter++;
    }
}

-(void)displayGiftPopup :(CGFloat)indexPathRow
{
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0,0,screenRect.size.width*0.85,screenRect.size.height*0.85);
    
    UILabel *friendName= [[UILabel alloc] initWithFrame:CGRectMake(10,10,screenRect.size.width*0.6,44)];
    friendName.text = [tableData objectAtIndex:indexPathRow];
    friendName.textAlignment=UITextAlignmentLeft;
    friendName.font= [UIFont boldSystemFontOfSize:20];
    friendName.backgroundColor=[UIColor clearColor];
    [contentView addSubview:friendName];
    
    giftValue= [[UILabel alloc] initWithFrame:CGRectMake(contentView.frame.origin.x+contentView.frame.size.width-80,10,80,44)];
    giftValue.text = @"$0.00";
    giftValue.textAlignment=UITextAlignmentLeft;
    giftValue.font= [UIFont boldSystemFontOfSize:20];
    giftValue.backgroundColor=[UIColor clearColor];
    [contentView addSubview:giftValue];
    
    UIImage* image = [[UIImage alloc] init];
    image = [UIImage imageNamed:[friendPictures objectAtIndex:indexPathRow]];
    
    float scaleFactor = 1.0;
    while(scaleFactor>0.0){
        if((scaleFactor*image.size.width<=screenRect.size.width*0.7) && (scaleFactor*image.size.height<=150)){
            break;
        }
        scaleFactor-=0.05;
    }
    if(scaleFactor<=0){
        NSLog(@"Could not find an appropriate scale factor!");
    }
    float leftOffset = screenRect.size.width*0.5*(1-0.15-((scaleFactor*image.size.width)/screenRect.size.width));
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((contentView.frame.size.width/2)-(0.5*150),50,150,150);
    [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [imageView.layer setBorderWidth: 2.0];
    imageView.layer.cornerRadius=imageView.frame.size.height/2;
    imageView.layer.masksToBounds=YES;
    [contentView addSubview:imageView];
    
    /*
     UILabel *tabValueTitle= [[UILabel alloc] initWithFrame:CGRectMake(10,200,100,44)];
     tabValueTitle.text = @"Tab value: ";
     tabValueTitle.textAlignment=UITextAlignmentLeft;
     tabValueTitle.font= [UIFont boldSystemFontOfSize:15];
     tabValueTitle.backgroundColor=[UIColor clearColor];
     [contentView addSubview:tabValueTitle];
     */
    
    /*
     UITextField *tabValueField = [[UITextField alloc] initWithFrame:CGRectMake(100,200,100,44)];
     tabValueField.borderStyle = UITextBorderStyleRoundedRect;
     tabValueField.font = [UIFont systemFontOfSize:18];
     tabValueField.placeholder = @"$50";
     tabValueField.autocorrectionType = UITextAutocorrectionTypeNo;
     tabValueField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
     tabValueField.returnKeyType = UIReturnKeyDone;
     tabValueField.clearButtonMode = UITextFieldViewModeWhileEditing;
     tabValueField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     tabValueField.borderStyle = UITextBorderStyleNone;
     tabValueField.delegate = self;
     [contentView addSubview:tabValueField];
     */
    
    /*
     //CURRENT WORKING
     tabValueHere = [[UITextField alloc] initWithFrame:CGRectMake(100,200,100,44)];
     tabValueHere.borderStyle = UITextBorderStyleRoundedRect;
     tabValueHere.font = [UIFont systemFontOfSize:18];
     tabValueHere.placeholder = @"$50";
     tabValueHere.autocorrectionType = UITextAutocorrectionTypeNo;
     tabValueHere.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
     tabValueHere.returnKeyType = UIReturnKeyDone;
     tabValueHere.clearButtonMode = UITextFieldViewModeWhileEditing;
     tabValueHere.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     tabValueHere.borderStyle = UITextBorderStyleNone;
     tabValueHere.delegate = self;
     [contentView addSubview:tabValueHere];
     */
    
    /*
     slider = [[UISlider alloc] initWithFrame:CGRectMake(100,200,150,44)];
     [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
     [slider setBackgroundColor:[UIColor clearColor]];
     slider.minimumValue = 0.0;
     slider.maximumValue = 100.0;
     slider.continuous = YES;
     slider.value = 50.0;
     [contentView addSubview:slider];
     
     sliderValueLabel= [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x*1.65,
     slider.frame.origin.y-5,
     50,
     50)];
     sliderValueLabel.text = @"$50";
     sliderValueLabel.textAlignment=UITextAlignmentCenter;
     sliderValueLabel.font= [UIFont italicSystemFontOfSize:12];
     sliderValueLabel.backgroundColor=[UIColor clearColor];
     [contentView addSubview:sliderValueLabel];
     */
    
    /*
     UILabel *tabVenueTitle= [[UILabel alloc] initWithFrame:CGRectMake(10,230,100,44)];
     tabVenueTitle.text = @"Tab venue: ";
     tabVenueTitle.textAlignment=UITextAlignmentLeft;
     tabVenueTitle.font= [UIFont boldSystemFontOfSize:15];
     tabVenueTitle.backgroundColor=[UIColor clearColor];
     [contentView addSubview:tabVenueTitle];
     */
    
    //ADD BUTTONS
    
    int counter = 0;
    int logoSquareDimensions = 40;
    int horizontalSpacing = 50;
    int verticalSpacing = 270;
    while(counter<10)
    {
        if(counter==0){
            //nothing we're all set!
        }else if(counter==4){
            horizontalSpacing = 50;
            verticalSpacing += logoSquareDimensions+6;
        }else if(counter==8){
            horizontalSpacing=75;
            verticalSpacing += logoSquareDimensions+6;
        }else if(counter==9){
            horizontalSpacing=150;
        }else{
            horizontalSpacing += logoSquareDimensions+6;
        }
        
        if(counter<7){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = counter;
            btn.frame = CGRectMake(horizontalSpacing, verticalSpacing, logoSquareDimensions, logoSquareDimensions);
            NSString *imageName = [NSString stringWithFormat:@"logo%i.png",(counter+1)];
            UIImage *btnImage = [UIImage imageNamed:imageName];
            [btn setImage:btnImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(logoPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [btn.layer setBorderWidth: 2.0];
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            [contentView addSubview:btn];
        }else if(counter==7){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(horizontalSpacing, verticalSpacing, logoSquareDimensions, logoSquareDimensions);
            NSString *imageName = [NSString stringWithFormat:@"plus.png"];
            UIImage *btnImage = [UIImage imageNamed:imageName];
            [btn setImage:btnImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(plusPressed) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [btn.layer setBorderWidth: 2.0];
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            [contentView addSubview:btn];
        }else if(counter==8){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(horizontalSpacing, verticalSpacing, logoSquareDimensions, logoSquareDimensions);
            [btn setTitle:@"Back" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btn];
        }else{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(horizontalSpacing, verticalSpacing, logoSquareDimensions, logoSquareDimensions);
            [btn setTitle:@"OK" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(okPressed) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btn];
        }
        counter++;
    }
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    
    popup = [KLCPopup popupWithContentView:contentView];
    popTipShowing=false;
    [popup show];
}



- (void)logoPressed:(id) sender
{
    UIButton *button = (UIButton*) sender;
    int specialCase=0;
    
    if(popTipShowing && popTip0.tag==button.tag){
        [popTip0 hide];
        popTipShowing=false;
        specialCase=1;
    }else if(popTipShowing && popTip0.tag!=button.tag){
        [popTip0 hide];
        popTip0 = [AMPopTip popTip];
        popTip0.tag = button.tag;
        [popTip0 showText:[selectedVenues objectAtIndex:button.tag] direction:AMPopTipDirectionUp maxWidth:200 inView:popup.contentView fromFrame:button.frame];
        [button.layer setBorderColor: [[UIColor redColor] CGColor]];
        popTipShowing=true;
    }else{
        popTip0 = [AMPopTip popTip];
        popTip0.tag = button.tag;
        [popTip0 showText:[selectedVenues objectAtIndex:button.tag] direction:AMPopTipDirectionUp maxWidth:200 inView:popup.contentView fromFrame:button.frame];
        [button.layer setBorderColor: [[UIColor redColor] CGColor]];
        popTipShowing=true;
    }
    
    //Selected logo can be found @ index popup0.tag in selectedVenues
    int temp = 0;
    while(temp<8){
        UIButton *button = (UIButton *)[popup.contentView viewWithTag:temp];
        if(popTip0.tag!=temp || specialCase==1){
            [button.layer setBorderColor: [[UIColor blackColor] CGColor]];
        }
        temp++;
    }
    
}

-(void)sliderAction:(id)sender
{
    moneyHelper.text = [NSString stringWithFormat:@"$%.2f",sliderHelper.currentValue];
}

-(void)martiniValueChanged:(id)sender
{
    moneyHelper.text = [NSString stringWithFormat:@"$%.2f",martiniSliderHelper.value * 0.3];
    
    if(martiniSliderHelper.value < 33){
        NSString* iconNumber = [NSString stringWithFormat:@"%.f", martiniSliderHelper.value];
        NSString* imageName = [NSString stringWithFormat:@"martini_icon%@.png",iconNumber];
        martiniHelper1.image = [UIImage imageNamed:imageName];
        
        //Get the second martini out of the picture!
        if(martiniHelper2.frame.origin.x < screenRect.size.width){
            martiniHelper2.frame = CGRectMake(martiniHelper2.frame.origin.x+10,
                                              martiniHelper2.frame.origin.y,
                                              martiniHelper2.frame.size.width,
                                              martiniHelper2.frame.size.height);
        }
        
        //move first martini glass towards center
        if(martiniHelper1.frame.origin.x < 110){
            martiniHelper1.frame = CGRectMake(martiniHelper1.frame.origin.x+4,
                                              martiniHelper1.frame.origin.y,
                                              martiniHelper1.frame.size.width,
                                              martiniHelper1.frame.size.height);
        }
    }else if(martiniSliderHelper.value >= 33 && martiniSliderHelper.value < 66){
       //Start moving the first martini glass to the left
        if(martiniHelper1.frame.origin.x > 25){
            martiniHelper1.frame = CGRectMake(martiniHelper1.frame.origin.x-4,
                                             martiniHelper1.frame.origin.y,
                                             martiniHelper1.frame.size.width,
                                             martiniHelper1.frame.size.height);
        }
        //Get the second martini glass to the first glass's old position
        if(martiniHelper2.frame.origin.x > 110){
            martiniHelper2.frame = CGRectMake(martiniHelper2.frame.origin.x-10,
                                              martiniHelper2.frame.origin.y,
                                              martiniHelper2.frame.size.width,
                                              martiniHelper2.frame.size.height);
        }
        //Start filling the second glass
        NSString* iconNumber = [NSString stringWithFormat:@"%.f", martiniSliderHelper.value-33];
        NSString* imageName = [NSString stringWithFormat:@"martini_icon%@.png",iconNumber];
        martiniHelper2.image = [UIImage imageNamed:imageName];
        
        //Get the third glass out of here!
        if(martiniHelper3.frame.origin.x < screenRect.size.width){
            martiniHelper3.frame = CGRectMake(martiniHelper3.frame.origin.x+10,
                                              martiniHelper3.frame.origin.y,
                                              martiniHelper3.frame.size.width,
                                              martiniHelper3.frame.size.height);
        }
        
    }else{
        //Move third glass in
        if(martiniHelper3.frame.origin.x > 200){
            martiniHelper3.frame = CGRectMake(martiniHelper3.frame.origin.x-10,
                                              martiniHelper3.frame.origin.y,
                                              martiniHelper3.frame.size.width,
                                              martiniHelper3.frame.size.height);
        }
        
        //Fill the third glass
        NSString* iconNumber = [NSString stringWithFormat:@"%.f", martiniSliderHelper.value-66];
        NSString* imageName = [NSString stringWithFormat:@"martini_icon%@.png",iconNumber];
        martiniHelper3.image = [UIImage imageNamed:imageName];

        
    }
}

-(void)plusPressed
{
}

-(void)backPressed
{
    [popup dismiss:TRUE];
}

-(void)okPressed
{
    [popup dismiss:TRUE];
    
    NSString *onlyNumbers = [[tabValueHere.text componentsSeparatedByCharactersInSet:
                              [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                             componentsJoinedByString:@""];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:onlyNumbers];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString* formattedOutput = [formatter stringFromNumber:myNumber];
    
    // NSString *alertMessage = [NSString stringWithFormat:@"%@ will be charged to 'Sunny's Card' - Continue?",formattedOutput];
    
    NSString *alertMessage = [NSString stringWithFormat:@"$%.2f will be charged to 'Sunny's Card' - Continue?",sliderHelper.currentValue];
    MBAlertView *alert = [MBAlertView alertWithBody:alertMessage cancelTitle:@"Cancel" cancelBlock:^{
        NSLog(@"NOT APPROVED!!");
    }];
    [alert addButtonWithText:@"Continue" type:MBAlertViewItemTypePositive block:^{
        
        
        UIView* approvedView = [[UIView alloc]init];
        CGFloat width = 100;
        CGFloat height = 50;
        CGFloat x = (0.5*screenRect.size.width);
        CGFloat y = (0.5*screenRect.size.height);
        
        approvedView.frame = CGRectMake(x, y, width, height);
        BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithView:approvedView text:@"Approved!"];
        hud.center = CGPointMake(x, y);
        //hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
        
        // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
        [self.view addSubview:hud];
        [hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
            [hud removeFromSuperview];
        }];

        NSLog(@"APPROVED!!");
    }];
         
    [alert addToDisplayQueue];
}

#pragma mark UITableViewDelegate
- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    //Do nothing =)
}


/*
 
 -(void)startActivityIndicator
 {
 self.activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
 self.activityView.center=self.view.center;
 [self.activityView startAnimating];
 [self.view addSubview:self.activityView];
 }
 
 -(void)stopActivityIndicator
 {
 [self.activityView stopAnimating];
 [self.activityView removeFromSuperview];
 }
 
 
 -(void)populateViewControllerItems:(NSMutableArray*)friendsToDisplay
 {
 
 if([friendsToDisplay count]>0){
 //Segment Control
 UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:friendsToDisplay];
 segmentedControl.frame = CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 30);
 segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
 segmentedControl.selectedSegmentIndex = 0;
 [segmentedControl addTarget:self
 action:@selector(pickOne:)
 forControlEvents:UIControlEventValueChanged];
 [self.view addSubview:segmentedControl];
 
 
 //Profile picture (temporary until picture URL is provided)
 self.profilePictureView.profileID = self.facebookUser.objectID;
 
 //Wall post
 self.wallPostTextField.text = [NSString stringWithFormat:@"Happy birthday, %@!",[[[friendsToDisplay objectAtIndex:0] componentsSeparatedByString:@" "] objectAtIndex:0]];
 
 self.nameLabel.text = [friendsToDisplay objectAtIndex:0];
 }
 [self stopActivityIndicator];
 }
 
 -(void)populateFriendIDFromStatus
 {
 // The storage logic will be: [123|Sunny|Shah,332|Abhi|Ramesh, ...]
 self.friendInfoFromStatus= [[NSMutableArray alloc]init];
 [FBRequestConnection startWithGraphPath:@"me/statuses"
 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
 if (!error) {
 for(int i=0; i<[result[@"data"] count]; i++){
 for(int j=0; j<[result[@"data"][i][@"likes"][@"data"] count]; j++){
 NSString* friendID = result[@"data"][i][@"likes"][@"data"][j][@"id"];
 NSString* friendFullName = result[@"data"][i][@"likes"][@"data"][j][@"name"];
 NSString* friendFirstName = [friendFullName componentsSeparatedByString:@" "][0];
 NSString* friendLastName =[friendFullName componentsSeparatedByString:@" "][1];
 [self.friendInfoFromStatus addObject:[NSString stringWithFormat:@"%@|%@|%@",friendID,friendFirstName,friendLastName]];
 }
 }
 
 //Pick our lucky few!
 [self selectFriendsToDisplay:self.friendInfoFromStatus :3];
 }
 else{
 NSLog(@"Error in method 'populateFriendIDFromStatus");
 }}];
 }
 
 -(NSMutableArray*)selectFriendsToDisplay:(NSMutableArray*)friendInfoFromStatus :(NSInteger)numberOfFriendsToDisplay
 {
 NSMutableArray* friendSelections = [[NSMutableArray alloc] init];
 if([friendInfoFromStatus count]>0 && numberOfFriendsToDisplay>0 && [friendInfoFromStatus count]>=numberOfFriendsToDisplay)
 {
 int random = arc4random()%[friendInfoFromStatus count]/numberOfFriendsToDisplay;
 int anchor = random;
 while([friendSelections count] < numberOfFriendsToDisplay){
 [friendSelections addObject:[NSString stringWithFormat:@"%@ %@",[[[friendInfoFromStatus objectAtIndex:random] componentsSeparatedByString:@"|"] objectAtIndex:1],[[[friendInfoFromStatus objectAtIndex:random] componentsSeparatedByString:@"|"] objectAtIndex:2]]];
 random += anchor;
 }
 }else{
 NSLog(@"Error in selectFriendsToDisplay method");
 }
 self.friendsDisplayed = [[NSMutableArray alloc]init];
 self.friendsDisplayed = friendSelections;
 //[self populateViewControllerItems:self.friendsDisplayed];
 return friendSelections;
 }
 
 -(void)testFriendship:(NSString*)user1 :(NSString*)user2{
 NSString* graphPath = [NSString stringWithFormat:@"/%@/friends/%@",user1,user2];
 [FBRequestConnection startWithGraphPath:graphPath
 parameters:nil
 HTTPMethod:@"GET"
 completionHandler:^(
 FBRequestConnection *connection,
 id result,
 NSError *error
 ) {
 NSLog(@"%@ and %@ are friends: %@",user1,user2,result);
 }];
 }
 
 -(void)returnRelevantUserInfo
 {
 [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
 if (!error) NSLog(@"user info: %@", result);
 else NSLog(@"Error in returnRelevantUserInfo method");
 }];
 }
 
 -(void)checkPermissions
 {
 [FBRequestConnection startWithGraphPath:@"/me/permissions"
 parameters:nil
 HTTPMethod:@"GET"
 completionHandler:^(
 FBRequestConnection *connection, id result, NSError *error){
 NSLog(@"Permissions Check: %@", [result objectForKey:@"data"]);
 }];
 }
 
 -(void)pickOne:(id)sender{
 UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
 self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",[[[self.friendsDisplayed objectAtIndex:[segmentedControl selectedSegmentIndex]] componentsSeparatedByString:@" "]objectAtIndex:0], [[[self.friendsDisplayed objectAtIndex:[segmentedControl selectedSegmentIndex]] componentsSeparatedByString:@" "]objectAtIndex:1]];
 self.wallPostTextField.text = [NSString stringWithFormat:@"Happy birthday, %@!",[[[self.friendsDisplayed objectAtIndex:[segmentedControl selectedSegmentIndex]] componentsSeparatedByString:@" "] objectAtIndex:0]];
 [self.wallPostTextField reloadInputViews];
 }
 */

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
    
    //Lets play with colors
    /*
     int colorsAreFun = arc4random()%5;
     if(colorsAreFun==0)[glowingBorder showLightingWithColor:[UIColor yellowColor]];
     else if(colorsAreFun==1) [glowingBorder showLightingWithColor:[UIColor orangeColor]];
     else if(colorsAreFun==2)[glowingBorder showLightingWithColor:[UIColor greenColor]];
     else if(colorsAreFun==3)[glowingBorder showLightingWithColor:[UIColor blueColor]];
     else if(colorsAreFun==4)[glowingBorder showLightingWithColor:[UIColor redColor]];
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



/*****MEMORY RELATED******/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
