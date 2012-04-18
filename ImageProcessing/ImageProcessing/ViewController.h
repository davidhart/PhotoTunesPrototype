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

@class InstrumentSelector;
@class ProgressScreen;

@interface ViewController : UITabBarController <PdReceiverDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    PdFile * _patch;
    PdAudioController * _audio;
    UIImageView* imageView;
    UIProgressView* progress;
    ImageProperties* _imagePropertes;

    UIImagePickerController* imagePickerController;
    
    InstrumentSelector* _instrumentSelector;
    ProgressScreen* _progressScreen;
    
    float _progressValue;
    int _numNotes;
    int _numIntruments;
    int _activeInstrument;
 
    float _currentDrumVolume;
    float _currentMelodyVolume;
    
    bool _repeatOn;
    bool _playing;
}

@property (nonatomic, unsafe_unretained) PdAudioController* _audio;

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
-(IBAction)sliderSongLengthChanged:(id)sender;

-(IBAction)instrumentsPressed:(id)sender;

-(IBAction)recordPressed:(id) sender;

-(void)receiveFloat:(float)received fromSource:(NSString *)source;

-(void)updateProgressView;

+(float)getNote:(float*)scale :(int)size :(float)locationOnScale;

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo;
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

-(void)startedPlaying;
-(void)stoppedPlaying;

-(void)activateImageChooser:(BOOL) camera;

-(void)setImage:(UIImage*) image;
-(void)updateSongValues;

-(void)changeInstrument:(NSString*) soundFile;

@end
