//
//  AppDelegate.h
//  ImageProcessing
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudio.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    PdAudio* _pdAudio;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
