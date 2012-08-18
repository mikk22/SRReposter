//
//  SRAppDelegate.h
//  SRReposter
//
//  Created by user on 18.08.12.
//  Copyright (c) 2012 Intelvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRViewController;

@interface SRReporter : UIResponder <UIApplicationDelegate>
{
    UINavigationController  *_navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
