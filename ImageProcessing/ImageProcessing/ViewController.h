#import <UIKit/UIKit.h>
#import "ImageProperties.h"
#import "PdFile.h"
#import "PdAudioController.h"
#import "PdBase.h"
#import "AchievementsView.h"
#import "StoreView.h"

@class InstrumentSelector;
@class SplashScreen;
@class ImageLoading;

@class ProgressView;

@interface InstrumentPack : NSObject
{
    @public NSString* Key;
    @public NSString* DisplayName;
    @public NSString* WaveFile;
};

-(InstrumentPack*)init: (NSString*)key :(NSString*)displayName :(NSString*)waveFile;

@end

@interface  DrumPack : NSObject
{
    @public NSString* Key;
    @public NSString* DisplayName;
    @public NSMutableArray* WaveFiles;
};

-(DrumPack*)init: (NSString*)key :(NSString*)displayName :(NSMutableArray*)waveFile;

@end

@interface ViewController : UITabBarController <PdReceiverDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    @private PdFile * _patch;
    @private __unsafe_unretained PdAudioController * _audio;
    @private UIImageView* imageView;
    @private ImageProperties* _imagePropertes;

    @private UIImagePickerController* imagePickerController;
    
    @private float _progressValue;
    @private int _numNotes;
    @private int _numIntruments;
    @private int _activeInstrument;
    
    //0 Nothing
    //1 Load photo
    //2 Take photo
    @private int _lastTypeLoaded;
 
    @private float _currentDrumVolume;
    @private float _currentMelodyVolume;
    
    @private float _lowestSlice;
    @private float _highestSlice;
    
    @private bool _repeatOn;
    @private bool _playing;
    
    @private bool _helpVisible;
    
    @private AchievementsTracker* _achievements;
    @private StoreTracker* _store;
    
    @private UIImage* _helpofficon;
    @private UIImage* _helponicon;
    
    @private UIView* _seekbarView;
    @private CGRect _onScreenImageRect;
    
    @private NSTimer* _helpTextTimer;
    @private UILabel* _flashingHelpText;
    @private UIImageView* _flashingHelpImage;
    
    @private NSMutableArray* _instruments;
    @private NSMutableArray* _drums;
    
    @private NSMutableArray* _defaultInstruments;
    @private NSMutableArray* _defaultDrums;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;

@property (nonatomic, retain) IBOutlet UIButton* buttonPlay;
@property (nonatomic, retain) IBOutlet UIButton* buttonRepeat;
@property (nonatomic, retain) IBOutlet UIButton* buttonHelp;
@property (nonatomic, retain) IBOutlet UIButton* buttonPrimaryInstrument;
@property (nonatomic, retain) IBOutlet UIButton* buttonDrums;

@property (nonatomic, retain) IBOutlet UISlider* sliderTempo;
@property (nonatomic, retain) IBOutlet UISlider* sliderDrumVolume;
@property (nonatomic, retain) IBOutlet UISlider* sliderMelodyVolume;
@property (nonatomic, retain) IBOutlet UISlider* sliderSongLength;

@property (nonatomic, retain) IBOutlet UIToolbar* achievementsToolbar;
@property (nonatomic, retain) IBOutlet UIScrollView* achievementsScrollView;

@property (nonatomic, retain) IBOutlet UIScrollView* storeScrollView;
@property (nonatomic, retain) IBOutlet UIBarItem* storePagePoints;
@property (nonatomic, retain) IBOutlet UIBarItem* storePageUnlocks;

@property (nonatomic, retain) IBOutlet UIScrollView* mainScrollView;
@property (nonatomic, retain) IBOutlet UIView* mainView;

@property (nonatomic, retain) IBOutlet InstrumentSelector* instrumentSelector;
@property (nonatomic, retain) IBOutlet SplashScreen* splashScreen;
@property (nonatomic, retain) IBOutlet ImageLoading* imageLoading;

@property (nonatomic, retain) IBOutlet ProgressView* progressView;

@property (nonatomic, retain) IBOutlet UIBarItem* achPagePoints;
@property (nonatomic, retain) IBOutlet UIBarItem* achPageUnlocks;

@property (nonatomic, retain) IBOutlet UITabBar* mainTabBar;

@property (nonatomic, retain) IBOutlet UIButton* scratchButton;

@property (nonatomic, retain) IBOutlet UILabel* overlayTextStep1;
@property (nonatomic, retain) IBOutlet UILabel* overlayTextStep2;
@property (nonatomic, retain) IBOutlet UIImageView* overlayImageStep1;
@property (nonatomic, retain) IBOutlet UIImageView* overlayImageStep2;

-(void)initialize: (PdAudioController*) audio;

-(IBAction)scratchPressed:(id) sender;

-(IBAction)playPressed:(id) sender;
-(IBAction)stopPressed:(id) sender;
-(IBAction)repeatPressed:(id)sender;

-(IBAction)cameraPressed:(id) sender;
-(IBAction)loadPressed:(id)sender;
-(IBAction)imageLoadPressed:(id)sender;

-(IBAction)sliderTempoReleased:(id) sender;
-(IBAction)sliderDrumVolumeReleased:(id) sender;
-(IBAction)sliderMelodyVolumeReleased:(id) sender;
-(IBAction)sliderSongLengthReleased:(id) sender;
-(IBAction)sliderSongLengthChanged:(id)sender;

-(IBAction)toggleHelp:(id)sender;
-(void)enableHelp:(bool)help;

-(void)scrollUp;

-(IBAction)instrumentsPressed:(id)sender;
-(IBAction)drumsPressed:(id)sender;

-(IBAction)sharePressed:(id) sender;

-(IBAction)customisePressed:(id) sender;

-(void)receiveFloat:(float)received fromSource:(NSString *)source;

-(void)updateProgressView;

-(void)beginRecording;

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo;
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

-(void)startedPlaying;
-(void)stoppedPlaying;

-(void)activateImageChooser:(BOOL) camera;

-(void)setImage:(UIImage*) image;
-(void)updateSongValues;

-(void)changePrimaryInstrument;
-(void)changeDrums;

-(void)updateStoreAndAchievements;

-(void)startFlashHelpText;
-(void)onFlashHelpText;

-(void)saveImageToCollection:(UIImage*)image;

-(void)setPrimaryInstrument:(int)index;
-(void)setPercussiveInstrument:(int)index;

@end
