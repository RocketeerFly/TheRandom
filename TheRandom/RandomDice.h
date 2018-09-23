//
//  RandomDice.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "BaseViewController.h"

@interface RandomDice : BaseViewController<UIAlertViewDelegate,GADBannerViewDelegate>{
    IBOutlet UIButton* btn1;
    IBOutlet UIButton* btn2;
    IBOutlet UIButton* btn3;
    IBOutlet NSLayoutConstraint* csHeighButtonIphone;
    IBOutlet NSLayoutConstraint* csHeighButtonIpad;
    IBOutlet NSLayoutConstraint* csHeighNumberIphone;
    IBOutlet NSLayoutConstraint* csHeighNumberButtonIpad;
    IBOutlet NSLayoutConstraint* csHeighFromCenter;
    IBOutlet UILabel* lbNumDices;
    IBOutlet UILabel* lbTip;
    IBOutlet UIButton* btnSound;
    IBOutlet UIButton *btnColor;
    NSMutableArray* arrDices;
    NSMutableArray* arrPosDices;
    NSArray* arrDiceColor;
    NSMutableArray* arrDiceRolled;
    int numDice;
    int diceSize;
    int maxLengthMove;
    int colorDiceIndex;
    CGPoint pointPlaceDice;
    UIColor* diceColor;
    CGRect diceArea;
    SystemSoundID sound1;
    bool isPlaySound;
    bool isLoadedAccessoryAlert;
    bool isRolled;
    UIAlertView* colorPicker;
    GADBannerView* bannerAdmobView;
    bool isBannerIsVisible;
}
@property (strong, nonatomic) IBOutlet UIView *colorPickerView;
@property (strong, nonatomic) NSArray* arrDiceColor;

@end
