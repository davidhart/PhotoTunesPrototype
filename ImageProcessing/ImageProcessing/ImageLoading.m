//
//  ImageLoading.m
//  ImageProcessing
//
//  Created by MEng on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageLoading.h"
#import "ViewController.h"

@interface ImageLoading ()

@end

@implementation ImageLoading

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
    [_parent presentModalViewController: self animated:YES];
}

-(void)hide
{    
    [_parent dismissModalViewControllerAnimated: YES];
}

-(void)cancel:(id)sender
{
    [self hide];
}

@end
