//
//  SRAppDelegate.m
//  SRReposter
//
//  Created by user on 18.08.12.
//

#import "SRReporter.h"
#import "SRFeedsListViewController.h"
#import "RPLSHKFacebook.h"
#import "RPLSHKConfigurator.h"

@implementation SRReporter

@synthesize window = _window;
@synthesize navigationController = _navigationController;

-(void)dealloc
{
    self.navigationController=nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DefaultSHKConfigurator *configurator = [[RPLSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Database.sqlite"];
    
    SRFeedsListViewController *feedListViewController=[[SRFeedsListViewController alloc] initWithStyle:UITableViewStylePlain];
    self.navigationController=[[UINavigationController alloc] initWithRootViewController:feedListViewController];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [RPLSHKFacebook applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [RPLSHKFacebook applicationWillTerminate];
    [MagicalRecord cleanUp];
}


- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
    return [RPLSHKFacebook handleOpenURL:url];
}

@end
