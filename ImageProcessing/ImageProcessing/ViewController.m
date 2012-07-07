#import "ViewController.h"
#import "Util.h"
#import "InstrumentSelector.h"
#import "ImageLoading.h"
#import "ProgressScreen.h"
#import "SplashScreen.h"
#import <SCUI.h>
#import "SongGeneration.h"

NSString *instrumentNames[] = {@"Guitar", @"Bell", @"Electronic", @"8Bit"};
NSString *instrumentFiles[] = {@"a.wav", @"bell.aiff", @"synth.wav", @"8bit/lead.wav"};

NSString* drumPackNames[] = {@"Standard", @"Tribal", @"8Bit"};

NSString* drumPackFiles[] = {@"bass.wav", @"hihat.wav", @"ride.wav", @"snare.wav", @"splash.wav",
                        @"tbass.wav", @"thihat.wav", @"tride.wav", @"tsnare.wav", @"tsplash.wav",
                        @"8bit/bass.wav", @"8bit/snare.wav", @"8bit/ride.wav", @"8bit/snare.wav", @"8bit/splash.wav"};


@implementation ViewController

@synthesize imageView;
@synthesize progress;

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
@synthesize shareView;

@synthesize achPagePoints;
@synthesize achPageUnlocks;

@synthesize storeScrollView;
@synthesize storePagePoints;
@synthesize storePageUnlocks;

@synthesize mainTabBar;

-(void)sliderTempoReleased:(id)sender
{ 
    [PdBase sendFloat: 60000.0f / ([sliderTempo value] * 400.0f + 60.0f) toReceiver:[NSString stringWithFormat:@"%d-tempo", _patch.dollarZero]];
    
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
    [progress setProgress: 0];
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
    [instrumentSelector setPickerNames:[NSArray arrayWithObjects: instrumentNames count: sizeof(instrumentNames)/sizeof(NSString*)]];
    [instrumentSelector setCompletionHandler: self : @selector(changePrimaryInstrument)];
    [instrumentSelector show];
}

-(void)drumsPressed:(id)sender
{
    [instrumentSelector setPickerNames:[NSArray arrayWithObjects: drumPackNames count: sizeof(drumPackNames)/sizeof(NSString*)]];
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
    
    // What the christ how does this even...    
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

-(void)sharePressed:(id)sender
{
    [self presentModalViewController: shareView animated: YES];
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
    _helpVisible = !_helpVisible;
    
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
    [shareViewController setTitle:@"Created with the phototunes app!"];
    
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
    //UIImage* image = [UIImage imageNamed:@"test2.jpg"];
    [self setImage: image];
    
    // Hack for iPhone 4, fix the rectangle for the initial image
    //progress.frame = CGRectMake(31, 225, 257, 10);
    
    [instrumentSelector setParent: self]; 
    [imageLoading setParent: self];
    
    // Hack: prevents "updateStoreAndAchievements" accessing either class until both
    // are loaded
    _store = nil;
    _achievements = nil;
    
    _store = [[StoreTracker alloc] init: self];
    _achievements = [[AchievementsTracker alloc] init: self];
    [self updateStoreAndAchievements];
    
    [_audio setActive:YES];
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
    
    [progressView setProgress:temp];
    
    [progress setProgress: temp];
}

-(void)activateImageChooser:(BOOL) camera
{
    [self stopPressed:self];
    [_audio setActive:NO];
    
    if(camera)
    {
#if !TARGET_IPHONE_SIMULATOR	
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif        
    }
    else
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
 
    [self setImage: image];
    [self scrollUp];
    
    [_achievements imageChanged];
    
    self.selectedIndex = 0;
    
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
    
    // Resize progress bar to fit underneath scaled image
    CGRect onScreenRect = [Util frameForImage:image inImageViewAspectFit:imageView];
    onScreenRect.origin.y = onScreenRect.origin.y + onScreenRect.size.height;
    onScreenRect.size.height = 10; //progress.frame.size.height;
    progress.frame = onScreenRect;
    
    // Stop playback
    [self stopPressed: self];
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
    progress.progress = 0;

    [buttonPlay setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
    _playing = false;
}

-(void)changePrimaryInstrument
{
    NSString* instrumentName = instrumentNames[[instrumentSelector getSelectionIndex]];
    [buttonPrimaryInstrument setTitle:instrumentName forState:UIControlStateNormal];
    
    NSString* soundFile = instrumentFiles[[instrumentSelector getSelectionIndex]];
    NSString* message = @"sample";
    NSArray* args = [NSArray arrayWithObject: soundFile];
    
    [PdBase sendMessage:message withArguments:args toReceiver:[NSString stringWithFormat:@"%d-instrument5", _patch.dollarZero]];
    
    [_achievements instrumentChanged];
}

-(void)changeDrums
{
    int selection = [instrumentSelector getSelectionIndex];
    
    NSString* packName = drumPackNames[selection];
    [buttonDrums setTitle:packName forState:UIControlStateNormal];
    
    NSString* message = @"sample";
    
    for (int i = 0; i < 5; ++i)
    {
        NSString* soundFile = drumPackFiles[selection*5 + i];
        NSArray* args = [NSArray arrayWithObject: soundFile];
                                            
        NSString* reciever = [NSString stringWithFormat:@"%d-instrument%d", _patch.dollarZero, i];
        
        [PdBase sendMessage: message withArguments:args toReceiver: reciever];
    }
}

- (void)receivePrint:(NSString *)message
{
    NSLog(@"%@", message);
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

@end
