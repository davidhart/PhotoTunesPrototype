#import "AchievementsView.h"
#import "StoreView.h"
#import "ViewController.h"


const float ACHIEVEMENT_LEFT_PADDING = 10;
const float ACHIEVEMENT_RIGHT_PADING = 10;
const float ACHIEVEMENT_TOP_PADDING = 10;
const float ACHIEVEMENT_HEIGHT = 90;

const float ACHIEVEMENT_TITLE_X_OFFSET = 76;
const float ACHIEVEMENT_TITLE_Y_OFFSET = 6;
const float ACHIEVEMENT_TITLE_WIDTH = 150;
const float ACHIEVEMENT_TITLE_HEIGHT = 28;

const float ACHIEVEMENT_DESC_X_OFFSET = 78;
const float ACHIEVEMENT_DESC_Y_OFFSET = 35;
const float ACHIEVEMENT_DESC_WIDTH = 214;
const float ACHIEVEMENT_DESC_HEIGHT = 43;

const float ACHIEVEMENT_SCORE_X_OFFSET = 240;
const float ACHIEVEMENT_SCORE_Y_OFFSET = 6;
const float ACHIEVEMENT_SCORE_WIDTH = 50;
const float ACHIEVEMENT_SCORE_HEIGHT = 28;

const float ACHIEVEMENT_ICON_X_OFFSET = 16;
const float ACHIEVEMENT_ICON_Y_OFFSET = 18;
const float ACHIEVEMENT_ICON_WIDTH = 53;
const float ACHIEVEMENT_ICON_HEIGHT = 53;

const float STATUS_BAR_Y_OFFSET = 20;

UIImage* g_AchievementOverlayImage;
UIImage* g_AchievementLockedBaseImage;
UIImage* g_AchievementUnlockedBaseImage;

// UI Object for a single achievement
@implementation AchievementView

-(id)init:(CGRect)frame
{
    self = [super init];
    
    if (self)
    {
        [AchievementView initImages];
        
        _unlocked = false;
        
        // Base image / control
        _base = [[UIImageView alloc] initWithFrame:frame];
        _base.image = [self GetBaseImage];
        
        // Icon graphic
        CGRect iconRect = CGRectMake(ACHIEVEMENT_ICON_X_OFFSET,
                                     ACHIEVEMENT_ICON_Y_OFFSET,
                                     ACHIEVEMENT_ICON_WIDTH,
                                     ACHIEVEMENT_ICON_HEIGHT);
        
        _icon = [[UIImageView alloc] initWithFrame:iconRect];
        //_icon.image = ;
        _icon.backgroundColor = [UIColor purpleColor];
        [_base addSubview: _icon];
        
        // Overlay graphic
        CGRect overlayRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        _iconOverlay = [[UIImageView alloc] initWithFrame: overlayRect];
        _iconOverlay.image = g_AchievementOverlayImage;
        [_base addSubview: _iconOverlay];
        
        // Title label
        CGRect titleRect = CGRectMake(ACHIEVEMENT_TITLE_X_OFFSET, 
                                      ACHIEVEMENT_TITLE_Y_OFFSET, 
                                      ACHIEVEMENT_TITLE_WIDTH,
                                      ACHIEVEMENT_TITLE_HEIGHT);
        
        _titleLabel = [[UILabel alloc] initWithFrame: titleRect];
        _titleLabel.text = @"Default Title";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName: _titleLabel.font.familyName size: 25];
        
        [_base addSubview: _titleLabel];
        
        // Description label
        CGRect descRect = CGRectMake(ACHIEVEMENT_DESC_X_OFFSET, 
                                     ACHIEVEMENT_DESC_Y_OFFSET, 
                                     ACHIEVEMENT_DESC_WIDTH, 
                                     ACHIEVEMENT_DESC_HEIGHT);
        
        _descriptionLabel = [[UILabel alloc] initWithFrame: descRect];
        _descriptionLabel.text = @"Default description";
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        _descriptionLabel.numberOfLines = 2;
        
        [_base addSubview: _descriptionLabel];
        
        // Score label
        
        CGRect scoreRect = CGRectMake(ACHIEVEMENT_SCORE_X_OFFSET, 
                                      ACHIEVEMENT_SCORE_Y_OFFSET, 
                                      ACHIEVEMENT_SCORE_WIDTH, 
                                      ACHIEVEMENT_SCORE_HEIGHT);
        
        _scoreLabel = [[UILabel alloc] initWithFrame: scoreRect];
        _scoreLabel.text = @"50";
        _scoreLabel.textColor = [UIColor whiteColor];
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.textAlignment = UITextAlignmentRight;
        _scoreLabel.font = [UIFont fontWithName: _scoreLabel.font.familyName size: 25];
        
        [_base addSubview: _scoreLabel];
    }
    
    return self;
}

