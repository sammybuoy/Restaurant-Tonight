//
//  DealTableViewCell.h
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/20/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *dealCellRootView;
@property (weak, nonatomic) IBOutlet UILabel *dealCellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealCellAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dealCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealCellPercentageNumber;
@property (weak, nonatomic) IBOutlet UILabel *dellCellDealTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealCellClaimButton;
@property (weak, nonatomic) IBOutlet UILabel *dellCellPercentageOff;
@property (weak, nonatomic) IBOutlet UILabel *dealCellTextDeal;
@property (weak, nonatomic) IBOutlet UILabel *dealCellTextMessage;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@end
