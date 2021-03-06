#import "ViewController.h"
#import "Util.h"
#import "InstrumentSelector.h"
#import "ImageLoading.h"
#import "ProgressScreen.h"
#import "SplashScreen.h"
#import <SCUI.h>
#import "SongGeneration.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@implementation InstrumentPack

-(InstrumentPack*)init:(NSString *)key :(NSString *)displayName :(NSString *)waveFile
{
    Key = key;
    DisplayName = displayName;
    WaveFile = waveFile;
    
    return self;
}

@end

@implementation DrumPack

-(DrumPack*)init:(NSString *)key :(NSString *)displayName :(NSMutableArray *)waveFiles
{
    Key = key;
    DisplayName = displayName;
    WaveFiles = waveFiles;
    
    return self;
}

@end


@implementation ViewController

@synthesize imageView;

@synthesize buttonPlay;
@synthesize buttonRepeat;
@synthesize buttonHelp;
@synthesize buttonPrimaryInstrument;
@synthesize buttonDrums;

@synthesize sliderTempo;
@synthesize sliderDrumVolume;
@synthesize sliderMelodyVolume;
@synthesize sliderSongLength;

@synthesize achievementsScrollView;
@synthesize achievementsToolbar;

@synthesize mainScrollView;
@synthesize mainView;

@synthesize instrumentSelector;
@synthesize splashScreen;
@synthesize imageLoading;

@synthesize progressView;

@synthesize achPagePoints;
@synthesize achPageUnlocks;

@synthesize storeScrollView;
@synthesize storePagePoints;
@synthesize storePageUnlocks;

@synthesize mainTabBar;

@synthesize scratchButton;

@synthesize overlayTextStep1;
@synthesize overlayTextStep2;
@synthesize overlayImageStep1;
@synthesize overlayImageStep2;

+(float)BPMtoInterval:(float)bpm
{
    return 60000.0f / bpm;
}

-(void)sliderTempoReleased:(id)sender
{
    float bpm = [sliderTempo value] * 500.0f + 90.0f;
    float interval = [ViewController BPMtoInterval: bpm];
    [PdBase sendFloat: interval toReceiver:[NSString stringWithFormat:@"%d-tempo", _patch.dollarZero]];
    
    [_achievements tempoChanged];
}

-(void)sliderDrumVolumeReleased:(id)sender
{
    // Change the master volume of instruments 0 through to 4
    
    NSArray* receivers = [NSArray arrayWithObjects:@"%d-instrument0", @"%d-instrument1", @"%d-instrument2",
                          @"%d-instrument3", @"%d-instrument4", nil];
    
    NSString* message = @"volume";
    NSArray* args = [NSArray arrayWithObject:[NSNumber numberWithFloat:[sliderDrumVolume value]]];
    
    
    for (int i = 0; i < [receivers count]; ++i)
    {
        NSString* receiver = [NSString stringWithFormat:[receivers objectAtIndex:i], _patch.dollarZero];
        
        [PdBase sendMessage: message withArguments:args toReceiver:receiver];
    }
    
    [_achievements drumVolChanged];
}

-(void)sliderMelodyVolumeReleased:(id)sender
{
    // Change the master volume of instrument 5
    NSString* receiver = [NSString stringWithFormat:@"%d-instrument5", _patch.dollarZero];
    NSString* message = @"volume";
    NSArray* args = [NSArray arrayWithObject:[NSNumber numberWithFloat:[sliderMelodyVolume value]]];    
    
    [PdBase sendMessage: message withArguments: args toReceiver: receiver];
    
    [_achievements melodyVolumeChanged];
}

-(void)sliderSongLengthReleased:(id)sender
{    
    _numNotes = (int)(sliderSongLength.value + 0.5f) * 4; // 4 notes per notch on slider
    
    [self updateSongValues];
    
    [_achievements lengthChanged];
}

-(void)sliderSongLengthChanged:(id)sender
{
    sliderSongLength.value = (int)(sliderSongLength.value + 0.5f);
}

-(void)playPressed:(id)sender
{
    _playing = !_playing;
    
    [_achievements playOneSong];
    
    if (_playing)
    {
        [PdBase sendBangToReceiver:@"startPlayback"];
        [self startedPlaying];
    }
    else
    {
        [PdBase sendBangToReceiver:@"pausePlayback"];
        [self stoppedPlaying];
    }
}

