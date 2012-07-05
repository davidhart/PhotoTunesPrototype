#import "ProgressScreen.h"
#import "ViewController.h"

@implementation ShareView

@synthesize parent;
@synthesize progressView;

-(void)cancel:(id)sender
{
    [parent dismissModalViewControllerAnimated:YES];
}

-(void)saveAndUpload:(id)sender
{
    [parent dismissViewControllerAnimated:YES completion:^{
        [parent beginRecording];
    }];
}


@end


@implementation ProgressView

@synthesize parent;
@synthesize progressBar;

-(void)setProgress:(float)progress
{
    progressBar.progress = progress;
}

@end
