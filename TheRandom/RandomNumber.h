//
//  RandomNumber.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "BaseViewController.h"
#import "UIView+Toast.h"

@interface RandomNumber : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,GADBannerViewDelegate>{
    IBOutlet UITextField* tfMin;
    IBOutlet UITextField* tfMax;
    IBOutlet UILabel* lbResult;
    IBOutlet UIButton* btnRecent;
    IBOutlet UIButton* btnRandomize;
    IBOutlet UILabel *lbDefault;
    IBOutlet UIButton *btnNoRepeats;
    NSArray* arrColor;
    NSMutableArray* arrRecent;
    int currentColorIndex;
    NSTimer* timer;
    int countTimer;
    int oldColorIndex;
    bool isRolling;
    bool isHoldButtonMode;
    bool isNoRepeat;
    bool isLoaded;
    int indexBeginNotRepeat;
    NSInteger minInput;
    NSInteger maxInput;
    IBOutlet NSLayoutConstraint* csHeighButtonIphone;
    IBOutlet NSLayoutConstraint* csHeighButtonIpad;
    IBOutlet NSLayoutConstraint* csButtonRecentBottomIphone;
    IBOutlet NSLayoutConstraint* csButtonRecentBottomIpad;
    IBOutlet NSLayoutConstraint *csResultCenterY;
    IBOutlet NSLayoutConstraint *csMinCenterY;
    IBOutlet NSLayoutConstraint *csMaxCenterY;
    
    bool isBannerIsVisible;
    GADBannerView* bannerAdmobView;
    bool isIphone;
}

@end
