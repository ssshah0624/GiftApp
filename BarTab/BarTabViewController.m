//
//  BarTabViewController.m
//  BarTab
//
//  Created by Sunny Shah on 7/18/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "BarTabViewController.h"

@interface BarTabViewController ()

@end

@implementation BarTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFacebookLogin];

    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    
    
    if ([[segue identifier] isEqualToString:@"toMain"])
    {
        NSLog(@"In to Main method");
        //GivingViewController *vc = [segue destinationViewController];
        //vc.facebookUser = self.facebookUser;
    }
}

/*FACEBOOK HANDLING */

-(void)loadFacebookLogin
{
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions: @[@"public_profile", @"email", @"read_stream", @"user_friends", @"user_birthday", @"read_friendlists", @"user_status", @"user_photos", @"friends_birthday"]];
    loginView.delegate = self;
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), (4*self.view.center.y/3));
    [self.view addSubview:loginView];
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.facebookUser = user;
    
    NSLog(@"About to post to server...");
    ServerCalls *server = [[ServerCalls alloc]init];
    [server postFBAuthToken:[NSString stringWithFormat:@"%@",[FBSession activeSession].accessTokenData]];
    
    
    /*SEND ACCESS TOKEN TO SERVER*/
    
/*
     self.paymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
     [self addChildViewController:_paymentViewController];
     [self.view addSubview:_paymentViewController.view];
     [self.paymentViewController didMoveToParentViewController:self];
 */

    //TEMPORARY SLATE
    /*
    self.givingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
     self.givingViewController.facebookUser = self.facebookUser;
    [self addChildViewController:_givingViewController];
    [self.view addSubview:_givingViewController.view];
    [self.givingViewController didMoveToParentViewController:self];
     */
    
    self.masterRootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterRootViewController"];
    //self.givingViewController.facebookUser = self.facebookUser;
    [self addChildViewController:_masterRootViewController];
    [self.view addSubview:_masterRootViewController.view];
    [self.masterRootViewController didMoveToParentViewController:self];
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"We lost one!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
