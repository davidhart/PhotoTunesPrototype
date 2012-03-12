//
//  AppDelegate.m
//  ImageProcessing
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PdAudioController.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, retain) PdAudioController *audioController;

@end

@implementation AppDelegate

@synthesize window;
@synthesize viewController;
@synthesize audioController = audioController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window addSubview:[self.viewController view]];
    [self.window makeKeyAndVisible];
    
    /*
#if TARGET_IPHONE_SIMULATOR	
	int ticksPerBuffer = 512 / [PdBase getBlockSize]; // apparently the only way to get clean audio output with the simulator
    int sampleRate = 44100;
#else
    int ticksPerBuffer = 32;
    int sampleRate = 22050;
#endif
	_pdAudio = [[PdAudio alloc] initWithSampleRate:sampleRate andTicksPerBuffer:ticksPerBuffer andNumberOfInputChannels:1 andNumberOfOutputChannels:1 
                                                  andAudioSessionCategory:kAudioSessionCategory_MediaPlayback];
    
	[PdBase computeAudio:YES];
    [_pdAudio pause];*/
    
    self.audioController = [[PdAudioController alloc] init];
	[self.audioController configureAmbientWithSampleRate:22050 numberChannels:2 mixingEnabled:YES];
	[self.audioController setActive:YES];
	[self.audioController print];

    [viewController initialize: audioController];
    
    /*
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = viewController;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.tabBarController presentModalViewController:imagePickerController animated:YES];
    */
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
