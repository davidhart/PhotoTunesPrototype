#import <Foundation/Foundation.h>

@class ViewController;
@class ProgressView;


@interface ProgressView : UIViewController

@property (nonatomic, retain) IBOutlet UIProgressView* progressBar;
@property (nonatomic, retain) IBOutlet ViewController* parent;

-(void)setProgress:(float)progress;

@end