-(void)repeatPressed:(id)sender
{
    _repeatOn = !_repeatOn;
    
    [PdBase sendFloat: _repeatOn ? 1.0f : 0.0f toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    if (_repeatOn)
    {
        [buttonRepeat setImage:[UIImage imageNamed:@"repeatonbutton.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [buttonRepeat setImage:[UIImage imageNamed:@"repeatoffbutton.png"] forState:UIControlStateNormal];
        
    }
}

-(void)stopPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"stopPlayback"];
}

-(void)cameraPressed:(id)sender
{ 
    //[imageLoading hide];
    [self dismissViewControllerAnimated:YES completion:^{
                                                            [self activateImageChooser: YES];
                                                        }];
}

-(void)loadPressed:(id)sender
{
    //[imageLoading hide];
    //[self activateImageChooser: NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self activateImageChooser: NO];
    }];
}

-(void)instrumentsPressed:(id)sender
{
    for(int i = 0; i < 2; i++)
    {
        // Load unlock state
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bool isUnlocked = [prefs boolForKey:
                           [NSString stringWithFormat: @"_unlock%d", i]];
        
        if (isUnlocked)
        {
            
        }
    }
    
    [instrumentSelector setPickerNames: [self getUnlockedInstrumentNames]];
    [instrumentSelector setCompletionHandler: self : @selector(changePrimaryInstrument)];
    [instrumentSelector show];
}

-(void)drumsPressed:(id)sender
{
    [instrumentSelector setPickerNames: [self getUnlockedDrumNames]];
    [instrumentSelector setCompletionHandler: self :@selector(changeDrums)];
    [instrumentSelector show];
}

-(void)imageLoadPressed:(id)sender
{
    [imageLoading show];
}

-(void)customisePressed:(id)sender
{
    // Scroll down to "customise" section and display scrollbar
    
    [UIView animateWithDuration:.35 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(0, mainScrollView.frame.size.height);
        [mainScrollView flashScrollIndicators];
    }];
}

-(void)scrollUp
{
    if (self.mainScrollView.contentOffset.y != 0)
    {
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    }
}

-(void)scratchPressed:(id)sender
{
    _progressValue -= 4;
    
    if (_progressValue < 0)
        _progressValue = 0;
    
    [PdBase sendFloat: _progressValue toReceiver: [NSString stringWithFormat:@"%d-scratch", _patch.dollarZero]];
    
    [self startedPlaying];
    
    scratchButton.alpha = 1.0f;
    
    [UIView animateWithDuration:.2f animations:^{
        scratchButton.alpha = 0.65f;
    }];
}

