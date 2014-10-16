//
//  SaveDetailsViewController.h
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/20/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CardIO.h>
@protocol SaveDetailsViewControllerViewDelegate<NSObject>
-(void)createUserDeal;
@end

@interface SaveDetailsViewController : UIViewController<CardIOPaymentViewControllerDelegate>
@property (strong,nonatomic)id<SaveDetailsViewControllerViewDelegate>saveDetailsViewControllerViewDelegate;
@end
