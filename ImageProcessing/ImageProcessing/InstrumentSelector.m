//
//  InstrumentSelector.m
//  ImageProcessing
//
//  Created by MEng on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentSelector.h"
#import "ViewController.h"

const float SELECTOR_HEIGHT = 120.0f;

@implementation InstrumentSelector

-(void)setParent:(ViewController *)parent
{
    _parent = parent;
}

// tell the picker how many components it will have
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{ 
    return 1;
} 

-(NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{    
    return 5;
}

// tell the picker the title for a given component
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{    
    NSString *instrumentList[] = {@"Guitar", @"Bell", @"Electronic", @"Test 4", @"Test 5"};
    
    return instrumentList[row];
} 

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component 
{ 
    int sectionWidth = 300;  
    return sectionWidth;
}

// Handle the selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component 
{    
    _currentSelection = row;
} 

-(void)show
{
    [_parent presentModalViewController: self animated:YES];
    
    [_myPickerView selectRow:_currentSelection inComponent:0 animated:NO];
}

-(void)hide
{    
    [_parent dismissModalViewControllerAnimated: YES];
}

-(void)cancel:(id)sender
{
    [self hide];
}

-(void)select:(id)sender
{
    NSString *instrumentList[] = {@"a.wav", @"bell.aiff", @"synth.wav", @"Test 4", @"Test 5"};
    
    _activeSelection = _currentSelection;
    [_parent changeInstrument:instrumentList[_activeSelection]];
    
    [self hide];
}

@end
