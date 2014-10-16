//
//  AppDelegate.m
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/20/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.menuViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"sideMenuViewController"];
    self.mainViewController = self.window.rootViewController;
    
    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.menuViewController mainViewController: self.mainViewController];
    // specify the shadow color to use behind the main view controller when it is scaled down.
    self.sideMenuViewController.shadowColor = [UIColor blackColor];
    
    // specify a UIOffset to offset the open position of the menu
    self.sideMenuViewController.edgeOffset = UIOffsetMake(18.0f, 0.0f);
    
    // specify a scale to zoom the interface — the scale is 0.0 (scaled to 0% of it's size) to 1.0 (not scaled at all). The example here specifies that it zooms so that the main view is 56.34% of it's size in open mode.
    self.sideMenuViewController.zoomScale = 0.5634f;
    
    // set the side menu controller as the root view controller
    self.window.rootViewController = self.sideMenuViewController;
    
    // Register for Push Notitications, if running iOS 8
    // Register for Push Notifications before iOS 8
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                     UIRemoteNotificationTypeAlert |
                                                     UIRemoteNotificationTypeSound)];
    
    
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    const char *data = [deviceToken bytes];
	NSMutableString *token = [NSMutableString string];
	for (int i = 0; i < [deviceToken length]; i++) {
		[token appendFormat:@"%02.2hhX", data[i]];
	}
    NSLog(@"%@",token);
}

@end
