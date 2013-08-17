#import "StoreView.h"
#import "ViewController.h"

const float STOREITEM_LEFT_PADDING = 10;
const float STOREITEM_RIGHT_PADING = 10;
const float STOREITEM_TOP_PADDING = 10;
const float STOREITEM_HEIGHT = 90;

const float STOREITEM_TITLE_X_OFFSET = 76;
const float STOREITEM_TITLE_Y_OFFSET = 6;
const float STOREITEM_TITLE_WIDTH = 150;
const float STOREITEM_TITLE_HEIGHT = 28;

const float STOREITEM_DESC_X_OFFSET = 78;
const float STOREITEM_DESC_Y_OFFSET = 35;
const float STOREITEM_DESC_WIDTH = 214;
const float STOREITEM_DESC_HEIGHT = 43;

const float STOREITEM_BUY_X_OFFSET = 230;
const float STOREITEM_BUY_Y_OFFSET = 6;
const float STOREITEM_BUY_WIDTH = 60;
const float STOREITEM_BUY_HEIGHT = 32;

const float STOREITEM_ICON_X_OFFSET = 16;
const float STOREITEM_ICON_Y_OFFSET = 18;
const float STOREITEM_ICON_WIDTH = 53;
const float STOREITEM_ICON_HEIGHT = 53;

UIImage* g_storeLockedBaseImage;
UIImage* g_storeUnlockedBaseImage;
UIImage* g_storeOverlayImage;

@implementation StoreItemView

-(id)init:(CGRect)rect:(int)index
{
    self = [super init];
    
    if (self)
    {
        [StoreItemView initImages];
        
        _score = 0;
        _unlocked = false;
        _index = index;
        
        // Base image / control
        _base = [[UIImageView alloc] initWithFrame:rect];
        _base.image = [self getBaseImage];
        [_base setUserInteractionEnabled: YES];
        
        // Icon graphic
        CGRect iconRect = CGRectMake(STOREITEM_ICON_X_OFFSET,
                                     STOREITEM_ICON_Y_OFFSET,
                                     STOREITEM_ICON_WIDTH,
                                     STOREITEM_ICON_HEIGHT);
        
        _icon = [[UIImageView alloc] initWithFrame:iconRect];
        _icon.backgroundColor = [UIColor purpleColor];
        [_base addSubview: _icon];
        
        // Overlay graphic
        CGRect overlayRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
        
        _iconOverlay = [[UIImageView alloc] initWithFrame: overlayRect];
        _iconOverlay.image = g_storeOverlayImage;
        //[_iconOverlay setUserInteractionEnabled: false];
        [_base addSubview: _iconOverlay];
        
        // Title label
        CGRect titleRect = CGRectMake(STOREITEM_TITLE_X_OFFSET, 
                                      STOREITEM_TITLE_Y_OFFSET, 
                                      STOREITEM_TITLE_WIDTH,
                                      STOREITEM_TITLE_HEIGHT);
        
        _titleLabel = [[UILabel alloc] initWithFrame: titleRect];
        _titleLabel.text = @"Default Title";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName: _titleLabel.font.familyName size: 25];
        
        [_base addSubview: _titleLabel];
        
        // Description label
        CGRect descRect = CGRectMake(STOREITEM_DESC_X_OFFSET, 
                                     STOREITEM_DESC_Y_OFFSET, 
                                     STOREITEM_DESC_WIDTH, 
                                     STOREITEM_DESC_HEIGHT);
        
        _descriptionLabel = [[UILabel alloc] initWithFrame: descRect];
        _descriptionLabel.text = @"Default description";
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        _descriptionLabel.numberOfLines = 2;
        
        [_base addSubview: _descriptionLabel];
        
        // Score label
        
        CGRect buyRect = CGRectMake(STOREITEM_BUY_X_OFFSET, 
                                      STOREITEM_BUY_Y_OFFSET, 
                                      STOREITEM_BUY_WIDTH, 
                                      STOREITEM_BUY_HEIGHT);
        
        
        _buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buyButton addTarget: self action:@selector(onBuy:) forControlEvents:UIControlEventTouchUpInside];
        _buyButton.frame = buyRect;
        [_buyButton setTitle: @"Buy 50" forState:UIControlStateNormal];
        [_base addSubview: _buyButton];
        
        NSLog(@"LoadingInit: unlock%d", _index);
        
        // Load unlock state
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bool isUnlocked = [prefs boolForKey:
                           [NSString stringWithFormat: @"%@", _instName]];
        
        [self setUnlocked: isUnlocked];
    }
    
    return self;
}
        
