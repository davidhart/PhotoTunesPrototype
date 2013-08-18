#import <Foundation/Foundation.h>

@class ViewController;
@class StoreView;

@interface StoreItemView : NSObject<UIAlertViewDelegate>
{
    @private UIImageView* _base;
    
    @private UIImageView* _icon;
    @private UIImageView* _iconOverlay;
    
    @private UILabel* _titleLabel;
    @private UIButton* _buyButton;
    @private UILabel* _descriptionLabel;
    
    @private bool _unlocked;
    @private int _score;
    @private int _index;
    @private NSString* _instName;
    
    @private StoreView* _parent;
}

-(id)init:(CGRect)rect :(int)index;
-(UIView*)getBaseView;

-(UIImage*)getBaseImage;

+(void)initImages;

-(void)setUnlocked:(bool)unlocked;
-(bool)isUnlocked;

-(void)setTitle:(NSString*)title;
-(void)setDesc:(NSString*)description;
-(void)setIcon:(NSString*)icon;
-(void)setScore:(int)score;
-(void)setInstName:(NSString*)InstName;
-(int)getScore;

-(void)setParent:(StoreView*)parent;

@end

@interface StoreView : NSObject
{
    @private UIScrollView* _scrollView;
    @private NSMutableArray* _storeItemViews;
    
    @private int _points;
    
    @private ViewController* _view;
}

-(id)init:(ViewController*)parent;
-(CGRect)getRectForItem:(int)index;
-(void)addItem:(NSString*) title: (NSString*) description: (NSString*)icon: (int)cost: (NSString*)InstName;


-(void)resizeScrollView;

-(void)setPoints:(int)points;
-(int)getPoints;

-(void)onUnlock;

-(StoreItemView*)getStoreItem:(int)index;
-(int)getTotalItems;

@end

@interface StoreTracker : NSObject
{
    StoreView* _storeView;
}

-(id)init:(ViewController*)parent;

-(void)setPoints:(int)points;

-(int)getCostOfUnlockedItems;
-(int)getTotalItems;
-(int)getItemsUnlocked;

@end
