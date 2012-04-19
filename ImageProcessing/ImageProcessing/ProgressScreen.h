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
    @private UIToolbar* _toolbar;
    @private UIView* _subView;
    @private UILabel* _titleLabel;
    @private UIProgressView* _progressView;
    
    @private __unsafe_unretained ViewController* _parent;
}

-(id)init:(ViewController*)parent;

-(void)show;
-(void)hide;
-(bool)isVisible;

-(void)setTitle:(NSString*) title;
-(void)setProgress:(float)progress;

@end