-(UIControl*)GetUIControl
{
    return (UIControl*)_base;
}

-(UIImage*)GetBaseImage
{
    if (_unlocked)
        return g_AchievementUnlockedBaseImage;
    else
        return g_AchievementLockedBaseImage;
}

+(void)initImages
{
    if (g_AchievementOverlayImage == nil)
        g_AchievementOverlayImage = [UIImage imageNamed:@"ach-overlay.png"];
    
    if (g_AchievementLockedBaseImage == nil)
        g_AchievementLockedBaseImage = [UIImage imageNamed:@"ach-locked-base.png"];
    
    if (g_AchievementUnlockedBaseImage == nil)
        g_AchievementUnlockedBaseImage = [UIImage imageNamed:@"ach-unlocked-base.png"];
}

-(void)setUnlocked:(bool)locked
{
    _unlocked = locked;
    
    _base.image = [self GetBaseImage];
    
    NSLog(@"unlocked %@", _titleLabel.text);
}

-(void)setTitle:(NSString*)title
{
    _titleLabel.text = title;
}

-(void)setDescription:(NSString*)description;
{
    _descriptionLabel.text = description;
}

-(void)setPoints:(int)points
{
    _scoreLabel.text = [NSString stringWithFormat: @"%d", points];
}

-(void)setIcon:(NSString*)icon
{
    _icon.image = [UIImage imageNamed: icon];
}

-(UIImage*)GetIcon
{
    return _icon.image;
}
-(UIImage*)GetIconOverlay
{
    return _iconOverlay.image;
}

-(NSString*)GetTitle
{
    return _titleLabel.text;
}
-(NSString*)GetDesc
{
    return _descriptionLabel.text; 
}

@end

// UI Object to control all displayed achievements
@implementation AchievementsView

-(id)init: (ViewController*)view
{
    self = [super init];
    
    if (self)
    {
        _view = view;
        _achievementsView = view.achievementsScrollView;
        _achievementsToolbar = view.achievementsToolbar;
        
        _achievementViews = [[NSMutableArray alloc] init];
        
        _achieveUnlocked = [[UIImageView alloc] initWithFrame:CGRectMake(0, -78 - STATUS_BAR_Y_OFFSET, _achievementsView.frame.size.width, 78)];
        
        // Create toast popup controls...
        _achieveUnlocked.image = [UIImage imageNamed:@"achievement-toast-base.png"];
        
        // Icon graphic
        CGRect iconRect = CGRectMake(12,
                                     12,
                                     ACHIEVEMENT_ICON_WIDTH + 2,
                                     ACHIEVEMENT_ICON_HEIGHT + 3);
        
        _icon = [[UIImageView alloc] initWithFrame:iconRect];
        //_icon.image = ;
        _icon.backgroundColor = [UIColor purpleColor];
        [_achieveUnlocked addSubview: _icon];
        
        // Overlay graphic
        CGRect overlayRect = CGRectMake(0, 0, _achievementsView.frame.size.width, 78);
        
        _iconOverlay = [[UIImageView alloc] initWithFrame: overlayRect];
        _iconOverlay.image = [UIImage imageNamed:@"achievement-toast-overlay.png"];
        [_achieveUnlocked addSubview: _iconOverlay];
        
        // Title label
        CGRect titleRect = CGRectMake(ACHIEVEMENT_TITLE_X_OFFSET, 
                                      ACHIEVEMENT_TITLE_Y_OFFSET, 
                                      ACHIEVEMENT_TITLE_WIDTH,
                                      ACHIEVEMENT_TITLE_HEIGHT);
        
        _titleLabel = [[UILabel alloc] initWithFrame: titleRect];
        _titleLabel.text = @"Default Title";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName: _titleLabel.font.familyName size: 20];
        
        [_achieveUnlocked addSubview: _titleLabel];
        
        // Description label
        CGRect descRect = CGRectMake(ACHIEVEMENT_DESC_X_OFFSET - 1, 
                                     ACHIEVEMENT_DESC_Y_OFFSET - 7, 
                                     ACHIEVEMENT_DESC_WIDTH, 
                                     ACHIEVEMENT_DESC_HEIGHT);
        
        _descriptionLabel = [[UILabel alloc] initWithFrame: descRect];
        _descriptionLabel.text = @"Default description";
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        _descriptionLabel.numberOfLines = 2;
        _descriptionLabel.font = [UIFont fontWithName: _descriptionLabel.font.familyName size: 14];

        [_achieveUnlocked addSubview: _descriptionLabel];
       
        // Add toast popup control to main view
        [view.view addSubview: _achieveUnlocked];
    }
    
    return self;
}

