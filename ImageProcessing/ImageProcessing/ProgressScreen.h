//
//  ProgressScreen.h
//  ImageProcessing
//
//  Created by MEng on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;

@interface ProgressScreen : NSObject
{
    UIToolbar* _toolbar;
    UIView* _subView;
    UILabel* _titleLabel;
    
    UIProgressView* _progressView;
    
    ViewController* _parent;
}

-(ProgressScreen*)init:(ViewController*)parent;

-(void)show;
-(void)hide;
-(bool)isVisible;

-(void)setTitle:(NSString*) title;
-(void)setProgress:(float)progress;

@end
