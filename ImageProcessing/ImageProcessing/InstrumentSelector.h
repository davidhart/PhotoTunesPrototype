#import <Foundation/Foundation.h>

@class ViewController;

@interface InstrumentSelector : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    @private int _activeSelection;
    @private int _currentSelection;
    
    @private NSMutableArray* _options;
    @private NSObject* _completionObject;
    @private SEL _onCompletion;
}

@property (nonatomic, retain) IBOutlet ViewController* parent;
@property (nonatomic, retain) IBOutlet UIPickerView* pickerWheel;

-(IBAction)select:(id)sender;
-(IBAction)cancel:(id)sender;

-(void)setCompletionHandler:(NSObject*)object :(SEL)onCompletion;
-(void)setPickerNames:(NSMutableArray*)options;

-(int)getSelectionIndex;

-(void)show;
-(void)hide;

@end
