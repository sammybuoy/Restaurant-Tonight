//
//  SaveDetailsViewController.m
//  RestaurantTonightiPhoneApp
//
//  Created by Samyak on 9/20/14.
//  Copyright (c) 2014 RestaurantTonight. All rights reserved.
//

#import "SaveDetailsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Stripe/STPCard.h>
#import <Stripe/Stripe.h>


@interface SaveDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIView *wrapperView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *addYourCardButton;
@property (weak, nonatomic) IBOutlet UIView *loaderView;

@property (strong,nonatomic) STPCard *card;
@property (strong,nonatomic) NSString *cardId;
@property (strong,nonatomic) NSString *stripeToken;
@property BOOL saveButtonClicked;
@property BOOL tokenGenerated;
@end

@implementation SaveDetailsViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [[self.wrapperView layer] setCornerRadius:3.0f];
    [[self.wrapperView layer] setBorderWidth:1.0f];
    [[self.wrapperView layer] setBorderColor:[UIColor colorWithRed:(225/255.0f) green:(225/255.0f) blue:(225/255.0f) alpha:1.0f].CGColor];
    // Do any additional setup after loading the view.
}
- (IBAction)backButtonHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveAndContinueHandler:(id)sender {
    if([self.nameTextField.text isEqualToString:@""] || [self.phoneTextField.text isEqualToString:@""] || [self.cardId isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Restaurant Tonight" message:@"Please enter all the details" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        self.loaderView.hidden=YES;
    }
    if(self.tokenGenerated){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params=@{@"name":self.nameTextField.text,@"phone":self.phoneTextField.text,@"token":self.stripeToken};
        [manager GET:@"http://devservices.mygola.com/restauranttonight/createuser" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *userId=[[responseObject objectForKey:@"data"] objectForKey:@"user_id"];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:userId forKey:@"userId"];
            [self.saveDetailsViewControllerViewDelegate createUserDeal];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    [self markSaveButtonAsClicked];
}
-(void)markSaveButtonAsClicked{
    self.loaderView.hidden=NO;
    self.saveButtonClicked=YES;
}

- (IBAction)addYourCardHandler:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"9fc636a4a74d4126840a8ea53f6818cf"; // get your app token from the card.io website
    [self presentViewController:scanViewController animated:YES completion:nil];
    return;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv);
    self.card = [[STPCard alloc] init];
    self.card.number = info.cardNumber;
    self.card.expMonth = info.expiryMonth;
    self.card.expYear = info.expiryYear;
    self.card.cvc = info.cvv;
    self.tokenGenerated=NO;
    self.cardId=nil;
    [self.addYourCardButton setTitle:info.redactedCardNumber forState:UIControlStateNormal];
    [self generateStripeTokenFromCard];
    // Use the card info...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)generateStripeTokenFromCard{
    NSString *publishableKey=@"pk_test_v1LKuxjQVrIY2XcLE61CBwyI";
    [Stripe createTokenWithCard:self.card
                 publishableKey:publishableKey
                     completion:^(STPToken *token, NSError *error) {
                         if(error){
                             NSString *title;
                             NSString *message;
                             if([error code]==70){
                                 title=@"Please enter a valid card";
                                 message=[error localizedDescription];
                             }else{
                                 title=@"Restaurant Tonight";
                                 message=@"Something has messed up our warp drive! Our flight deck engineers are on it.";
                             }
                             UIAlertView *alertBox=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                             [alertBox show];
                             //                             self.loaderView.hidden=YES;
                             [self.addYourCardButton setTitle:@"Add Your Card" forState:UIControlStateNormal];
                         }else{
                             NSLog(@"Strip token recieved is %@",token.tokenId);
                             self.stripeToken=token.tokenId;
                             self.tokenGenerated=YES;
                             if(self.saveButtonClicked){
                                 [self saveAndContinueHandler:self];
                             }
                         }
                     }];
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
