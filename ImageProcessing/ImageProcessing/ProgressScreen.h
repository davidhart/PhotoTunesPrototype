//
//  ProgressScreen.h
//  ImageProcessing
//
//  Created by MEng on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;
@class ProgressView;


@interface ShareView : UIViewController

@property (nonatomic, retain) IBOutlet ProgressView* progressView;
@property (nonatomic, retain) IBOutlet ViewController* parent;

-(IBAction)cancel:(id)sender;
-(IBAction)saveAndUpload:(id)sender;

@end


@interface ProgressView : UIViewController

@property (nonatomic, retain) IBOutlet UIProgressView* progressBar;
@property (nonatomic, retain) IBOutlet ViewController* parent;

-(void)setProgress:(float)progress;

@end
