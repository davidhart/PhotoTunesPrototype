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
#import "PdAudio.h"
#import "PdBase.h"

@interface ViewController : UITabBarController <PdReceiverDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate>
{
    PdFile * _patch;
    PdAudio * _audio;
    UIImageView* imageView;
    UISlider* slider;
    UIProgressView* progress;
    ImageProperties* _imagePropertes;

    UIImagePickerController* imagePickerController;

    float _progressValue;
    int _numNotes;
    int _numIntruments;
    
    int _activeInstrument;
    
    UIPickerView *myPickerView;
    UIToolbar *toolbar;
    UIView *subView;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UISlider* slider;
@property (nonatomic, retain) IBOutlet UIProgressView* progress;

@property (nonatomic, retain) IBOutlet UISwitch* repeatSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* drumsSwitch;

-(void)initialize: (PdAudio*) audio;


-(IBAction)sliderReleased:(id) sender;

-(IBAction)playPressed:(id) sender;
-(IBAction)pausePressed:(id) sender;
-(IBAction)stopPressed:(id) sender;

-(IBAction)cameraPressed:(id) sender;
-(IBAction)loadPressed:(id)sender;

-(IBAction)repeatPressed:(id)sender;
-(IBAction)drumsPressed:(id)sender;

-(IBAction)instrumentsPressed:(id)sender;

-(void)toolBarDone;
-(void)toolBarBack;

-(void)receiveFloat:(float)received fromSource:(NSString *)source;

-(void)updateProgressView;

+(float)getNote:(float*)scale :(int)size :(float)locationOnScale;

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo;
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

-(void)activateImageChooser:(BOOL) camera;

-(void)setImage:(UIImage*) image;
-(void)updateValues:(UIImage*) image;

@end