-(void)sharePressed:(id)sender
{
    //[self presentModalViewController: shareView animated: YES];
    
    UIAlertView* alert = [[UIAlertView alloc] init];
    [alert setTitle: @"Save and upload?"];
    [alert setMessage: @"Save and share with soundcloud? This operation may take some time"];
    
    [alert addButtonWithTitle: @"Cancel"];
    [alert addButtonWithTitle: @"Ok"];
    [alert setDelegate: self];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Yes pressed
    if (buttonIndex == 1)
    {
        [self beginRecording];
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)beginRecording
{    
    [self presentModalViewController:progressView animated: YES];
    
    // Make sure looping is disabled while recording
    if (_repeatOn)
        [PdBase sendFloat: 0.0f toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    // Start recording
    [PdBase sendBangToReceiver: @"recordSong"];
}

-(void)toggleHelp:(id)sender
{
    [self enableHelp:!_helpVisible];    
}

-(void)enableHelp:(bool)help
{
    _helpVisible = help;
    
    if (_helpVisible)
    {
        [mainView addSubview: splashScreen];
        [buttonHelp setImage: _helponicon forState: UIControlStateNormal];
    }
    else
    {
        [splashScreen removeFromSuperview];
        [buttonHelp setImage: _helpofficon forState:UIControlStateNormal];
    }
}

-(void)recordDone
{    
    // Re-enable looping
    if (_repeatOn)
        [PdBase sendFloat: 1.0f toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *savadataPath = [path stringByAppendingPathComponent:@"savedata.wav"];
    
    NSURL *trackURL = [NSURL fileURLWithPath:savadataPath]; // ... an URL to the audio file
    
    SCShareViewController* shareViewController = 
        [SCShareViewController shareViewControllerWithFileURL:trackURL
        completionHandler:^
         (NSDictionary *trackInfo, NSError *error)
         {
             if (SC_CANCELED(error))
             {
                 NSLog(@"Canceled!");
             }
             else if (error)
             {
                 NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
             }
             else
             {
                 [_achievements uploadOneSong];
                 // If you want to do something with the uploaded
                 // track this is the right place for that.
                 NSLog(@"Uploaded track: %@", trackInfo);
             }
        }];
    
    [shareViewController setCoverImage: [imageView image]];
    
    // If your app is a registered foursquare app, you can set the client id and secret.
    // The user will then see a place picker where a location can be selected.
    // If you don't set them, the user sees a plain plain text filed for the place.
    /*
     [shareViewController setFoursquareClientID:@"<foursquare client id>"
     clientSecret:@"<foursquare client secret>"];
     */
    
    // We can preset the title ...
    [shareViewController setTitle:@"Created with the Hear My Picture app!"];
    
    // ... and other options like the private flag.
    [shareViewController setPrivate:NO];
    
    // Hide the saving progressbar view
    [self dismissViewControllerAnimated: YES completion:^{
        // Now present the share view controller.
        [self presentModalViewController:shareViewController animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)initialize: (PdAudioController*) audio
{
    _instruments = [[NSMutableArray alloc] init];
    
    
    [_instruments addObject: [[InstrumentPack alloc] init: @"INSTSYNTH": @"Electronic": @"synth.wav"]];
    [_instruments addObject: [[InstrumentPack alloc] init: @"INST8-BIT": @"8-Bit": @"8bit/lead.wav"]];
    [_instruments addObject: [[InstrumentPack alloc] init: @"INSTEGTAR": @"Electric Guitar": @"e-guitar.wav"]];
    [_instruments addObject: [[InstrumentPack alloc] init: @"INSTSTEEL": @"Steel Drum": @"steel-drum.wav"]];
    [_instruments addObject: [[InstrumentPack alloc] init: @"INSTTRUMP": @"Trumpet": @"trumpet.wav"]];
    [_instruments addObject: [[InstrumentPack alloc] init: @"INSTSITAR": @"Sitar": @"sitar-short.wav"]];
    [_instruments addObject: [[InstrumentPack alloc] init: @"INSTFLUTE": @"Flute": @"flute.wav"]];
    [_instruments addObject: [[InstrumentPack alloc] init: @"INSTHARP": @"Harp": @"harp.wav"]];
    [_instruments addObject: [[InstrumentPack alloc] init: @"INSTSAXO": @"Saxophone": @"saxophone.wav"]];
    
    _defaultInstruments = [[NSMutableArray alloc] initWithObjects: @"INSTSYNTH", @"INSTTRUMP", nil];
    
    _drums = [[NSMutableArray alloc] init];
    
    [_drums addObject: [[DrumPack alloc] init: @"DRUMTRIBE": @"Tribal":
                        [NSArray arrayWithObjects: @"tbass.wav", @"thihat.wav", @"tride.wav", @"tsnare.wav", @"tsplash.wav", nil]]];
    
    [_drums addObject: [[DrumPack alloc] init: @"DRUMSTAND": @"Standard":
                        [NSArray arrayWithObjects: @"bass.wav", @"hihat.wav", @"ride.wav", @"snare.wav", @"splash.wav", nil]]];
    
    [_drums addObject: [[DrumPack alloc] init: @"DRUM8-BIT": @"8Bit":
                        [NSArray arrayWithObjects: @"8bit/bass.wav", @"8bit/hit.wav", @"8bit/ride.wav", @"8bit/snare.wav", @"8bit/splash.wav", nil]]];
    
    [_drums addObject: [[DrumPack alloc] init: @"DRUMDANC": @"Dance":
                        [NSArray arrayWithObjects: @"dance/dbass.wav", @"dance/dhihat.wav", @"dance/dride.wav", @"dance/dsnare.wav", @"dance/dcrash.wav", nil]]];
    
    _defaultDrums = [[NSMutableArray alloc] initWithObjects:@"DRUMSTAND", nil];
    
    
    _lastTypeLoaded = 0;
    
    _seekbarView = [[UIView alloc] init];
    [_seekbarView setBackgroundColor: [UIColor whiteColor]];
    _seekbarView.frame = CGRectMake(0, 0, 0, 0);

    [imageView addSubview: _seekbarView];
    
    [mainScrollView addSubview: mainView];
    mainScrollView.contentSize = mainView.frame.size;

    // Initialise soundcloud API
    [SCSoundCloud setClientID: @"c670c061ac40359ac3ca5f2213836714"
                       secret: @"fe998800f4183f2109ffa0b84bbd8c3b"
                  redirectURL: [NSURL URLWithString:@"phototunes://oauth"]];
    
    _audio = audio;
    
    // Initialise song length
    _numNotes = 12;
    
    // 5 drums + 1 instrument
    _numIntruments = 6;
    
    _repeatOn = false;
    _playing = false;
    _helpVisible = true;
    
    _helponicon = [UIImage imageNamed: @"helponbutton.png"];
    _helpofficon = [UIImage imageNamed: @"helpoffbutton.png"];
    
    [mainView addSubview: splashScreen];
    
    // Init camera picker
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;

    // Initialise PD
    [PdBase setDelegate:self];
    _patch = [PdFile openFileNamed:@"soundsystem.pd" path:[[NSBundle mainBundle] bundlePath]];
    
    // Initialise number of instruments
    [PdBase sendFloat:_numIntruments toReceiver:[NSString stringWithFormat:@"%d-numInstruments", _patch.dollarZero]];
    
    // disable looping by default
    [PdBase sendFloat:0 toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    // listen for changes in progress bar & stop event
    [PdBase subscribe:[NSString stringWithFormat:@"%d-notifyProgress", _patch.dollarZero]];
    [PdBase subscribe:@"stopPlayback"];
    [PdBase subscribe:@"recordDone"];
    
    // Setup path in appdata folder for streaming the audio
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *samplePath = [path stringByAppendingPathComponent:@"savedata.wav"];
    [PdBase sendMessage:samplePath withArguments:NULL toReceiver:[NSString stringWithFormat:@"%d-saveFile", _patch.dollarZero]];
    
    // Initialise default image
    UIImage* image = [UIImage imageNamed:@"phototunes.png"];
    [self setImage: image];
    
    [instrumentSelector setParent: self]; 
    [imageLoading setParent: self];
    
    // Hack: prevents "updateStoreAndAchievements" accessing either
    // class until both are loaded
    _store = nil;
    _achievements = nil;
    
    _store = [[StoreTracker alloc] init: self];
    _achievements = [[AchievementsTracker alloc] init: self];
    [self updateStoreAndAchievements];
    
    // Take initial values from UI
    [self sliderTempoReleased:self];
    [self sliderTempoReleased:self];
    [self sliderDrumVolumeReleased:self];
    [self sliderMelodyVolumeReleased:self];
    [self sliderSongLengthReleased:self];
    [self sliderSongLengthChanged:self];
    
    // Override pd defaults
    [self setPercussiveInstrument:0];
    [self setPrimaryInstrument:0];
    
    [_audio setActive:YES];
    
    [self startFlashHelpText];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Allow only upright portrait orientation
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)receiveFloat:(float)received fromSource:(NSString *)source
{
    NSString* notifyProgress = [NSString stringWithFormat:@"%d-notifyProgress", _patch.dollarZero];
    
    if ([notifyProgress isEqualToString:source])
    {        
        _progressValue = received;
        
        [self performSelectorOnMainThread:@selector(updateProgressView) withObject:nil waitUntilDone:NO];
    }
}

- (void)receiveBangFromSource:(NSString *)source
{
    NSString* stopPlayback = @"stopPlayback";
    NSString* recordDone = @"recordDone";
    
    if ([stopPlayback isEqualToString:source])
    {
        [self performSelectorOnMainThread:@selector(stoppedPlaying) withObject:nil waitUntilDone:NO];
    }
    else if ([recordDone isEqualToString:source])
    {
        [self performSelectorOnMainThread:@selector(recordDone) withObject:nil waitUntilDone:NO];         
    }
}

-(void)updateProgressView
{
    float temp = _progressValue / (_numNotes - 1);
    
    float barWidth = _onScreenImageRect.size.width / _numNotes;
    
    CGRect rect = CGRectMake(_onScreenImageRect.origin.x + (int)(_progressValue * barWidth), 
                             _onScreenImageRect.origin.y, 
                             (int)barWidth, 
                             _onScreenImageRect.size.height);
    
    _seekbarView.frame = rect;
    
    [_seekbarView.layer removeAllAnimations];
    [_seekbarView setAlpha:0.8f];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        [_seekbarView setAlpha:0.0f];
    }
    completion:^(BOOL finished) {
        
    }];
    
    // Update saving screen progress bar
    [progressView setProgress:temp];
}

-(void)activateImageChooser:(BOOL) camera
{
    // Stop playback
    [self stopPressed:self];
    
    // Disable audio
    [_audio setActive:NO];
    
    if(camera)
    {
#if !TARGET_IPHONE_SIMULATOR	
        _lastTypeLoaded = 2;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif        
    }
    else
    {
        _lastTypeLoaded = 1;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [self saveImageToCollection:image];
    }
 
    [self setImage: image];
    [self scrollUp];
    
    [_achievements imageChanged];
    
    if (_lastTypeLoaded == 1)
    {
        [_achievements loadOneImage];
        _lastTypeLoaded = 0;
    }
    else if (_lastTypeLoaded == 2)
    {
        [_achievements takeOnePhoto];
        _lastTypeLoaded = 0;
    }
    
    [picker dismissModalViewControllerAnimated:YES];
    
    // Switch to home tab
    self.selectedIndex = 0;

    // Renable audio
    [_audio setActive:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
    [_audio setActive:YES];
}

-(void)setImage:(UIImage *)image
{
    // Display image
    [imageView setImage: image];
    
    // Calculate image properties
    _imagePropertes = [[ImageProperties alloc] init:image];
    
    // Update the song
    [self updateSongValues];
    
    // Calculate visible rectangle
    _onScreenImageRect = [Util frameForImage:image inImageViewAspectFit:imageView];
    
    // Stop playback
    [self stopPressed: self];
    
    // Change help hint to step 2
    _flashingHelpText = overlayTextStep2;
    _flashingHelpImage = overlayImageStep2;
}

-(void)updateSongValues
{
    // Stop playback first
    [self stopPressed:self];
    float* values = malloc(_numNotes * sizeof(float) * _numIntruments);
    
    [SongGeneration GenerateSong:_numNotes :_imagePropertes : values];

    
    [PdBase sendFloat:_numNotes toReceiver:[NSString stringWithFormat:@"%d-length", _patch.dollarZero]];
    [PdBase copyArray:values toArrayNamed:@"pattern" withOffset:0 count:_numNotes * _numIntruments];
    
    free(values);
}

-(void)startedPlaying
{
    //[buttonPlay setTitle:@"Pause" forState:UIControlStateNormal];
    [buttonPlay setImage:[UIImage imageNamed:@"pausebutton.png"] forState:UIControlStateNormal];
    
    _playing = true;
}

-(void)stoppedPlaying
{
    // Reset the progress bar only, to prevent saving screen
    // resetting it's saving progress
    _progressValue = 0;
    
    [buttonPlay setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
    _playing = false;
}

-(void)changePrimaryInstrument
{
    [self setPrimaryInstrument:[instrumentSelector getSelectionIndex]];
    
    [_achievements instrumentChanged];
}

-(void)setPrimaryInstrument:(int)index
{
    NSMutableArray* instruments = [self getUnlockedInstruments];
    InstrumentPack* instrument = (InstrumentPack*)[instruments objectAtIndex:index];
    
    
    NSString* instrumentName = instrument->DisplayName;
    [buttonPrimaryInstrument setTitle:instrumentName forState:UIControlStateNormal];
    
    NSString* soundFile = instrument->WaveFile;
    NSString* message = @"sample";
    NSArray* args = [NSArray arrayWithObject: soundFile];
    
    [PdBase sendMessage:message withArguments:args toReceiver:[NSString stringWithFormat:@"%d-instrument5", _patch.dollarZero]];
}

-(void)changeDrums
{
    [self setPercussiveInstrument:[instrumentSelector getSelectionIndex]];

    [_achievements drumsChanged];
}

-(void)setPercussiveInstrument:(int)index
{
    NSMutableArray* drums = [self getUnlockedDrums];
    
    DrumPack* drumPack = (DrumPack*) [drums objectAtIndex: index];
    
    [buttonDrums setTitle: drumPack->DisplayName forState:UIControlStateNormal];
    
    NSString* message = @"sample";
    
    for (int i = 0; i < 5; ++i)
    {
        NSString* soundFile = (NSString*)[drumPack->WaveFiles objectAtIndex:i];
        NSArray* args = [NSArray arrayWithObject: soundFile];
        
        NSString* reciever = [NSString stringWithFormat:@"%d-instrument%d", _patch.dollarZero, i];
        
        [PdBase sendMessage: message withArguments:args toReceiver: reciever];
    }
}

- (void)receivePrint:(NSString *)message
{
    NSLog(@"PD: %@", message);
}

-(void)updateStoreAndAchievements
{
    // Ignore updates when both the store and achivements systems are not loaded
    if (_store == nil)
        return;
    
    if (_achievements == nil)
        return;
    
    int points = [_achievements getUnlockedPoints];
    int costs = [_store getCostOfUnlockedItems];

    int available = points - costs;
    
    // Update available points labels and for store logic
    NSString* pointsLabel = [NSString stringWithFormat: @"%d Points", available];
    
    storePagePoints.title = pointsLabel;
    achPagePoints.title = pointsLabel;
    
    [_store setPoints: available];
    
    NSString* achUnlockedLabel = [NSString stringWithFormat: @"%d/%d", 
                                  [_achievements getUnlockedAchievements],
                                  [_achievements getTotalAchievements]];
    
    achPageUnlocks.title = achUnlockedLabel;
    
    NSString* storeUnlockedLabel = [NSString stringWithFormat: @"%d/%d",
                                    [_store getItemsUnlocked],
                                    [_store getTotalItems]];
    
    storePageUnlocks.title = storeUnlockedLabel;
}

-(void)startFlashHelpText
{
    _helpTextTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self 
                                                    selector:@selector(onFlashHelpText) userInfo:NULL repeats:YES];
    
    _flashingHelpText = overlayTextStep1;
    _flashingHelpImage = overlayImageStep1;
}

-(void)onFlashHelpText
{
    // Fade text out then in
    [UIView animateWithDuration:0.4f animations:
           ^{
               _flashingHelpText.alpha = 0.0f;
               _flashingHelpImage.alpha = 0.0f;
            }
    completion:
     ^(BOOL finished)
            {
                [UIView animateWithDuration:0.4f animations:
                   ^{
                       _flashingHelpText.alpha = 1.0f;
                       _flashingHelpImage.alpha = 1.0f;
                    }
                 ];
                
            }
     ];
}

-(void)saveImageToCollection:(UIImage *)image
{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
       if (error)
       {
           // TODO: do something
       }
    }
    ];
}

-(bool)isInstrumentUnlockedByDefault: (NSString*) instrument
{
    for(int i = 0; i < [_defaultInstruments count]; ++i)
    {
        if ([(NSString*)[_defaultInstruments objectAtIndex: i] isEqualToString: instrument])
        {
            return true;
        }
    }
    
    return false;
}

-(bool)isDrumUnlockedByDefault: (NSString*) instrument
{
    for(int i = 0; i < [_defaultDrums count]; ++i)
    {
        if ([(NSString*)[_defaultDrums objectAtIndex: i] isEqualToString: instrument])
        {
            return true;
        }
    }
    
    return false;
}

-(NSMutableArray*)getUnlockedInstruments
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < [_instruments count]; ++i)
    {
        InstrumentPack* instrument = [_instruments objectAtIndex: i];
        
        bool unlockedByDefault = [self isInstrumentUnlockedByDefault: instrument->Key];
        bool unlockedWithPoints = [prefs boolForKey:[NSString stringWithFormat: @"%@", instrument->Key]];
        
        if ( unlockedByDefault || unlockedWithPoints )
        {
            [array addObject: instrument];
        }
    }
    
    return array;
}

-(NSMutableArray*)getUnlockedDrums
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < [_drums count]; ++i)
    {
        DrumPack* drumPack = (DrumPack*)[_drums objectAtIndex: i];
        
        bool unlockedByDefault = [self isDrumUnlockedByDefault: drumPack->Key];
        bool unlockedWithPoints = [prefs boolForKey: [NSString stringWithFormat: @"%@", drumPack->Key]];
        
        if ( unlockedByDefault || unlockedWithPoints )
        {
            [array addObject: drumPack];
        }
    }
    
    return array;
}

-(NSMutableArray*)getUnlockedInstrumentNames
{
    NSMutableArray* unlockedInstruments = [self getUnlockedInstruments];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [unlockedInstruments count]; i++)
    {
        InstrumentPack* instrument = (InstrumentPack*)[unlockedInstruments objectAtIndex:i];
        
        [array addObject: instrument->DisplayName];
    }
    
    return array;
}

-(NSMutableArray*)getUnlockedDrumNames
{
    NSMutableArray* unlockedDrums = [self getUnlockedDrums];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [unlockedDrums count]; i++)
    {
        DrumPack* drum = (DrumPack*)[unlockedDrums objectAtIndex:i];
        
        [array addObject: drum->DisplayName];
    }
    
    return array;
}


@end