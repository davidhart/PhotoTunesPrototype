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
#import "AchievementsView.h"

@class InstrumentSelector;
@class ProgressScreen;

@interface ViewController : UITabBarController <PdReceiverDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    @private PdFile * _patch;
    @private __unsafe_unretained PdAudioController * _audio;
    @private UIImageView* imageView;
    @private UIProgressView* progress;
    @private ImageProperties* _imagePropertes;

    @private UIImagePickerController* imagePickerController;
    
    @private InstrumentSelector* _instrumentSelector;
    @private ProgressScreen* _progressScreen;
    
    @private float _progressValue;
    @private int _numNotes;
    @private int _numIntruments;
    @private int _activeInstrument;
 
    @private float _currentDrumVolume;
    @private float _currentMelodyVolume;
    
    @private float _lowestSlice;
    @private float _highestSlice;
    
    @private bool _repeatOn;
    @private bool _playing;
    
    @private AchievementsView* _acheivementsView;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIProgressView* progress;

@property (nonatomic, retain) IBOutlet UIButton* buttonPlay;
@property (nonatomic, retain) IBOutlet UIButton* buttonRepeat;

@property (nonatomic, retain) IBOutlet UISlider* sliderTempo;
@property (nonatomic, retain) IBOutlet UISlider* sliderDrumVolume;
@property (nonatomic, retain) IBOutlet UISlider* sliderMelodyVolume;
@property (nonatomic, retain) IBOutlet UISlider* sliderSongLength;

@property (nonatomic, retain) IBOutlet UIToolbar* achievementsToolbar;
@property (nonatomic, retain) IBOutlet UIScrollView* achievementsScrollView;

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
