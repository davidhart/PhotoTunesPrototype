//
//  ViewController.m
//  ImageProcessing
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize imageView;
@synthesize slider;

-(void)sliderMoved:(id)sender
{
    ImageSlice* slice = [_imagePropertes getSlice: (int)([slider value] * ([_imagePropertes numSlices]-1))];
    
    UIColor* col = [UIColor alloc];
    col = [col initWithRed:[slice getAverageRed]/255.0f green:[slice getAverageGreen]/255.0f blue:[slice getAverageBlue]/255.0f alpha:1.0f];
    [self.view setBackgroundColor: col];
}

-(void)sliderReleased:(id)sender
{
    ImageSlice* slice = [_imagePropertes getSlice: (int)([slider value] * ([_imagePropertes numSlices]-1))];
    
    float f = 20.0f * [slice getAverageHue] / 255.0f + 60.0f;
    [PdBase sendFloat:f toReceiver:[NSString stringWithFormat:@"%d-pitch", _patch.dollarZero]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage* image = [UIImage imageNamed:@"images.jpeg"];
    [imageView setImage: image];
    
    _imagePropertes = [ImageProperties alloc];
    [_imagePropertes init:image];
    
    [PdBase setDelegate:self];
    
    _patch = [PdFile openFileNamed:@"wavetable.pd" path:[[NSBundle mainBundle] bundlePath]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
