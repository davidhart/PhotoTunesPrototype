#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ViewController;

@interface AchievementView : NSObject
{
    @private UIImageView* _base;
    @private UIImageView* _icon;
    @private UIImageView* _iconOverlay;
    
    @private bool _unlocked;
}

-(id)init: (CGRect) frame;

-(void)setUnlocked:(bool)unlocked;

-(UIControl*) GetUIControl;

@end

@interface AchievementsView : NSObject
{
    @private UIScrollView* _achievementsView;
    @private UIToolbar* _achievementsToolbar;
    
    @private NSMutableArray* _achievementViews;
}

-(id)init: (ViewController*) view;

@end
