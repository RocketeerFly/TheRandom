//
//  SettingViewController.m
//  TheRandom
//
//  Created by RocketeerFly on 9/26/18.
//  Copyright © 2018 Rocketeer. All rights reserved.
//

#import "SettingViewController.h"
#import "SVProgressHUD.h"
@import FirebaseAnalytics;

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton *buttonUnlock;
@property (weak, nonatomic) IBOutlet UIButton *buttonRestore;
@property (weak, nonatomic) IBOutlet UIButton *buttonNoThanks;
@property (nonatomic, strong) SKProduct* product;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _viewContainer.layer.shadowColor = UIColor.blackColor.CGColor;
    _viewContainer.layer.shadowOffset = CGSizeMake(1, 1);
    _viewContainer.layer.shadowRadius = 4;
    _viewContainer.layer.shadowOpacity = 0.4;
    _viewContainer.layer.cornerRadius = 6;
    
    _buttonUnlock.layer.cornerRadius = 6;
    
    [_buttonNoThanks setHidden:!_isPopup];
    [self fetchProducts];
    _buttonRestore.enabled = NO;
    _buttonUnlock.enabled = NO;
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    if ([self areAdsRemoved]) {
        [_buttonRestore setHidden:YES];
        [self.viewContainer setHidden:YES];
        self.view.backgroundColor = [UIColor colorWithRed:13/255.0 green:13/255.0 blue:13/255.0 alpha:1.0];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [FIRAnalytics logEventWithName:@"ShowSettingScreen" parameters:@{@"isPopup": self.isPopup ? @"1" : @"0"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - Storekit Delegate
-(void)fetchProducts {
    NSLog(@"User request to remove ads");
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"User can make payments");
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"rocketeerfly.randomtool.removeads"]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else {
        [FIRAnalytics logEventWithName:@"Cannot make payments due to Parental Controls" parameters:nil];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"🙁 Payment Error" message:@"You cannot make payments due to Parental Controls setting" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    SKProduct* validProduct = nil;
    NSInteger count = [response.products count];
    if (count > 0) {
        validProduct = [response.products objectAtIndex:0];
        self.product = validProduct;
        _buttonUnlock.enabled = YES;
        _buttonRestore.enabled = YES;
        NSLog(@"product %@", validProduct.productIdentifier);
    }
    else {
        [FIRAnalytics logEventWithName:@"No product available" parameters:nil];
        NSLog(@"No Product available");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"🙁 Payment Error" message:@"Something went wrong. Please try again" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    if (queue.transactions.count > 0) {
        for(SKPaymentTransaction *transaction in queue.transactions){
            if(transaction.transactionState == SKPaymentTransactionStateRestored){
                //called when the user successfully restores a purchase
                NSLog(@"Transaction state -> Restored");
                [FIRAnalytics logEventWithName:@"Restore_Sucess" parameters:nil];
                //if you have more than one in-app purchase product,
                //you restore the correct product for the identifier.
                //For example, you could use
                //if(productID == kRemoveAdsProductIdentifier)
                //to get the product identifier for the
                //restored purchases, you can use
                //
                //NSString *productID = transaction.payment.productIdentifier;
                [self doRemoveAds];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
        }
    }
    else {
        [FIRAnalytics logEventWithName:@"Restore_Failed" parameters:nil];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"🙁 Restore Error" message:@"You haven't purchased this item before. Please press Unclock instead." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        //if you have multiple in app purchases in your app,
        //you can get the product identifier of this transaction
        //by using transaction.payment.productIdentifier
        //
        //then, check the identifier against the product IDs
        //that you have defined to check which product the user
        //just purchased
        
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                    [FIRAnalytics logEventWithName:@"Payment_Canncelled" parameters:nil];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                NSLog(@"Something Wrong");
        }
    }
}

- (void)doRemoveAds {
    [NSNotificationCenter.defaultCenter postNotificationName:@"areAdsRemoved" object:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_viewContainer setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithRed:13/255.0 green:13/255.0 blue:13/255.0 alpha:1.0];
    if (_isPopup) {
        [self performSelector:@selector(dismissAfterPurchase) withObject:nil afterDelay:2];
    }
}

// MARK - Actions
- (IBAction)onPressEmailContact:(id)sender {
    [FIRAnalytics logEventWithName:@"Press_Contact" parameters:nil];
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"mailto:thitruongvo@gmail.com?subject=RandomTools"] options:@{} completionHandler:nil];
}
- (IBAction)onPressRestore:(id)sender {
    [FIRAnalytics logEventWithName:@"Press_Restore" parameters:nil];
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (IBAction)onPressUnlock:(id)sender {
    [FIRAnalytics logEventWithName:@"Press_Purchase" parameters:nil];
    if (_product) {
        [self purchase:self.product];
    }
}
- (IBAction)onPressNoThanks:(id)sender {
    [FIRAnalytics logEventWithName:@"Press_NoThanks" parameters:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissAfterPurchase {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
