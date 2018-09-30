//
//  SettingViewController.h
//  TheRandom
//
//  Created by RocketeerFly on 9/26/18.
//  Copyright © 2018 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "BaseViewController.h"

@interface SettingViewController : BaseViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, assign) BOOL isPopup;
@end
