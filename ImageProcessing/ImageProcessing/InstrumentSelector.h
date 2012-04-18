//
//  InstrumentSelector.h
//  ImageProcessing
//
//  Created by MEng on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;

@interface InstrumentSelector : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>
{
    int _activeSelection;
    int _currentSelection;
    
    UIPickerView* _myPickerView;
    UIToolbar* _toolbar;
    UIView* _subView;
    
    ViewController* _parent;
}

-(id)init:(ViewController*) parent;

-(void)show;
-(void)hide;

@end
