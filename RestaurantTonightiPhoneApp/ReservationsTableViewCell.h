//
//  ReservationsTableViewCell.h
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/21/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reservationCellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationCellAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationCellMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationCellTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationCellValidityLabel;
@property (weak, nonatomic) IBOutlet UIView *reservationCellRootView;
@property (weak, nonatomic) IBOutlet UIButton *getDirectionsButton;

@end
