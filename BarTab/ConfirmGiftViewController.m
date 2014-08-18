//
//  ConfirmGiftViewController.m
//  BarTab
//
//  Created by Sunny Shah on 7/25/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "ConfirmGiftViewController.h"

@interface ConfirmGiftViewController ()

@end

@implementation ConfirmGiftViewController

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
    
    /*
    IF WE NEED IT! 
     
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"myvid" ofType:@"m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
     
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    //set the frame of movie player
    self.moviePlayer.view.frame = CGRectMake(0, 0, 200, 200);
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer play];
     
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
