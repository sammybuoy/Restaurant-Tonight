//
//  AppDelegate.h
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/20/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TWTSideMenuViewController/TWTSideMenuViewController.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UIViewController *menuViewController;
@property (strong,nonatomic) UIViewController *mainViewController;
@property (strong,nonatomic) TWTSideMenuViewController *sideMenuViewController;

@end
