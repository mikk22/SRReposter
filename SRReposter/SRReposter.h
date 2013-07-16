//
//  SRAppDelegate.h
//  SRReposter
//
//  Created by user on 18.08.12.
//

#import <UIKit/UIKit.h>

@class SRViewController;

@interface SRReposter : UIResponder <UIApplicationDelegate>
{
    UINavigationController  *_navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
