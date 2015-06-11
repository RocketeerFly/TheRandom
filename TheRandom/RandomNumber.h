//
//  RandomNumber.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomNumber : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    IBOutlet UITextField* tfMin;
    IBOutlet UITextField* tfMax;
    IBOutlet UILabel* lbResult;
    IBOutlet UIButton* btnRecent;
    IBOutlet UIButton* btnRandomize;
    NSArray* arrColor;
    NSMutableArray* arrRecent;
    int currentColorIndex;
    NSTimer* timer;
    int countTimer;
    int oldColorIndex;
    bool isRolling;
}

@end
