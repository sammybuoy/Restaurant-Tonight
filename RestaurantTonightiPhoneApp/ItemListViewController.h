//
//  ItemListViewController.h
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/20/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "SaveDetailsViewController.h"
#import "GoogleAutoCompleteViewController.h"

@interface ItemListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SaveDetailsViewControllerViewDelegate,GoogleAutoCompleteViewDelegate>
@property (strong,nonatomic) NSMutableDictionary *latLongDictionary;
@end
