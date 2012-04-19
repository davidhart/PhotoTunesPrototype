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
    @private int _activeSelection;
    @private int _currentSelection;
    
    @private UIPickerView* _myPickerView;
    @private UIToolbar* _toolbar;
    @private UIView* _subView;
    
    @private __unsafe_unretained ViewController* _parent;
}

-(id)init:(ViewController*) parent;

-(void)show;
-(void)hide;

@end
