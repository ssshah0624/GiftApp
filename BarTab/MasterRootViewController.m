//
//  MasterRootViewController.m
//  BarTab
//
//  Created by Sunny Shah on 8/20/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "MasterRootViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kMasterColor 0x51B0BD

@interface MasterRootViewController ()

@end

@implementation MasterRootViewController

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
    [self.view setBackgroundColor:UIColorFromRGB(kMasterColor)];
    
    // Create the data model
    _pageTitles = @[@"Settings View Controller", @"Giving View Controller", @"Receiving View Controller"];
    _pageImages = @[@"paris2.jpg", @"paris2.jpg", @"paris3.jpg"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterPageViewController"];
    self.pageViewController.dataSource = self;
    
    
    //GivingViewController *startingViewController = (GivingViewController*)[self viewControllerAtIndex:1];
    
    //potential override for starting VC
    if(self.startingIndex == nil){
        NSLog(@"THIS STRING IS EMPTY");
        GivingViewController* startingViewController = (GivingViewController*)[self viewControllerAtIndex:1];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
        [self.view sendSubviewToBack:self.pageViewController.view];
        
        //Splash View
        UIImage *icon = [UIImage imageNamed:@"gift.png"];
        UIColor *color = [UIColor blueColor];
        CBZSplashView *splashView = [[CBZSplashView alloc] initWithIcon:icon backgroundColor:color];
        //[self loadMainNavBar];
        [self.view addSubview:splashView];
        [splashView startAnimation];
    }else if([self.startingIndex intValue] == 0)
    {
        SettingsViewController* startingViewController = (SettingsViewController*)[self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
        [self.view sendSubviewToBack:self.pageViewController.view];
    }else if([self.startingIndex intValue] == 1)
    {
        GivingViewController* startingViewController = (GivingViewController*)[self viewControllerAtIndex:1];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
        [self.view sendSubviewToBack:self.pageViewController.view];
    }else if([self.startingIndex intValue] == 2)
    {
        ReceivingViewController* startingViewController = (ReceivingViewController*)[self viewControllerAtIndex:2];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
        [self.view sendSubviewToBack:self.pageViewController.view];
    }
    
    /*
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view sendSubviewToBack:self.pageViewController.view];
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWalkthrough:(id)sender {
    NSLog(@"START WALKTHROUGH");
    /*
    self.givingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
    [self addChildViewController:self.givingVC];
    [self.view addSubview:self.givingVC.view];
    [self.givingVC didMoveToParentViewController:self];
     */
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((GivingViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((GivingViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    
    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }

    
    if(index==0){
        SettingsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        pageContentViewController.pageIndex = index;
        return pageContentViewController;
    }else if(index==1){
        GivingViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
        pageContentViewController.pageIndex = index;
        return pageContentViewController;
    }else if(index==2){
        ReceivingViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReceivingViewController"];
        pageContentViewController.pageIndex = index;
        return pageContentViewController;
    }else{
        NSLog(@"Not sure wtf is happening...");
    }

    
    /*
    if(index==0){
        GivingViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
        pageContentViewController.pageIndex = index;
        return pageContentViewController;
    }else if(index==1){
        ReceivingViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReceivingViewController"];
        pageContentViewController.pageIndex = index;
        return pageContentViewController;
    }else{
        NSLog(@"Not sure wtf is happening...");
    }
     */
    
    //Dead code
    GivingViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GivingViewController"];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
