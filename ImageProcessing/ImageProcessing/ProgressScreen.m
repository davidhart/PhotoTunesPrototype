//
//  ProgressScreen.m
//  ImageProcessing
//
//  Created by MEng on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressScreen.h"
#import "ViewController.h"

@implementation ProgressScreen

-(id)init:(ViewController*)parent
{
    self = [super init];
    
    if (self)
    {
        _parent = parent;
        
        // Create subview
        _subView=[[UIView alloc] init];
        _subView.frame = CGRectMake(0, 0, parent.view.frame.size.width, parent.view.frame.size.height);
        _subView.backgroundColor = [UIColor colorWithRed:0.0 
                                                   green:0.0 
                                                    blue:0.0 
                                                   alpha:1.0];
        
        // Create a toolbar
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.frame = CGRectMake(0, 19, parent.view.frame.size.width, 44);
        
        
        
        // Add a title and padding to centre the title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, parent.view.frame.size.width-20, 23)];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.shadowColor = [UIColor colorWithRed:0.0 
                                                  green:0.0 
                                                   blue:0.0 
                                                  alpha:1.0];
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.textColor = [UIColor colorWithRed:1.0 
                                                green:1.0 
                                                 blue:1.0 
                                                alpha:1.0];
        
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, parent.view.frame.size.height / 2, parent.view.frame.size.width - 20 * 2, 30)];
        
        UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:_titleLabel];
        NSArray *buttons = [NSArray arrayWithObjects: titleButton, nil];
        [_toolbar setItems: buttons animated:NO];
        
        // Set up the subview for the instruments selector and hide it untill used
        [parent.view addSubview:_subView];
        [_subView addSubview:_toolbar];
        [_subView addSubview:_progressView];
        
        [self hide];
    }
    
    return self;
}

-(void)show
{
    [_subView setHidden:FALSE];
}

-(void)hide
{
    [_subView setHidden:TRUE];
}

-(bool)isVisible
{
    return ![_subView isHidden];
}

-(void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

-(void)setProgress:(float)progress
{
    _progressView.progress = progress;
}

@end
