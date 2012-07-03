//
//  StoreView.h
//  ImageProcessing
//
//  Created by user on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;

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
}

-(id)init:(CGRect)rect;
-(UIView*)getBaseView;

-(UIImage*)getBaseImage;

+(void)initImages;

-(void)setUnlocked:(bool)unlocked;
-(void)setTitle:(NSString*)title;
-(void)setDesc:(NSString*)description;
-(void)setIcon:(NSString*)icon;
-(void)setScore:(int)score;

@end

@interface StoreView : NSObject
{
    @private UIScrollView* _scrollView;
    @private NSMutableArray* _storeItemViews;
}

-(id)init:(ViewController*)parent;
-(CGRect)getRectForItem:(int)index;
-(void)addItem:(NSString*) title: (NSString*) description: (NSString*)icon: (int)cost;


-(void)resizeScrollView;

@end


@interface StoreItemTracker : NSObject

-(id)init;
-(void)unlock;

@end

@interface StoreTracker : NSObject
{
    StoreView* _storeView;
    NSMutableArray* _storeItems;
}

-(id)init:(ViewController*)parent;

@end
