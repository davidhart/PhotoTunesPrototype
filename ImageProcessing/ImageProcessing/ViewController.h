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
    ImageProperties* _imagePropertes;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UISlider* slider;

-(IBAction)sliderMoved:(id) sender;

@end
