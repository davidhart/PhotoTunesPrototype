//
//  ViewController.h
//  ImageProcessing
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageProperties.h"
#import "PdFile.h"
#import "PdBase.h"

@interface ViewController : UIViewController <PdReceiverDelegate>
{
    PdFile * _patch;
    UIImageView* imageView;
    UISlider* slider;
    UIProgressView* progress;
    ImageProperties* _imagePropertes;
    
    float _progressValue;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UISlider* slider;
@property (nonatomic, retain) IBOutlet UIProgressView* progress;

-(IBAction)sliderMoved:(id) sender;
-(IBAction)sliderReleased:(id) sender;

-(IBAction)playPressed:(id) sender;
-(IBAction)pausePressed:(id) sender;
-(IBAction)stopPressed:(id) sender;
-(IBAction)sinePressed:(id) sender;
-(IBAction)sawPressed:(id) sender;
-(IBAction)harmonicPressed:(id) sender;

-(void)receiveFloat:(float)received fromSource:(NSString *)source;

-(void)updateProgressView;

@end
