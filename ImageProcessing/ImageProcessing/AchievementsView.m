//
#import "AchievementsView.h"

#import "ViewController.h"


const float ACHIEVEMENT_LEFT_PADDING = 10;
const float ACHIEVEMENT_RIGHT_PADING = 10;
const float ACHIEVEMENT_TOP_PADDING = 10;
const float ACHIEVEMENT_HEIGHT = 90;

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
        
        _base = [[UIImageView alloc] initWithFrame:frame];
        _base.image = [self GetBaseImage];
        
        CGRect overlayRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        _iconOverlay = [[UIImageView alloc] initWithFrame: overlayRect];
        _iconOverlay.image = g_AchievementOverlayImage;
        [_base addSubview: _iconOverlay];
    }
    
    return self;
}

-(UIControl*)GetUIControl
{
    return _base;
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
}

@end


// UI Object to control all displayed achievements
@implementation AchievementsView

-(id)init: (ViewController*)view
{
    self = [super init];
    
    if (self)
    {
        _achievementsView = view.achievementsScrollView;
        _achievementsToolbar = view.achievementsToolbar;
        
        _achievementViews = [[NSMutableArray alloc] init];
              
        CGRect rect;
        
        for (int i = 0; i < 20; ++i)
        {
            rect = [self calculateAchievementRect:i];
            
            AchievementView* achievement = [[AchievementView alloc]init: rect];
            
            
            [_achievementsView addSubview: [achievement GetUIControl]];
            [_achievementViews addObject: achievement];
            
            if (i % 3 == 0 || i % 4 == 0)
                [achievement setUnlocked: true];
        }
        
        CGSize contentsize = CGSizeMake(_achievementsView.contentSize.width,
                                        rect.origin.y + rect.size.height + ACHIEVEMENT_TOP_PADDING);
        
        _achievementsView.contentSize = contentsize;
    }
    
    return self;
}

-(CGRect)calculateAchievementRect: (int)index
{
    return CGRectMake(ACHIEVEMENT_LEFT_PADDING,
           (index + 1) * ACHIEVEMENT_TOP_PADDING + index * ACHIEVEMENT_HEIGHT, 
           _achievementsView.frame.size.width - ACHIEVEMENT_LEFT_PADDING - ACHIEVEMENT_RIGHT_PADING,
           ACHIEVEMENT_HEIGHT);
}

@end