-(int)addAchievement:(NSString *)title :(NSString *)descr :(NSString *)icon :(int)points
{
    int index = [_achievementViews count];
    
    CGRect rect = [self calculateAchievementRect:index];
    
    AchievementView* achievement = [[AchievementView alloc]init: rect];
    
    [achievement setTitle: title];
    [achievement setDescription: descr];
    [achievement setIcon: icon];
    [achievement setPoints: points];
    
    [_achievementsView addSubview: [achievement GetUIControl]];
    [_achievementViews addObject: achievement];
    
    [self resizeContent];
    
    return index;
}

-(void)resizeContent
{
    int index = [_achievementViews count] - 1;
    
    CGRect rect = [self calculateAchievementRect:index];
    
    CGSize contentsize = CGSizeMake(_achievementsView.contentSize.width,
                                    rect.origin.y + rect.size.height + ACHIEVEMENT_TOP_PADDING);
    
    _achievementsView.contentSize = contentsize;
}

-(CGRect)calculateAchievementRect: (int)index
{
    return CGRectMake(ACHIEVEMENT_LEFT_PADDING,
           (index + 1) * ACHIEVEMENT_TOP_PADDING + index * ACHIEVEMENT_HEIGHT, 
           _achievementsView.frame.size.width - ACHIEVEMENT_LEFT_PADDING - ACHIEVEMENT_RIGHT_PADING,
           ACHIEVEMENT_HEIGHT);
}

-(void)unlockAchievement: (int)index
{
    AchievementView* ach = [_achievementViews objectAtIndex: index];
    
    [ach setUnlocked: true];
    
    _titleLabel.text = [ach GetTitle];
    _descriptionLabel.text = [ach GetDesc];
    _icon.image = [ach GetIcon];
    
    //ANIMATE HERE
    [UIView animateWithDuration:.5 animations:^{
        _achieveUnlocked.frame = CGRectMake(0, STATUS_BAR_Y_OFFSET, _achievementsView.frame.size.width, 78);
    } completion:
     ^(BOOL finished)
    { 
        [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationCurveLinear animations:
         ^{ _achieveUnlocked.frame =
             CGRectMake(0, -78 - STATUS_BAR_Y_OFFSET, _achievementsView.frame.size.width, 78);
         } 
        completion: nil];
    } 
     ];
    
}

-(void)silentUnlockAchievement: (int)index
{
    AchievementView* ach = [_achievementViews objectAtIndex: index];
    
    [ach setUnlocked: true];
}

-(void)setScore:(int)score
{
    NSString* string = [NSString stringWithFormat: @"%d Points", score];
    _view.achPagePoints.title = string;
}

-(void)setAchUnlocked:(int)achUnlocked
{
    NSString* string = [NSString stringWithFormat: @"%d/%d", achUnlocked, [_achievementViews count]];
    _view.achPageUnlocks.title = string;
}

@end

// Achievements Database
@implementation AchievementsTracker

-(id)init:(ViewController*)viewController
{
    self = [super init];
    
    if (self)
    {
        _achievementsView = [[AchievementsView alloc] init: viewController];
        _trackers = [[NSMutableArray alloc] init];
        _view = viewController;
        
        // Add achievements
        [self addAchievement: [PerfectionistAchievementTracker alloc]:
                       @"Perfectionist":
                       @"Modify every setting on a single image":
                       @"ach1.png":
                       10];
        
        PhotocountTracker* tracker = [PhotocountTracker alloc];
        [tracker setUnlockCount: 10];
        [self addAchievement: tracker :
                        @"Explorer":
                        @"Load 10 images":
                        @"ach1.png": 
                        10];
        
        tracker = [PhotocountTracker alloc];
        [tracker setUnlockCount: 50];
        [self addAchievement: tracker :
                        @"Pioneer":
                        @"Load 50 images": 
                        @"ach1.png": 
                        20];
    
        tracker = [PhotocountTracker alloc];
        [tracker setUnlockCount: 100];
        [self addAchievement: tracker :
                        @"Generic":
                        @"Load 100 images":
                        @"ach1.png":
                        1];
        
        tracker = [PhotocountTracker alloc];
        [tracker setUnlockCount: 250];
        [self addAchievement: tracker :
                        @"Generic":
                        @"Load 250 images":
                        @"ach1.png":
                        1];
        
        tracker = [PhotocountTracker alloc];
        [tracker setUnlockCount: 1000];
        [self addAchievement: tracker :
                        @"Generic":
                        @"Load 1000 images":
                        @"ach1.png":
                        1];
        
        [self addAchievement: [LoadOneImageAchievementTracker alloc]:
                        @"Load One Image":
                        @"Load One Image":
                        @"ach1.png":
                        1];
        
        [self addAchievement: [TakeOnePhotoAchievementTracker alloc]:
                        @"Take One Photo":
                        @"Take One Photo":
                        @"ach1.png":
                        1];
        
        [self addAchievement: [UploadOneSongAchievementTracker alloc]:
                        @"Upload One Song":
                        @"Upload One Song":
                        @"ach1.png":
                        1];
        
        [self addAchievement: [PlayOneSongAchievementTracker alloc]:
                        @"Play One Song":
                        @"Play One Song":
                        @"ach1.png":
                        100];
    }
    
    return self;
}

