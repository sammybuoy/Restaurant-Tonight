//
//  ReservationsViewController.m
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/21/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import "ReservationsViewController.h"
#import "ReservationsTableViewCell.h"
#import "AppDelegate.h"

@interface ReservationsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *reservationTableView;
@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (strong,nonatomic) NSArray *dealsData;

@end

@implementation ReservationsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.reservationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
- (IBAction)sideMenuButton:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate.sideMenuViewController toggleMenuAnimated:YES completion: nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.reservationTableView.dataSource=self;
    self.reservationTableView.delegate=self;
    [self getDataFromServer];
    // Do any additional setup after loading the view.
}
-(void)getDataFromServer{
    self.loaderView.hidden=NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        NSDictionary *params=@{@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]};
        [manager GET:@"http://devservices.mygola.com/restauranttonight/mydeals" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.dealsData=[[responseObject objectForKey:@"data"] objectForKey:@"deals"];
            if([self.dealsData count]){
                [self.reservationTableView reloadData];
            }
            self.loaderView.hidden=YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }else{
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Reservations" message:@"You don't have any reservation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        self.loaderView.hidden=NO;

    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ReservationsTableViewCell";
    ReservationsTableViewCell *cell = (ReservationsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *data=[self.dealsData objectAtIndex:indexPath.row];
    cell.reservationCellTitleLabel.text=[[data objectForKey:@"name"] capitalizedString];
    cell.reservationCellAddressLabel.text=[[data objectForKey:@"address"] capitalizedString];
    cell.reservationCellTextLabel.text=[data objectForKey:@"text"];
    NSString *msg=[data objectForKey:@"deal_msg"];
    if([[data objectForKey:@"deal_type"] isEqualToString:@"percent"]){
        msg=[msg stringByAppendingString:@"% off"];
    }
    cell.reservationCellMessageLabel.text=msg;
    
    
    [[cell.reservationCellRootView layer] setCornerRadius:6.0f];
    [self beautifyCell:cell];
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)beautifyCell:(UITableViewCell*)cell{
    [[cell layer] setBorderColor:[UIColor colorWithRed:(225/255.0f) green:(225/255.0f) blue:(225/255.0f) alpha:1.0f].CGColor];
    [[cell layer] setBorderWidth:0.8f];
    [[cell layer] setCornerRadius:3.0f];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dealsData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16.0f;
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

