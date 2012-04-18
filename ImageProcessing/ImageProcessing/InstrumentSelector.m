//
//  InstrumentSelector.m
//  ImageProcessing
//
//  Created by MEng on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentSelector.h"
#import "ViewController.h"


@implementation InstrumentSelector

-(id)init:(ViewController *)parent
{
    self = [super init];
    
    if (self)
    {
        _activeSelection = 0;
        _currentSelection = 0;
        
        _parent = parent;
        
        // SubView for instrument selection
        _subView=[[UIView alloc] init];
        _subView.frame=CGRectMake(0, 0, parent.view.frame.size.width, parent.view.frame.size.height);
        _subView.backgroundColor = [UIColor colorWithRed:0.0 
                                                   green:0.0 
                                                    blue:0.0 
                                                   alpha:1.0];
        
        //  Make a new picker view for instrument selector subview
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 63, 320, 200)];
        _myPickerView.delegate = self;
        _myPickerView.showsSelectionIndicator = YES;
        
        // Make a new toolbar for instrument selector subview
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.frame = CGRectMake(0, 19, parent.view.frame.size.width, 44);
        
        //Add a done button
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarDone)];
        
        // Add a title and padding to centre the title
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 172, 23)];
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.shadowColor = [UIColor colorWithRed:0.0 
                                            green:0.0 
                                             blue:0.0 
                                            alpha:1.0];
        label.shadowOffset = CGSizeMake(0, 1);
        label.textColor = [UIColor colorWithRed:1.0 
                                          green:1.0 
                                           blue:1.0 
                                          alpha:1.0];
        
        label.text = @"Instruments";
        label.font = [UIFont boldSystemFontOfSize:20.0];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:label];
        
        // Add a cancel button
        UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarBack)];  
        
        // Add buttons to toolbar
        NSArray *buttons = [NSArray arrayWithObjects: item3, item2, item1, nil];
        [_toolbar setItems: buttons animated:NO];
        
        // Set up the subview for the instruments selector and hide it untill used
        [parent.view addSubview:_subView];
        [_subView addSubview:_myPickerView];
        [_subView addSubview:_toolbar];
        
        [self hide];
    }
    
    return self;
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
    NSString *instrumentList[] = {@"Guitar", @"Bell", @"Test 3", @"Test 4", @"Test 5"};
    
    return instrumentList[row];
} 

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component 
{ 
    int sectionWidth = 300;  
    return sectionWidth;
}

// Done button on toolbar in UIPicker
-(void)toolBarDone
{
    NSString *instrumentList[] = {@"guitar.wav", @"bell.aiff", @"Test 3", @"Test 4", @"Test 5"};
    
    _activeSelection = _currentSelection;
    [_parent changeInstrument:instrumentList[_activeSelection]];
    
    [self hide];
}

// Handle the selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component 
{    
    _currentSelection = row;
} 

// Back button on toolbar in UIPicker
-(void)toolBarBack
{
    [self hide];
}

-(void)show
{
    [_myPickerView selectRow:_currentSelection inComponent:0 animated:NO];
    [_subView setHidden:FALSE];
}

-(void)hide
{
    [_subView setHidden:TRUE];
}

@end
