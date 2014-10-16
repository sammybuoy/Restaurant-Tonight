//
//  SideMenuViewController.m
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/21/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import "SideMenuViewController.h"
#import "AppDelegate.h"
#import "ReservationsViewController.h"
#import "ItemListViewController.h"
@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)reservationButtonHandler:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    ReservationsViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReservationViewController"];
    vc.previousController=self;
    [delegate.sideMenuViewController setMainViewController:vc animated:YES closeMenu:YES];
}
- (IBAction)receiptsButtonHandler:(id)sender {
}
- (IBAction)myProfileButtonHandler:(id)sender {
}
- (IBAction)restaurantsDealsButtonHandler:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    ItemListViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ItemListViewController"];
    [delegate.sideMenuViewController setMainViewController:vc animated:YES closeMenu:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
