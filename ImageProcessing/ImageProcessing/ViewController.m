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
    [PdBase sendFloat: 60000.0f / ([slider value] * 400.0f + 60.0f) toReceiver:[NSString stringWithFormat:@"%d-tempo", _patch.dollarZero]];
}

-(void)playPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"startPlayback"];
}

-(void)pausePressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"pausePlayback"];
}

-(void)stopPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"stopPlayback"];
}

-(void)sinePressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"sine"];
}

-(void)sawPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"saw"];
}

-(void)harmonicPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"harm"];
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
    
    const int length = 120;
    
    float values [length];
    
    for (int i = 0; i < length; i++)
    {
        ImageSlice* slice = [_imagePropertes getSlice: (int)((i / (float)length) * ([_imagePropertes numSlices]-1))];
        
        float f = 20.0f * [slice getAverageHue] / 255.0f + 60.0f;
        
        NSLog(@"%f",f);
        
        values[i] = f;
    }
 
    [PdBase copyArray:values toArrayNamed:@"seq" withOffset:0 count:length];
    [PdBase sendFloat:length toReceiver:[NSString stringWithFormat:@"%d-length", _patch.dollarZero]];
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
