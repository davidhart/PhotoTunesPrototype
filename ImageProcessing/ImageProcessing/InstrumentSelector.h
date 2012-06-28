//
//  InstrumentSelector.h
//  ImageProcessing
//
//  Created by MEng on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;

@interface InstrumentSelector : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    @private int _activeSelection;
    @private int _currentSelection;
    
    @private NSArray* _options;
    @private NSObject* _completionObject;
    @private SEL _onCompletion;
}

@property (nonatomic, retain) IBOutlet ViewController* parent;
@property (nonatomic, retain) IBOutlet UIPickerView* pickerWheel;

-(IBAction)select:(id)sender;
-(IBAction)cancel:(id)sender;

-(void)setCompletionHandler:(NSObject*)object: (SEL)onCompletion;
-(void)setPickerNames:(NSArray*)options;

-(int)getSelectionIndex;

-(void)show;
-(void)hide;

@end