-(void)onBuy:(id)sender
{
    // If we have enough points
    if ([_parent getPoints] >= _score)
    {    
        NSString* message = [NSString stringWithFormat: @"Buy '%@' for %d points?", _titleLabel.text, _score];
    
        UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle: @"Are you sure?" 
                          message: message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Buy", nil];
    
        [alert show];
    }
    else
    {
        NSString* message = [NSString stringWithFormat: @"You need %d points before you can unlock '%@'", _score, _titleLabel.text];
        
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"Unlock more badges first!" 
                              message: message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
}

-(UIView*)getBaseView
{
    return (UIView*)_base;
}

-(UIImage*)getBaseImage
{
    if (_unlocked)
        return g_storeUnlockedBaseImage;
    else 
        return g_storeLockedBaseImage;
}

+(void)initImages
{
    if (g_storeUnlockedBaseImage == nil)
        g_storeUnlockedBaseImage = [UIImage imageNamed: @"ach-unlocked-base.png"];
    
    if (g_storeLockedBaseImage == nil)
        g_storeLockedBaseImage = [UIImage imageNamed: @"ach-locked-base.png"];
    
    if (g_storeOverlayImage == nil)
        g_storeOverlayImage = [UIImage imageNamed: @"ach-overlay.png"];
}

-(void)setUnlocked:(bool)unlocked
{
    _unlocked = unlocked;
    
    _base.image = [self getBaseImage];
    
    // Hide buy button on unlocked items
    _buyButton.hidden = unlocked;
    
    // Save unlock state_instName
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:_unlocked forKey:[NSString stringWithFormat: @"%@", _instName]];
}

-(bool)isUnlocked
{
    return _unlocked;
}

-(void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

-(void)setDesc:(NSString *)description
{
    _descriptionLabel.text = description;
}

-(void)setIcon:(NSString *)icon
{
    _icon.image = [UIImage imageNamed: icon];
}

-(void)setScore:(int)score
{
    _score = score;
    
    [_buyButton setTitle: [NSString stringWithFormat: @"Buy %d", score] forState:UIControlStateNormal];
}

-(void)setInstName:(NSString *)description
{
    _instName = description;
}

-(int)getScore
{
    return _score;
}

-(void)setParent:(StoreView *)parent
{
    _parent = parent;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self unlock];
    }
}

-(void)unlock
{
    [self setUnlocked: true];
    
    [_parent onUnlock];
    
    // Write config?
    // Update something global?
}

@end

@implementation StoreView

-(id)init:(ViewController*)parent
{
    self = [super init];
    
    if (self)
    {
        _scrollView = parent.storeScrollView;
        _storeItemViews = [[NSMutableArray alloc] init];
        _view = parent;
    }
    
    return self;
}

-(void)addItem:(NSString *)title: (NSString *)description: (NSString*)icon: (int)cost: (NSString*)InstName
{
    CGRect rect = [self getRectForItem: [_storeItemViews count]];
    
    int index = [_storeItemViews count];
    
    StoreItemView* item = [[StoreItemView alloc] init: rect: index];
    
    [item setTitle: title];
    [item setScore: cost];
    [item setDesc: description];
    [item setIcon: icon];
    [item setInstName: InstName];
    [item setParent: self];
    
    [_storeItemViews addObject: item];
    [_scrollView addSubview: [item getBaseView]];
    [_view updateStoreAndAchievements];    
    
    [self resizeScrollView];
}

-(void)resizeScrollView
{
    int index = [_storeItemViews count] - 1;
    
    CGRect rect = [self getRectForItem:index];
    
    CGSize contentsize = CGSizeMake(_scrollView.contentSize.width,
                                    rect.origin.y + rect.size.height + STOREITEM_TOP_PADDING);
    
    _scrollView.contentSize = contentsize;
}

-(CGRect)getRectForItem:(int)index
{
    return CGRectMake(STOREITEM_LEFT_PADDING,
                      (index + 1) * STOREITEM_TOP_PADDING + index * STOREITEM_HEIGHT, 
                      _scrollView.frame.size.width - STOREITEM_LEFT_PADDING - STOREITEM_RIGHT_PADING,
                      STOREITEM_HEIGHT);
}

-(void)setPoints:(int)points
{
    _points = points;
}

-(int)getPoints
{
    return _points;
}

-(void)onUnlock
{
    [_view updateStoreAndAchievements];
}

-(StoreItemView*)getStoreItem:(int)index
{
    return (StoreItemView*)[_storeItemViews objectAtIndex: index];
}

-(int)getTotalItems
{
    return [_storeItemViews count];
}

@end


@implementation StoreTracker

-(id)init:(ViewController*)parent
{
    self = [super init];
    
    if (self)
    {
        _storeView = [[StoreView alloc] init: parent];
        
        [_storeView addItem:@"8bit Lead" :@"Recreate the sound of the 8bit era with this instrument": @"ach1.png" :10 :@"INST8-BIT"];
        
        [_storeView addItem:@"8bit Drum Pack": @"Recreate the sound of the 8bit era with this drum pack":
         @"ach1.png": 20: @"DRUMSTAND"];
    }
    
    return self;
}

-(void)addItem:(NSString*)title: (NSString*)desc: (NSString*) icon: (int)score: (NSString*)InstName
{
    [_storeView addItem: title: desc: icon: score: InstName];
}

-(void)setPoints:(int)points
{
    [_storeView setPoints: points];
}

-(int)getCostOfUnlockedItems
{
    int cost = 0;
    
    for (int i = 0; i < [self getTotalItems]; ++i)
    {
        StoreItemView* item = [_storeView getStoreItem: i];
        
        if ([item isUnlocked])
            cost += [item getScore];        
    }
    
    return cost;
}

-(int)getTotalItems
{
    return [_storeView getTotalItems];
}

-(int)getItemsUnlocked
{
    int items = 0;
    
    for (int i = 0; i < [self getTotalItems]; ++i)
    {
        StoreItemView* item = [_storeView getStoreItem: i];
        
        if ([item isUnlocked])
            items++;
    }
    
    return items;
}

@end