-(int)getTotalAchievements
{
    return [_trackers count];
}

-(int)getUnlockedAchievements
{
    int unlocked = 0;
    for (int i = 0; i < [self getTotalAchievements]; ++i)
    {
        BaseTracker* tracker = [_trackers objectAtIndex: i];
        
        if ([tracker isUnlocked])
            unlocked++;
    }
    
    return unlocked;
}

-(int)getUnlockedPoints
{
    int points = 0;
    
    for (int i = 0; i < [self getTotalAchievements]; ++i)
    {
        BaseTracker* tracker = [_trackers objectAtIndex: i];
        
        if ([tracker isUnlocked])
          points += tracker->score;
    }
    
    return points;
}

-(void)addAchievement:(BaseTracker*)tracker :(NSString*)title :(NSString*)descr :(NSString*)image :(int)points
{    
    int index = [_achievementsView addAchievement:title: descr: image: points];
    
    [tracker setParent: self];
    [tracker setIndex: index];
    [tracker loadSavedAchievement];
    tracker->score = points;
    
    [_trackers addObject: tracker];
    
    [_view updateStoreAndAchievements];
}

-(void)unlockAchievement:(int)index
{
    [_achievementsView unlockAchievement: index];
    
    [_view updateStoreAndAchievements];
}

-(void)silentUnlockAchievement:(int)index
{
    [_achievementsView silentUnlockAchievement: index];
    
    [_view updateStoreAndAchievements];
}

-(void)tempoChanged
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t tempoChanged];
    }
}

-(void)drumVolChanged
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t drumVolChanged];
    }
}

-(void)melodyVolumeChanged
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t melodyVolumeChanged];
    }
}

-(void)lengthChanged
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t lengthChanged];
    }
}

-(void)instrumentChanged
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t instrumentChanged];
    }
}

-(void)drumsChanged
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t drumsChanged];
    }
}

-(void)imageChanged
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t imageChanged];
    }
}

-(void)loadOneImage
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t loadOneImage];
    }
}

-(void)takeOnePhoto
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t takeOnePhoto];
    }
}

-(void)uploadOneSong
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t uploadOneSong];
    }
}

-(void)playOneSong
{
    for (int i = 0; i < [_trackers count]; ++i)
    {
        BaseTracker* t = [_trackers objectAtIndex: i];
        [t playOneSong];
    }
}

@end

@implementation BaseTracker

-(void)unlock
{
    _unlocked = true;
    [_tracker unlockAchievement: _index];
}

-(void)silentUnlock
{
    _unlocked = true;
    [_tracker silentUnlockAchievement: _index];
}

-(bool)isUnlocked
{
    return _unlocked;
}

-(void)setParent: (AchievementsTracker*) tracker
{
    _tracker = tracker;
    _unlocked = false;
}

-(void)setIndex: (int) index
{
    _index = index;
}

-(void)tempoChanged { }
-(void)drumVolChanged { }
-(void)melodyVolumeChanged { }
-(void)lengthChanged { }
-(void)instrumentChanged { }
-(void)drumsChanged { }
-(void)imageChanged { }
-(void)loadSavedAchievement { }

-(void)loadOneImage { }
-(void)takeOnePhoto { }

-(void)uploadOneSong { }
-(void)playOneSong { }

@end

@implementation PerfectionistAchievementTracker

-(void)tempoChanged
{
    _tempoChanged = true;
    
    [self evaluateCondition];
}

-(void)drumVolChanged
{
    _drumVolumeChanged = true;
    
    [self evaluateCondition];
}

-(void)melodyVolumeChanged
{
    _melodyVolumeChanged = true;
    
    [self evaluateCondition];
}

-(void)lengthChanged
{
    _lengthChanged = true;
    
    [self evaluateCondition];
}

-(void)instrumentChanged
{
    _instrumentChanged = true;
    
    [self evaluateCondition];
}

