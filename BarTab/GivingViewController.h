//
//  GivingViewController.h
//  BarTab
//
//  Created by Sunny Shah on 7/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "KLCPopup.h"
#import "YHCPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import <AMPopTip.h>
#import <MBAlertView.h>
#import <AMWaveTransition.h>
#import "ReceivingViewController.h"
#import "STPView.h"
#import <CBZSplashView.h>
#import <BFPaperTableViewCell.h>
#import <EFCircularSlider.h>
#import <MCSwipeTableViewCell.h>
#import <TOMSMorphingLabel.h>
#import <BDKNotifyHUD.h>
#import "RoseGiftScreen.h"
#import "ChocolateGiftScreen.h"
#import "DrinkGiftScreen.h"

@interface GivingViewController : UIViewController <STPViewDelegate, MCSwipeTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property id<FBGraphUser> facebookUser;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *usersWithBirthdays;
@property (strong, nonatomic) IBOutlet UITextField *wallPostTextField;

@property NSMutableArray* friendInfoFromStatus;
@property NSMutableArray* friendsDisplayed;

@property UIActivityIndicatorView *activityView;
- (IBAction)buttonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *infoTable;
@property (strong, nonatomic) IBOutlet UITableViewCell *infoCell;

@property ReceivingViewController* rvc;
@property (strong, nonatomic) IBOutlet AMWaveTransition *interactive;

@property STPView* stripeView;
@property UIButton* saveButton;

@property MCSwipeTableViewCell* cellToDelete;

@property NSIndexPath* selectedRowIndex;

@property UIDynamicAnimator* animator;


#pragma mark - MCSwipeTableViewCellDelegate

// Called when the user starts swiping the cell.
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell;

// Called when the user ends swiping the cell.
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell;

// Called during a swipe.
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage;

@end
