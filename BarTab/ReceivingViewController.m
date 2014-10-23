//
//  ReceivingViewController.m
//  BarTab
//
//  Created by Sunny Shah on 7/24/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "ReceivingViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kMasterColor 0x51B0BD
#define kBackgroundColor 0xE9E9E9
#define kSupportingColor 0x51bdb8
#define kCellHeight 120
#define kAchievementFont 20.0f
#define kAchievementFontType @"GillSans-Light"

@interface ReceivingViewController () <UINavigationControllerDelegate>

@end

@implementation ReceivingViewController
{
    
    CGRect screenRect;
    
    //master table info
    NSMutableArray *masterArrayOfDictionaries;
    NSDictionary *masterTableDictionary;
    
    //Popup Management
    NSString *selectedValue;
    KLCPopup *popup;
    BOOL popTipShowing;
    
    //For Nav Bar + Buttons
    UIView* mainNavBar;
    float mainNavBarOriginY;
    
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
    
    //Gift effect
    NSMutableDictionary* cellToGiftView;
}

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
    masterArrayOfDictionaries = [[NSMutableArray alloc]init];
    [masterArrayOfDictionaries addObject:[self fillDictionary:@"Deepika P." giftType:@"flower" giftQuantity:@"1" giftStatus:@"2" customMessage:@"Go Sunny!" deliveryDate:@"9/2/2014" gifterImage:@"N/A" venueImage:@"N/A" giftOpened:@"n"]];
    [masterArrayOfDictionaries addObject:[self fillDictionary:@"Dilip" giftType:@"chocolate" giftQuantity:@"2" giftStatus:@"1" customMessage:@"I'll trade you designs for chocolates. Not a bad deal?" deliveryDate:@"9/1/2014" gifterImage:@"N/A" venueImage:@"N/A" giftOpened:@"n"]];
    [masterArrayOfDictionaries addObject:[self fillDictionary:@"Kishan Shah" giftType:@"drink" giftQuantity:@"100" giftStatus:@"1" customMessage:@"TEST" deliveryDate:@"8/31/2014" gifterImage:@"N/A" venueImage:@"N/A" giftOpened:@"n"]];
    [masterArrayOfDictionaries addObject:[self fillDictionary:@"Ronak Gandhi" giftType:@"chocolate" giftQuantity:@"2" giftStatus:@"2" customMessage:@"TEST" deliveryDate:@"8/30/2014" gifterImage:@"N/A" venueImage:@"N/A" giftOpened:@"y"]];
    [masterArrayOfDictionaries addObject:[self fillDictionary:@"Ankur Goyal" giftType:@"drink" giftQuantity:@"1" giftStatus:@"1" customMessage:@"TEST" deliveryDate:@"8/29/2014" gifterImage:@"N/A" venueImage:@"N/A" giftOpened:@"y"]];
    [masterArrayOfDictionaries addObject:[self fillDictionary:@"Ricky Hong" giftType:@"flower" giftQuantity:@"1" giftStatus:@"1" customMessage:@"TEST" deliveryDate:@"8/25/2014" gifterImage:@"N/A" venueImage:@"N/A" giftOpened:@"y"]];
    
    cellToGiftView = [[NSMutableDictionary alloc]init];
    
    //Screen Settings
    screenRect = [[UIScreen mainScreen] bounds];
    self.infoTable.frame = CGRectMake(self.infoTable.frame.origin.x,
                                      self.infoTable.frame.origin.y,
                                      self.infoTable.frame.size.width,
                                      self.infoTable.frame.size.height);
    self.view.backgroundColor = UIColorFromRGB(0xE9E9E9);
    self.infoTable.backgroundColor = self.view.backgroundColor;
    self.infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTable.separatorColor = [UIColor clearColor];
    _interactive = [[AMWaveTransition alloc] init];
    popTipShowing=false;
    tableHomeY = self.infoTable.frame.origin.y;
    fixedBottomDistance = screenRect.size.height - tableHomeY - self.infoTable.frame.size.height;
    
    
    UIView* blueTableCloth = [[UIView alloc]initWithFrame:CGRectMake(0,50,screenRect.size.width,10)];
    [blueTableCloth setBackgroundColor:UIColorFromRGB(kMasterColor)];
    blueTableCloth.layer.cornerRadius = 20.0f;
    blueTableCloth.layer.masksToBounds=YES;
    [self.view addSubview:blueTableCloth];
    
    [self loadMainNavBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [masterArrayOfDictionaries count];
    //return [venueData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
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
    cell.frame = CGRectMake(100, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
    cell.backgroundColor = UIColorFromRGB(kBackgroundColor);
    
    [[cell.contentView viewWithTag:30] removeFromSuperview];
    [[cell.contentView viewWithTag:31] removeFromSuperview];
    [[cell.contentView viewWithTag:32] removeFromSuperview];
    [[cell.contentView viewWithTag:33] removeFromSuperview];
    
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
    
    
    //Friend Name
    UILabel *friendName = [[UILabel alloc] initWithFrame:CGRectMake(whiteTableCloth.frame.origin.x,95,screenRect.size
                                                                    .width,20)];
    NSString* nameHelper = [[masterArrayOfDictionaries objectAtIndex:indexPath.row]objectForKey:@"friendName"];
    friendName.text = [NSString stringWithFormat:@"%@",[[nameHelper componentsSeparatedByString:@" "]objectAtIndex:0]];
    friendName.textColor = [UIColor whiteColor];
    friendName.backgroundColor=UIColorFromRGB(kSupportingColor);
    friendName.numberOfLines = 1;
    friendName.textAlignment = UITextAlignmentCenter;
    int fontSize = [self sizeLabel:friendName toRect:CGRectMake(whiteTableCloth.frame.origin.x,95,screenRect.size
                                                                .width,20)];
    friendName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    friendName.tag=30;
    [cell.contentView addSubview:friendName];
    
    
    //Profile picture in circle
    NSString* tempNameHelper = [[masterArrayOfDictionaries objectAtIndex:indexPath.row]objectForKey:@"friendName"];
    NSString* firstName = [NSString stringWithFormat:@"%@",[[tempNameHelper componentsSeparatedByString:@" "]objectAtIndex:0]];
    NSString* imageNameHelper = [NSString stringWithFormat:@"%@.jpg",[firstName lowercaseString]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNameHelper]];
    imageView.frame = CGRectMake(10,5,110,110);
    imageView.layer.cornerRadius = imageView.frame.size.height*0.5;;
    imageView.layer.masksToBounds = YES;
    imageView.layer.shadowRadius=10.0f;
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.tag=32;
    [cell.contentView addSubview:imageView];
    
    //Achievement
    UILabel *achievement= [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.44,15,cell.frame.size.width*0.5,75)];
    achievement.text = [[masterArrayOfDictionaries objectAtIndex:indexPath.row]objectForKey:@"customMessage"];
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
    
    //Add small gift-type icon
    if([[[masterArrayOfDictionaries objectAtIndex:indexPath.row]objectForKey:@"giftOpened"] isEqualToString:@"y"]){
        UIView* grayTableCloth = [[UIView alloc] initWithFrame:cell.contentView.frame];
        [grayTableCloth setBackgroundColor:[UIColor grayColor]];
        grayTableCloth.alpha = 0.5;
        grayTableCloth.tag = 33;
        //[cell.contentView addSubview:grayTableCloth];
    }

    return cell;
}


