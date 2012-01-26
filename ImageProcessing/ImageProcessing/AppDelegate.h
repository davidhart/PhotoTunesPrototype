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

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    PdAudio* _pdAudio;
}

//@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet ViewController* viewController;

@end