-(void)drumsChanged
{
    _drumChanged = true;
    
    [self evaluateCondition];
}

-(void)imageChanged
{
    _tempoChanged = false;
    _drumVolumeChanged = false;
    _melodyVolumeChanged = false;
    _lengthChanged = false;
    _instrumentChanged = false;
    _drumChanged = false;
}

-(void)evaluateCondition
{
    if (![self isUnlocked])
    {
        if (_tempoChanged && 
            _drumVolumeChanged &&
            _melodyVolumeChanged &&
            _lengthChanged &&
            _instrumentChanged &&
            _drumChanged)
        {
            [self unlock];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setBool:true forKey:@"_perfectionistUnlockedBool"];
        }
    }
}

-(void)loadSavedAchievement
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool _isAchievementUnlocked = [prefs boolForKey:@"_perfectionistUnlockedBool"];
    
    if (_isAchievementUnlocked)
        [self silentUnlock];
    
    _tempoChanged = false;
    _drumVolumeChanged = false;
    _melodyVolumeChanged = false;
    _lengthChanged = false;
    _instrumentChanged = false;
}

@end

@implementation PhotocountTracker

-(void)setUnlockCount:(int)unlockCount
{
    _unlockCount = unlockCount;
}

-(void)imageChanged
{
    if (![self isUnlocked])
    {
        _count++;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:_count forKey:[NSString stringWithFormat: @"_PhotoCountTracker%d", _index]];
        
        if (_count >= _unlockCount)
        {
            [self unlock];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setBool:true forKey:[NSString stringWithFormat: @"_PhotoCountTrackerUnlockedBool%d", _index]];
        }
    }
}

-(void)loadSavedAchievement
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    bool _isAchievementUnlocked = [prefs boolForKey:
                                   [NSString stringWithFormat: @"_PhotoCountTrackerUnlockedBool%d", _index]];
    
    if (_isAchievementUnlocked)
        [self silentUnlock];
    
    else 
    {
        _count = [prefs integerForKey:[NSString stringWithFormat: @"_PhotoCountTracker%d", _index]];
    }
}

@end


@implementation LoadOneImageAchievementTracker

-(void)loadOneImage
{
    _oneLoad = true;
    
    [self evaluateCondition];
}

-(void)evaluateCondition
{
    if (![self isUnlocked])
    {
        if (_oneLoad)
        {
            [self unlock];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setBool:true forKey:@"_oneLoadUnlockedBool"];
        }
    }
}

-(void)loadSavedAchievement
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool _isAchievementUnlocked = [prefs boolForKey:@"_oneLoadUnlockedBool"];
    
    if (_isAchievementUnlocked)
        [self silentUnlock];
    
    _oneLoad = false;
}

@end

@implementation TakeOnePhotoAchievementTracker

-(void)takeOnePhoto
{
    _onePhoto = true;
    
    [self evaluateCondition];
}

-(void)evaluateCondition
{
    if (![self isUnlocked])
    {
        if (_onePhoto)
        {
            [self unlock];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setBool:true forKey:@"_onePhotoUnlockedBool"];
        }
    }
}

-(void)loadSavedAchievement
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool _isAchievementUnlocked = [prefs boolForKey:@"_onePhotoUnlockedBool"];
    
    if (_isAchievementUnlocked)
        [self silentUnlock];
    
    _onePhoto = false;
}

@end

@implementation UploadOneSongAchievementTracker

-(void)uploadOneSong
{
    _uploadSong = true;
    
    [self evaluateCondition];
}

-(void)evaluateCondition
{
    if (![self isUnlocked])
    {
        if (_uploadSong)
        {
            [self unlock];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setBool:true forKey:@"_oneUploadUnlockedBool"];
        }
    }
}

-(void)loadSavedAchievement
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool _isAchievementUnlocked = [prefs boolForKey:@"_oneUploadUnlockedBool"];
    
    if (_isAchievementUnlocked)
        [self silentUnlock];
    
    _uploadSong = false;
}

@end

@implementation PlayOneSongAchievementTracker

-(void)playOneSong
{
    _playSong = true;
    
    [self evaluateCondition];
}

-(void)evaluateCondition
{
    if (![self isUnlocked])
    {
        if (_playSong)
        {
            [self unlock];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setBool:true forKey:@"_onePlayUnlockedBool"];
        }
    }
}

-(void)loadSavedAchievement
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool _isAchievementUnlocked = [prefs boolForKey:@"_onePlayUnlockedBool"];
    
    if (_isAchievementUnlocked)
        [self silentUnlock];
    
    _playSong = false;
}

@end