#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ViewController;

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
}

-(id)init: (ViewController*) view;
-(int)addAchievement: (NSString*) title: (NSString*)descr: (NSString*)icon: (int) points;

@end

@class AchievementsTracker;

@interface BaseTracker : NSObject
{
    @private AchievementsTracker* _tracker;
    @protected int _index;
    @private bool _unlocked;
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
-(void)imageChanged;

-(void)loadSavedAchievement;

@end

@interface AchievementsTracker : NSObject
{
    @private AchievementsView* _achievementsView;
    @private NSMutableArray* _trackers;
}

-(id)init:(ViewController*) view;

-(void)tempoChanged;
-(void)drumVolChanged;
-(void)melodyVolumeChanged;
-(void)lengthChanged;
-(void)instrumentChanged;
-(void)imageChanged;

-(void)unlockAchievement:(int) index;
-(void)silentUnlockAchievement:(int)index;

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
