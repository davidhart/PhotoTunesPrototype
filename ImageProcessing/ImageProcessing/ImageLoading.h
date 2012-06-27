//
//  ImageLoading.h
//  ImageProcessing
//
//  Created by MEng on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface ImageLoading : UIViewController
{
@private int _activeSelection;
@private int _currentSelection;
    
@private UIPickerView* _myPickerView;
@private UIToolbar* _toolbar;
@private UIView* _subView;
    
@private __unsafe_unretained ViewController* _parent;
}

-(IBAction)cancel:(id)sender;

-(void)setParent:(ViewController*) parent;

-(void)show;
-(void)hide;

@end
