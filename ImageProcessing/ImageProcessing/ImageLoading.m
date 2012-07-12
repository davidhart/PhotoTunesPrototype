//
//  ImageLoading.m
//  ImageProcessing
//
//  Created by MEng on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageLoading.h"
#import "ViewController.h"

@implementation ImageLoading

@synthesize adbanner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[adbanner removeFromSuperview];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setParent:(ViewController *)parent
{
    _parent = parent;
}

-(void)show
{
    //[self.view addSubview: adbanner];
    [_parent presentModalViewController: self animated:YES];
}

-(void)hide
{    
    //[adbanner removeFromSuperview];
    [_parent dismissModalViewControllerAnimated: YES];
}

-(void)cancel:(id)sender
{
    [self hide];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

-(void)bannerViewDidLoadAd:(ADBannerView*)banner
{

}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{

}

@end
