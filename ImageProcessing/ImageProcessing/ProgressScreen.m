#import "ProgressScreen.h"
#import "ViewController.h"

@implementation ProgressView

@synthesize parent;
@synthesize progressBar;

-(void)setProgress:(float)progress
{
    progressBar.progress = progress;
}

@end
