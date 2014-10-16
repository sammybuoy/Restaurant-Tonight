//
//  ReservationsViewController.h
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/21/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
@interface ReservationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UIViewController* previousController;
@end
