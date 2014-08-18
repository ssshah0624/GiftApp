//
//  ReceivingViewController.m
//  BarTab
//
//  Created by Sunny Shah on 7/24/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "ReceivingViewController.h"

@interface ReceivingViewController () <UINavigationControllerDelegate>

@end

@implementation ReceivingViewController
{
    NSMutableArray *venueData;
    NSMutableArray *gifterData;
    NSMutableArray *giftValueData;
    NSMutableArray *venueImageData;
    NSMutableArray *qrCodeData;
    
    NSString *selectedValue;
    KLCPopup *popup;
    
    BOOL popTipShowing;
    AMPopTip* popTip;
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
	// Do any additional setup after loading the view.
    
    venueData = [NSMutableArray arrayWithObjects:@"Dragon Bar", @"Ice Bar", @"Han Dynasty", @"Distrito", nil];
    gifterData = [NSMutableArray arrayWithObjects:@"Xing Wang", @"Max Wolff", @"Kishan Shah", @"Ronak Gandhi", nil];
    venueImageData = [NSMutableArray arrayWithObjects:@"reclogo1.png", @"reclogo2.png", @"reclogo3.png", @"reclogo4.png", nil];
    giftValueData = [NSMutableArray arrayWithObjects:@"75", @"21", @"50", @"35", nil];
    qrCodeData = [NSMutableArray arrayWithObjects:@"qr1.png", @"qr2.png", @"qr3.png", @"qr4.jpg", nil];
    
    _interactive = [[AMWaveTransition alloc] init];
    popTipShowing=false;
}

//TABLE SETUP
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [venueData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [self.giftWindow dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Sunny's workaround for dequeueResuableCell..
    [[cell.contentView viewWithTag:20] removeFromSuperview];
    [[cell.contentView viewWithTag:21] removeFromSuperview];
    [[cell.contentView viewWithTag:22] removeFromSuperview];
    [[cell.contentView viewWithTag:23] removeFromSuperview];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //Locked in CGRect position
    UILabel *venueName = [[UILabel alloc] initWithFrame:CGRectMake(10,10,cell.frame.size.width,44)];
    venueName.text = [venueData objectAtIndex:indexPath.row];
    venueName.textAlignment=UITextAlignmentLeft;
    venueName.font= [UIFont boldSystemFontOfSize:20];
    venueName.backgroundColor=[UIColor clearColor];
    venueName.tag=20;
    [cell.contentView addSubview:venueName];
    
    UILabel *giftValue= [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2,30,cell.frame.size.width/2-10,94)];
    giftValue.text = [NSString stringWithFormat:@"$%@", [giftValueData objectAtIndex:indexPath.row]];
    giftValue.textAlignment=UITextAlignmentLeft;
    giftValue.font= [UIFont boldSystemFontOfSize:25];
    giftValue.backgroundColor=[UIColor clearColor];
    giftValue.tag=21;
    [cell.contentView addSubview:giftValue];
    
    UILabel *gifterInfo= [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2,80,cell.frame.size.width/2-10,94)];
    gifterInfo.text = [NSString stringWithFormat:@"Courtesy of: %@", [gifterData objectAtIndex:indexPath.row]];
    gifterInfo.lineBreakMode = NSLineBreakByWordWrapping;
    gifterInfo.numberOfLines = 0;
    gifterInfo.textAlignment=UITextAlignmentLeft;
    gifterInfo.font= [UIFont italicSystemFontOfSize:14];
    gifterInfo.backgroundColor=[UIColor clearColor];
    gifterInfo.tag=22;
    [cell.contentView addSubview:gifterInfo];
    
    
    //UIImage* image = [[UIImage alloc] initWithContentsOfFile:[friendPictures objectAtIndex:indexPath.row]];
    UIImage* image = [[UIImage alloc] init];
    image = [UIImage imageNamed:[venueImageData objectAtIndex:indexPath.row]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.layer.cornerRadius = 55;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 2.0f;
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.frame = CGRectMake(10,50,110,110);
    imageView.tag=23;
    [cell.contentView addSubview:imageView];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self displayPopup:indexPath.row];
}

-(void)displayPopup:(CGFloat)indexPathRow
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0,0,screenRect.size.width*.6,screenRect.size.width*.6);

    //Add image of QR Code + Text
    /*
    UILabel *venueName= [[UILabel alloc] initWithFrame:CGRectMake(5,5,screenRect.size.width*0.4,44)];
    venueName.text = [NSString stringWithFormat:@"Redeem at %@",[venueData objectAtIndex:indexPathRow]];
    venueName.textAlignment=UITextAlignmentLeft;
    venueName.font= [UIFont boldSystemFontOfSize:14];
    venueName.backgroundColor=[UIColor clearColor];
    [contentView addSubview:venueName];
    */
    
    /*
    UIImage* image = [[UIImage alloc] init];
    image = [UIImage imageNamed:[qrCodeData objectAtIndex:indexPathRow]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0,0,screenRect.size.width*0.6,screenRect.size.width*0.6);
    //[contentView addSubview:imageView];
     */
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,0,screenRect.size.width*0.6,screenRect.size.width*0.6);
    UIImage *btnImage = [UIImage imageNamed:[qrCodeData objectAtIndex:indexPathRow]];
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showTip:) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [btn.layer setBorderWidth: 2.0];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [contentView addSubview:btn];

    
    //if clicked, allow poptip to show

    
    popup = [KLCPopup popupWithContentView:contentView];
    [popup show];
}

-(void)showTip:(id)sender{
    if(!popTipShowing){
        popTip = [AMPopTip popTip];
        popTip.popoverColor = [UIColor blueColor];
        [popTip showText:@"Present QR code at selected venue to redeem gift" direction:AMPopTipDirectionUp maxWidth:200 inView:popup.contentView fromFrame:popup.frame];
        popTipShowing=true;
    }else{
        [popTip hide];
        popTipShowing=false;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    //do nothing
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
    return [self.giftWindow visibleCells];
}

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
