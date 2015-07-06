//
//  RandomDice.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RandomDice : UIViewController<UIAlertViewDelegate>{
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
    UIAlertView* colorPicker;
}
@property (strong, nonatomic) IBOutlet UIView *colorPickerView;

@end
