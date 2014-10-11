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
#import <QuartzCore/QuartzCore.h>
#import <MBAlertView.h>
#import <AMWaveTransition.h>
#import "ReceivingViewController.h"
#import "STPView.h"
#import <CBZSplashView.h>
#import <BDKNotifyHUD.h>
#import "RoseGiftScreen.h"
#import "ChocolateGiftScreen.h"
#import "DrinkGiftScreen.h"
#import "MasterRootViewController.h"

//AddressBook stuff
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactsData.h"


@interface GivingViewController : UIViewController <STPViewDelegate, ABPeoplePickerNavigationControllerDelegate>


//FOR PAGE CONTENT VIEW CONTROLLER
@property NSUInteger pageIndex;

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

@property GivingViewController* rvc;
@property (strong, nonatomic) IBOutlet AMWaveTransition *interactive;

@property STPView* stripeView;
@property UIButton* saveButton;

@property NSIndexPath* selectedRowIndex;

@property UIDynamicAnimator* animator;

//ADDRESS BOOK
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
-(void)showAddressBook;
@property (nonatomic, strong) NSMutableArray *arrContactsData;
@property (nonatomic, strong) NSDictionary *dictContactDetails;
@property (nonatomic, weak) IBOutlet UILabel *lblContactName;
@property (nonatomic, weak) IBOutlet UIImageView *imgContactImage;
@property (nonatomic, weak) IBOutlet UITableView *tblContactDetails;

@property (strong, nonatomic) IBOutlet UIView *homeDrinkView;

@end
