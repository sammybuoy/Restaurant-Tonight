//
//  ItemListViewController.m
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/20/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import "ItemListViewController.h"
#import "DealTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"




@interface ItemListViewController ()
@property (strong,nonatomic) NSArray *dealsData;
@property (weak, nonatomic) IBOutlet UITableView *dealsTableView;
@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property NSInteger selectedItemId;
@end

@implementation ItemListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSDictionary *)latLongDictionary{
    if(!_latLongDictionary){
        _latLongDictionary=[@{@"latitude":@12.9715987,@"longitude":@77.5945627} mutableCopy];
    };
    return _latLongDictionary;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
    self.dealsTableView.dataSource=self;
    self.dealsTableView.delegate=self;
    [self.dealsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDataFromServer];
    // Do any additional setup after loading the view.
}
-(void)getDataFromServer{
    self.dealsData=[[NSMutableArray alloc] init];
    [self.dealsTableView reloadData];
    self.loaderView.hidden=NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDate *date=[NSDate date];
    NSString *dateStr=[self getDateTimeStrFromDate:date format:@"yyyy-MM-dd"];
    NSString *timeStr=[self getDateTimeStrFromDate:date format:@"hh:mm a"];
    NSDictionary *params=@{@"lat":self.latLongDictionary[@"latitude"],@"lng":self.latLongDictionary[@"longitude"],@"date":dateStr,@"time":@([self getTimeInMins:timeStr])};
    NSLog(@"%@",params);
    [manager GET:@"http://devservices.mygola.com/restauranttonight/nearby" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.dealsData=[[responseObject objectForKey:@"data"] objectForKey:@"deals"];
        if([self.dealsData count]){
            [self.dealsTableView reloadData];
        }
        self.loaderView.hidden=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"No Results Found" message:@"No restaurants found for current place. Try searchig at other places" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getDateTimeStrFromDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateTimeFormatter setDateFormat:format];
    return [dateTimeFormatter stringFromDate:date];
}

- (NSInteger)getTimeInMins:(NSString *)timeinAMPM {
    NSArray *seperateTimeFromAMPM=[timeinAMPM componentsSeparatedByString:@" "];
	NSString *time=[seperateTimeFromAMPM objectAtIndex:0];
	NSString *ampmString=[seperateTimeFromAMPM objectAtIndex:1];
	NSString *trimmedString = [ampmString stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceCharacterSet]];
	
    long hour = [[[time componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
	if([[trimmedString lowercaseString] isEqualToString:@"pm" ] && hour<12){
		hour=hour+12;
	}else if([[trimmedString lowercaseString] isEqualToString:@"am" ] && hour==12){
		hour=0;
	}
    long min =[[[time componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
    NSLog(@"timeInAmPm %@ timeInMins %ld", timeinAMPM, hour*60+min);
    return hour*60+min;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"DealTableViewCell";
    DealTableViewCell *cell = (DealTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *data=[self.dealsData objectAtIndex:indexPath.section];
    NSString *text=[data objectForKey:@"text"];
    NSString *msg=[data objectForKey:@"deal_msg"];
    if([[data objectForKey:@"deal_type"] isEqualToString:@"percent"]){
        cell.dealCellTextDeal.hidden=YES;
        cell.dealCellTextMessage.hidden=YES;
        cell.dealCellPercentageNumber.text=msg;
         cell.dellCellDealTextLabel.text=text;
    }else if([[data objectForKey:@"deal_type"] isEqualToString:@"free_text"]){
        cell.dellCellPercentageOff.hidden=YES;
        cell.dellCellDealTextLabel.hidden=YES;
        cell.dealCellPercentageNumber.hidden=YES;
        cell.dealCellTextDeal.text=[msg capitalizedString];
        cell.dealCellTextMessage.text=text;
    }
    
    cell.dealCellTitleLabel.text=[[data objectForKey:@"name"] capitalizedString];
    cell.dealCellAddressLabel.text=[[data objectForKey:@"address"] capitalizedString];
    [cell.dealCellImageView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"pic_url"]]];
    [cell.dealCellImageView setClipsToBounds:YES];
    [cell.dealCellImageView setContentMode:UIViewContentModeCenter];
    [cell.dealCellImageView setClipsToBounds:YES];
    [[cell.dealCellRootView layer] setCornerRadius:6.0f];
    [[cell.dealCellClaimButton layer] setCornerRadius:3.0f];
    [self beautifyCell:cell];
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    [cell.dealCellClaimButton addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside ];
    cell.dealCellClaimButton.tag=[[data objectForKey:@"id"] integerValue];
    cell.distanceLabel.text=[data objectForKey:@"distance"];
    
    return cell;
}

-(void)cellButtonClicked:(id)sender{
    self.selectedItemId=((UIControl *) sender).tag;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userId"]){
        [self createUserDeal];
    }else{
        [self performSegueWithIdentifier:@"itemListToSaveDetailsSegue" sender:self];
    }
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
    return 228.0f;
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

-(void)createUserDeal{
    self.loaderView.hidden=NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params=@{@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"deal_id":@(self.selectedItemId)};
    NSLog(@"%@",params);
    [manager GET:@"http://devservices.mygola.com/restauranttonight/createuserdeal" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self performSegueWithIdentifier:@"itemListToReservations" sender:self];
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
- (IBAction)menuButtonNavigation:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate.sideMenuViewController toggleMenuAnimated:YES completion: nil];
    
}
- (IBAction)locationButtonHandler:(id)sender {
    [self performSegueWithIdentifier:@"itemListToAutocompleteSegue" sender:self];
}

- (void)GoogleAutoCompleteViewControllerDismissedWithAddress:(NSString *)address AndLocation:(CLLocation *)location ForTextObj:(NSInteger *)textObjTag{
    self.latLongDictionary[@"latitude"]=@(location.coordinate.latitude);
    self.latLongDictionary[@"longitude"]=@(location.coordinate.longitude);
    [self getDataFromServer];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"itemListToSaveDetailsSegue"]){
        SaveDetailsViewController *sdvc=[segue destinationViewController];
        sdvc.saveDetailsViewControllerViewDelegate=self;
    }
    if([[segue identifier] isEqualToString:@"itemListToAutocompleteSegue"]){
        GoogleAutoCompleteViewController *gavc=[segue destinationViewController];
        gavc.GoogleAutoCompleteViewDelegate=self;
    }

}


@end
