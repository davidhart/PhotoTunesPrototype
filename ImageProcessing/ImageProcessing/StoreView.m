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

-(id)init:(CGRect)rect
{
    self = [super init];
    
    if (self)
    {
        [StoreItemView initImages];
        
        _score = 0;
        _unlocked = false;
        
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
    }
    
    return self;
}
        
-(void)onBuy:(id)sender
{
    // TODO: check if we have enough points
    
    NSString* message = [NSString stringWithFormat: @"Buy '%@' for %d points?", _titleLabel.text, _score];
    
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle: @"Are you sure?" 
                          message: message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Buy", nil];
    
    [alert show];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"buy");
        // buy
    }
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
    }
    
    return self;
}

-(void)addItem:(NSString *)title: (NSString *)description: (NSString*)icon: (int)cost
{
    CGRect rect = [self getRectForItem: [_storeItemViews count]];
    StoreItemView* item = [[StoreItemView alloc] init: rect];
    
    [item setTitle: title];
    [item setScore: cost];
    [item setDesc: description];
    [item setIcon: icon];
    
    [_storeItemViews addObject: item];
    [_scrollView addSubview: [item getBaseView]];
    
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

@end


@implementation StoreTracker

-(id)init:(ViewController*)parent
{
    self = [super init];
    
    if (self)
    {
        _storeView = [[StoreView alloc] init: parent];
        _storeItems = [[NSMutableArray alloc] init];
        
        [_storeView addItem:@"8bit Lead" :@"Recreate the sound of the 8bit era with this instrument": @"ach1.png" :10];
        
        [_storeView addItem:@"8bit Drum Pack": @"Recreate the sound of the 8bit era with this drum pack":
         @"ach1.png": 10];
    }
    
    return self;
}

-(void)addItem:(NSString*)title: (NSString*)desc: (NSString*) icon: (int)score: (StoreItemTracker*)tracker
{
    [_storeView addItem: title: desc: icon: score];
}

@end