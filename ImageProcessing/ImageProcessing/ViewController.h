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
#import "PdAudioController.h"
#import "PdBase.h"

@interface ViewController : UITabBarController <PdReceiverDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate>
{
    PdFile * _patch;
    PdAudioController * _audio;
    UIImageView* imageView;
    UISlider* slider;
    UIProgressView* progress;
    ImageProperties* _imagePropertes;

    UIImagePickerController* imagePickerController;

    float _progressValue;
    int _numNotes;
    int _numIntruments;
    int _activeInstrument;
 
    float _currentDrumVolume;
    float _currentMelodyVolume;
    
    bool _repeatOn;
    bool _playing;
    
    UIPickerView *myPickerView;
    UIToolbar *toolbar;
    UIView *subView;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIProgressView* progress;

@property (nonatomic, retain) IBOutlet UIButton* buttonPlay;
@property (nonatomic, retain) IBOutlet UIButton* buttonRepeat;

@property (nonatomic, retain) IBOutlet UISlider* sliderTempo;
@property (nonatomic, retain) IBOutlet UISlider* sliderDrumVolume;
@property (nonatomic, retain) IBOutlet UISlider* sliderMelodyVolume;
@property (nonatomic, retain) IBOutlet UISlider* sliderSongLength;

-(void)initialize: (PdAudioController*) audio;

-(IBAction)playPressed:(id) sender;
-(IBAction)stopPressed:(id) sender;
-(IBAction)repeatPressed:(id)sender;

-(IBAction)cameraPressed:(id) sender;
-(IBAction)loadPressed:(id)sender;


-(IBAction)sliderTempoReleased:(id) sender;
-(IBAction)sliderDrumVolumeReleased:(id) sender;
-(IBAction)sliderMelodyVolumeReleased:(id) sender;
-(IBAction)sliderSongLengthReleased:(id) sender;

-(IBAction)instrumentsPressed:(id)sender;

-(IBAction)recordPressed:(id) sender;

-(void)toolBarDone;
-(void)toolBarBack;

-(void)receiveFloat:(float)received fromSource:(NSString *)source;

-(void)updateProgressView;

+(float)getNote:(float*)scale :(int)size :(float)locationOnScale;

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo;
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

-(void)startedPlaying;
-(void)stoppedPlaying;

-(void)activateImageChooser:(BOOL) camera;

-(void)setImage:(UIImage*) image;
-(void)updateValues:(UIImage*) image;

@end
