//
//  ViewController.m
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/20/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import "HomeViewController.h"
#import "ItemListViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSMutableDictionary *latLongDictionary;
@property BOOL gettingLocation;
@property (weak, nonatomic) IBOutlet UIButton *findDealsNowButton;

@end

@implementation HomeViewController

- (CLLocationManager *)locationManager{
	if(!_locationManager){
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	return _locationManager;
}


-(NSMutableDictionary *)latLongDictionary{
    if(!_latLongDictionary){
        _latLongDictionary=[@{@"latitude":@12.9715987,@"longitude":@77.5945627} mutableCopy];
    };
    return _latLongDictionary;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startUpdatingLocation];
    [[self.findDealsNowButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.findDealsNowButton layer] setBorderWidth:0.5f];
    [[self.findDealsNowButton layer] setCornerRadius:3.0f];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startUpdatingLocation{
	self.gettingLocation = true;
	[self.locationManager startUpdatingLocation];
}

- (void) stopUpdatingLocation{
	self.gettingLocation = false;
	[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	@synchronized(self){
		NSLog(@"didFailWithError: %@", error);
		if(!self.gettingLocation) return;
		[self stopUpdatingLocation];
		NSString *message =@"Failed to Get Your Location";
		NSString *title = @"Error";
		if(![CLLocationManager locationServicesEnabled]){
			message = @"To turn on location, go to Setting > Privacy > Location";
			title = @"Location disabled!";
		}else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
			message = @"To turn on location permission for Perfect Day, go to Setting > Privacy > Location > RestaurantTonight";
			title = @"Need location permission!";
		}
		UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	@synchronized(self){
		if(!self.gettingLocation) return;
		[self stopUpdatingLocation];
		NSLog(@"didUpdateToLocation: %@", newLocation);
		if (newLocation && [self isNewLocationWithinRadius:newLocation]) {
            self.latLongDictionary[@"latitude"]=@(newLocation.coordinate.latitude);
            self.latLongDictionary[@"longitude"]=@(newLocation.coordinate.longitude);
		}else{
			UIAlertView *errorAlert = [[UIAlertView alloc]
									   initWithTitle:@"Get Closer" message:@"You are too far from the cool stuff. Try choosing a location closer to the city." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
		}
		
	}
}

- (BOOL)isNewLocationWithinRadius :(CLLocation *)newLocation{
    float latitude=12.9715987;
	float longitude=77.5945627;
	CLLocation *cityCenter = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	CLLocationDistance distance = [cityCenter distanceFromLocation:newLocation];
	return (distance/1000) <= 50.0f;
}
- (IBAction)findDealsButtonHandler:(id)sender {

    [self performSegueWithIdentifier:@"homeToItemListSegue" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"homeToItemListSegue"]){
        ItemListViewController *ilvc=[segue destinationViewController];
        ilvc.latLongDictionary=self.latLongDictionary;
    }
}


@end
