#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class ViewController;

@interface ImageLoading : UIViewController<ADBannerViewDelegate>
{
    @private int _activeSelection;
    @private int _currentSelection;
    
    @private UIPickerView* _myPickerView;
    @private UIToolbar* _toolbar;
    @private UIView* _subView;
    
    @private __unsafe_unretained ViewController* _parent;
}

@property (nonatomic, retain) IBOutlet ADBannerView* adbanner;

-(IBAction)cancel:(id)sender;

-(void)setParent:(ViewController*) parent;

-(void)show;
-(void)hide;

@end
