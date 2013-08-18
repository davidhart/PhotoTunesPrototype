#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ViewController;
@class StoreTracker;

@interface AchievementView : NSObject
{
    @private UIImageView* _base;
    @private UIImageView* _icon;
    @private UIImageView* _iconOverlay;
    
    @private UILabel* _titleLabel;
    @private UILabel* _scoreLabel;
    @private UILabel* _descriptionLabel;
    
    @private bool _unlocked;
}

-(id)init: (CGRect) frame;

-(void)setUnlocked:(bool)unlocked;
-(void)setTitle:(NSString*)title;
-(void)setDescription:(NSString*)description;
-(void)setPoints:(int)points;
-(void)setIcon:(NSString*)icon;

-(UIImage*)GetIcon;
-(UIImage*)GetIconOverlay;

-(NSString*)GetTitle;
-(NSString*)GetDesc;

-(UIControl*) GetUIControl;

@end

@interface AchievementsView : NSObject
{
    // Toolbar labels   
    @private UIScrollView* _achievementsView;
    @private UIToolbar* _achievementsToolbar;
    
    @private NSMutableArray* _achievementViews;
    
    @private UIImageView* _achieveUnlocked;
    
    @private UIImageView* _base;
    @private UIImageView* _icon;
    @private UIImageView* _iconOverlay;
    
    @private UILabel* _titleLabel;
    @private UILabel* _scoreLabel;
    @private UILabel* _descriptionLabel;
    
    @private ViewController* _view;
}

-(id)init: (ViewController*) view;
-(int)addAchievement: (NSString*) title :(NSString*)descr :(NSString*)icon :(int)points;

-(void)setScore:(int)score;
-(void)setAchUnlocked:(int)achUnlocked;

@end

@class AchievementsTracker;

@interface BaseTracker : NSObject
{
    @private AchievementsTracker* _tracker;
    @protected int _index;
    @private bool _unlocked;
    
    @public int score;
}

-(void)unlock;
-(void)silentUnlock;
-(bool)isUnlocked;

-(void)setParent: (AchievementsTracker*) tracker;
-(void)setIndex: (int) index;

-(void)tempoChanged;
-(void)drumVolChanged;
-(void)melodyVolumeChanged;
-(void)lengthChanged;
-(void)instrumentChanged;
-(void)drumsChanged;
-(void)imageChanged;

-(void)loadOneImage;
-(void)takeOnePhoto;

-(void)uploadOneSong;
-(void)playOneSong;

-(void)loadSavedAchievement;

@end

@interface AchievementsTracker : NSObject
{
    @private AchievementsView* _achievementsView;
    @private NSMutableArray* _trackers;
    @private ViewController* _view;
}

-(id)init:(ViewController*) view;

-(void)tempoChanged;
-(void)drumVolChanged;
-(void)melodyVolumeChanged;
-(void)lengthChanged;
-(void)instrumentChanged;
-(void)imageChanged;
-(void)drumsChanged;

-(void)loadOneImage;
-(void)takeOnePhoto;

-(void)uploadOneSong;
-(void)playOneSong;

-(void)unlockAchievement:(int) index;
-(void)silentUnlockAchievement:(int)index;

-(int)getUnlockedPoints;
-(int)getUnlockedAchievements;
-(int)getTotalAchievements;

@end

///////////////////////////////////
// Achievement specific trackers
///////////////////////////////////

@interface PerfectionistAchievementTracker : BaseTracker
{
    @private bool _tempoChanged;
    @private bool _drumVolumeChanged;
    @private bool _melodyVolumeChanged;
    @private bool _lengthChanged;
    @private bool _instrumentChanged;
    @private bool _drumChanged;
}

-(void)loadSavedAchievement;

@end

@interface PhotocountTracker : BaseTracker
{
    @private int _count;
    @private int _unlockCount;
}

-(void)setUnlockCount:(int)unlockCount;

-(void)loadSavedAchievement;

@end

@interface LoadOneImageAchievementTracker : BaseTracker
{
    @private bool _oneLoad;
}

-(void)loadSavedAchievement;

@end

@interface TakeOnePhotoAchievementTracker : BaseTracker
{
    @private bool _onePhoto;
}

-(void)loadSavedAchievement;

@end;

@interface UploadOneSongAchievementTracker : BaseTracker
{
@private bool _uploadSong;
}

-(void)loadSavedAchievement;

@end

@interface PlayOneSongAchievementTracker : BaseTracker
{
@private bool _playSong;
}

-(void)loadSavedAchievement;

@end;
