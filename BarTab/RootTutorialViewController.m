//
//  RootTutorialViewController.m
//  BarTab
//
//  Created by Sunny Shah on 7/23/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "RootTutorialViewController.h"

@interface RootTutorialViewController ()

@end

@implementation RootTutorialViewController

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
    // Create the data model
    _pageTitles = @[@"Tutorial Screen 1", @"Tutorial Screen 2", @"Tutorial Screen 3", @"Tutorial Screen 4"];
    _pageImages = @[@"paris2.jpg", @"paris3.jpg", @"paris4.jpg", @"paris2.jpg"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 70);
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self loadFacebookLogin];
    
    [self.view sendSubviewToBack:self.pageViewController.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWalkthrough:(id)sender {

    self.barTabViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BarTabViewController"];
    [self addChildViewController:_barTabViewController];
    [self.view addSubview:_barTabViewController.view];
    [self.barTabViewController didMoveToParentViewController:self];
    
    /*
    self.paymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    [self addChildViewController:_paymentViewController];
    [self.view addSubview:_paymentViewController.view];
    [self.paymentViewController didMoveToParentViewController:self];
     */
    
    /*
    self.givingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
    [self addChildViewController:_givingViewController];
    [self.view addSubview:_givingViewController.view];
    [self.givingViewController didMoveToParentViewController:self];
     */
    
    
    /*
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
     */
}

- (IBAction)startReceiving:(id)sender {
    self.receivingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReceivingViewController"];
    [self addChildViewController:_receivingViewController];
    [self.view addSubview:_receivingViewController.view];
    [self.receivingViewController didMoveToParentViewController:self];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

/*
-(void)moveOnToMainApp{
    NSLog(@"Here");
    self.givingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
    [self addChildViewController:_givingViewController];
    [self.view addSubview:_givingViewController.view];
    [self.givingViewController didMoveToParentViewController:self];
}
 */

/*FACEBOOK HANDLING */

-(void)loadFacebookLogin
{
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions: @[@"public_profile", @"email", @"user_friends", @"user_birthday", @"read_friendlists", @"user_status", @"user_photos"]];
    loginView.delegate = self;
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), (5.45*self.view.center.y/3));
    [self.view addSubview:loginView];
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.facebookUser = user;
    
    /*SEND ACCESS TOKEN TO SERVER*/
    
    /*
     self.paymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
     [self addChildViewController:_paymentViewController];
     [self.view addSubview:_paymentViewController.view];
     [self.paymentViewController didMoveToParentViewController:self];
     */
    
    /*
    self.givingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
    self.givingViewController.facebookUser = self.facebookUser;
    [self addChildViewController:_givingViewController];
    [self.view addSubview:_givingViewController.view];
    [self.givingViewController didMoveToParentViewController:self];
     */
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"We lost one!");
}

/*END FACEBOOK HANDLING*/


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
