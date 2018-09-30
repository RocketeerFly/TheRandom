//
//  BaseViewController.m
//  TheRandom
//
//  Created by RocketeerFly on 9/22/18.
//  Copyright © 2018 Rocketeer. All rights reserved.
//

#import "BaseViewController.h"
@import FirebaseAnalytics;

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:13/255.0 green:13/255.0 blue:13/255.0 alpha:1.0];
}
-(BOOL)areAdsRemoved {
    [FIRAnalytics logEventWithName:@"DidRemoveAds" parameters:nil];
    return [NSUserDefaults.standardUserDefaults boolForKey:@"areAdsRemoved"];
}
@end
