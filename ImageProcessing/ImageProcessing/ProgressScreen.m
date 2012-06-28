//
//  ProgressScreen.m
//  ImageProcessing
//
//  Created by MEng on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressScreen.h"
#import "ViewController.h"

@implementation ShareView

@synthesize parent;
@synthesize progressView;

-(void)cancel:(id)sender
{
    [parent dismissModalViewControllerAnimated:YES];
}

-(void)saveAndUpload:(id)sender
{
    [parent dismissViewControllerAnimated:YES completion:^{
        [parent beginRecording];
    }];
}


@end


@implementation ProgressView

@synthesize parent;
@synthesize progressBar;

-(void)setProgress:(float)progress
{
    progressBar.progress = progress;
}

@end
