#import <UIKit/UIKit.h>

@class ViewController;
@class PdAudioController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    @private PdAudioController* audioController;
}

@property (nonatomic, strong) IBOutlet UIWindow* window;
@property (nonatomic, strong) IBOutlet ViewController* viewController;

@end