-(void)loadCellGiftView:(UITableViewCell*)cell :(NSIndexPath*)indexPath
{
    
    UIView* bigGiftBox = [[UIView alloc]initWithFrame:cell.contentView.frame];
    [bigGiftBox setBackgroundColor:[UIColor whiteColor]];
    
    UIView* topLeft = [[UIView alloc]initWithFrame:CGRectMake(0,0, cell.frame.size.width*0.3, kCellHeight*0.4)];
    UIView* topRight = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width*0.4,0, cell.frame.size.width*0.6, kCellHeight*0.4)];
    UIView* bottomLeft = [[UIView alloc]initWithFrame:CGRectMake(0,kCellHeight*0.6, cell.frame.size.width*0.3, kCellHeight*0.4)];
    UIView* bottomRight = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width*0.4,kCellHeight*0.6, cell.frame.size.width*0.6, kCellHeight*0.4)];
    
    [topLeft setBackgroundColor:UIColorFromRGB(kSupportingColor)];
    [topRight setBackgroundColor:UIColorFromRGB(kSupportingColor)];
    [bottomLeft setBackgroundColor:UIColorFromRGB(kSupportingColor)];
    [bottomRight setBackgroundColor:UIColorFromRGB(kSupportingColor)];
    
    [bigGiftBox addSubview:topLeft];
    [bigGiftBox addSubview:topRight];
    [bigGiftBox addSubview:bottomLeft];
    [bigGiftBox addSubview:bottomRight];
    
    bigGiftBox.alpha=0.98;
    bigGiftBox.tag=33;
    [cell addSubview:bigGiftBox];
    
    [cellToGiftView setObject:@[bigGiftBox,topLeft,topRight,bottomLeft,bottomRight] forKey:[NSNumber numberWithInteger:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([cellToGiftView objectForKey:[NSNumber numberWithInteger:indexPath.row]]!= nil){
        NSLog(@"Removing gift for row: %li",(long)indexPath.row);
        NSArray* helperArray = [cellToGiftView objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        NSLog(@"Row: %li, Helper array length: %lu",(long)indexPath.row,(unsigned long)helperArray.count);
        UIView* bigGiftBox =[helperArray objectAtIndex:0];
        UIView* topLeft = [helperArray objectAtIndex:1];
        UIView* topRight = [helperArray objectAtIndex:2];
        UIView* bottomLeft = [helperArray objectAtIndex:3];
        UIView* bottomRight = [helperArray objectAtIndex:4];
        
        NSLog(@"DOING SOMETHING");
        [UIView animateWithDuration:0.5
                         animations:^{
                             bigGiftBox.alpha = 0.7;
                             topLeft.frame = CGRectMake(topLeft.frame.origin.x+10,
                                                        topLeft.frame.origin.y+10,
                                                        topLeft.frame.size.width,
                                                        topLeft.frame.size.height);
                             
                              topRight.frame = CGRectMake(topRight.frame.origin.x-10, topRight.frame.origin.y+10, topRight.frame.size.width, topRight.frame.size.height);
                              bottomLeft.frame = CGRectMake(bottomLeft.frame.origin.x+10, bottomLeft.frame.origin.y-10, bottomLeft.frame.size.width, bottomLeft.frame.size.height);
                              bottomRight.frame = CGRectMake(bottomRight.frame.origin.x-10, bottomRight.frame.origin.y-10, bottomRight.frame.size.width, bottomRight.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:1.0
                                              animations:^{
                                                  bigGiftBox.alpha=0.0;
                                                  topLeft.frame = CGRectMake(0,0,0,0);
                                                  topRight.frame = CGRectMake(bigGiftBox.frame.size.width,0,0,0);
                                                  bottomLeft.frame = CGRectMake(0,bigGiftBox.frame.size.height,0,0);
                                                  bottomRight.frame = CGRectMake(bigGiftBox.frame.size.width,bigGiftBox.frame.size.height,0,0);
                                              }
                                              completion:^(BOOL finished){
                                                  [bigGiftBox removeFromSuperview];
                                                  [topLeft removeFromSuperview];
                                                  [topRight removeFromSuperview];
                                                  [bottomLeft removeFromSuperview];
                                                  [bottomRight removeFromSuperview];
                                              }];
                         }];
        
    }else{
        
       // NSString* giftType = [[masterArrayOfDictionaries objectAtIndex:indexPath.row] objectForKey:@"giftType"];
        
        GiftHandlingView *giftHandlingScreen = [[GiftHandlingView alloc] initWithFrame:self.view.frame andADictionary:[masterArrayOfDictionaries objectAtIndex:indexPath.row]];
        [self.view addSubview:giftHandlingScreen];
        
        //UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        //[giftHandlingScreen addGestureRecognizer:pan];
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        /*
        if([giftType isEqualToString:@"flower"]){
            GiftHandlingView *giftHandlingScreen = [[GiftHandlingView alloc] initWithFrame:self.view.frame andADictionary:[masterArrayOfDictionaries objectAtIndex:indexPath.row]];
            [self.view addSubview:giftHandlingScreen];
            
            UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [giftHandlingScreen addGestureRecognizer:pan];
            
            self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        }else if([giftType isEqualToString:@"chocolate"]){
            ChocolateGiftScreen *chocGiftScreen = [[ChocolateGiftScreen alloc] initWithFrame:self.view.frame andADictionary:[masterArrayOfDictionaries objectAtIndex:indexPath.row]];
            [self.view addSubview:chocGiftScreen];
            
            UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [chocGiftScreen addGestureRecognizer:pan];
            
            self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        }else{
            DrinkGiftScreen *drinkGiftScreen = [[DrinkGiftScreen alloc] initWithFrame:self.view.frame andADictionary:[masterArrayOfDictionaries objectAtIndex:indexPath.row]];
            [self.view addSubview:drinkGiftScreen];
            
            UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [drinkGiftScreen addGestureRecognizer:pan];
            
            self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        }
         */
    }
    
}

#pragma mark UITableViewDelegate
- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    //do nothing
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
    NSString *imageName = [NSString stringWithFormat:@"backarrow.png"];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [profPicButton setImage:btnImage forState:UIControlStateNormal];
    [profPicButton addTarget:self action:@selector(profilePictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainNavBar addSubview:profPicButton];
    
    UIImageView* giftButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gift_solid.png"]];
    giftButton.frame = CGRectMake(half-20, stdYoffset, 40, 40);
    [mainNavBar addSubview:giftButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(screenRect.size.width - 60, stdYoffset, 40, 40);
    imageName = [NSString stringWithFormat:@"gift_solid.png"];
    btnImage = [UIImage imageNamed:imageName];
    [searchButton setImage:btnImage forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[mainNavBar addSubview:searchButton];
    
    [mainNavBar setBackgroundColor:UIColorFromRGB(kMasterColor)];
    
    [self.view addSubview:mainNavBar];
    
    mainNavBarOriginY = mainNavBar.frame.origin.y;
}

-(void)profilePictureButtonPressed:(id)sender{
    
    /*
    MasterRootViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterRootViewController"];
    vc.startingIndex = @"1";
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
     */
    
    /*
    NSString * storyboardName = @"MainStoryboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self presentViewController:vc animated:YES completion:nil];
     */
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)searchButtonPressed:(id)sender{
    [self performSegueWithIdentifier:@"toGive" sender:self];
}


//TRANSITION STUFF
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

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation];
    }
    return nil;
}

- (NSArray*)visibleCells
{
    return [self.infoTable visibleCells];
}

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
}

//SCROLLING RELATED
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    aScrollView.showsVerticalScrollIndicator=NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
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

-(NSDictionary*)fillDictionary:(NSString*)friendName
                      giftType:(NSString*)giftType
                  giftQuantity:(NSString*)giftQuantity
                    giftStatus:(NSString*)giftStatus
                 customMessage:(NSString*)customMessage
                  deliveryDate:(NSString*)deliveryDate
                   gifterImage:(NSString*)gifterImage
                    venueImage:(NSString*)venueImage
                    giftOpened:(NSString*)giftOpened
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          friendName, @"friendName",
                          giftType, @"giftType",
                          giftQuantity, @"giftQuantity",
                          giftStatus,@"giftStatus",
                          customMessage, @"customMessage",
                          deliveryDate, @"deliveryDate",
                          gifterImage, @"gifterImage",
                          venueImage,@"venueImage",
                          giftOpened,@"giftOpened",
                          nil];
    return dict;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
